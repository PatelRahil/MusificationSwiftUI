const functions = require('firebase-functions');
const admin = require('firebase-admin')
const path = require('path')
const fetch = require('node-fetch')
admin.initializeApp()

const keyPath = path.join(__dirname, 'keys.json')
const key = require(keyPath).apple_music
//console.log(keyPath)
//const appleMusicKey = (JSON.parse(keyData))
//console.log("APPLE MUSIC KEY: ", key)

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.updatePushArtistsList = functions.database.ref('/Users/{uid}').onWrite((change, context) => {
	console.log('Updating push artists list...')
	const before = change.before.exists() ? change.before.val() : null
	const after = change.after.exists() ? change.after.val() : null
	const remove = before.length > after.length
	console.log('CONTEXT: ', context)
	console.log('change before: ', before)
	if (!before['pushToken'] || !after['pushToken'] || before['pushToken'] !== after['pushToken']) {
		// Function was triggered by push token being changed
		// Makes assumption that trackedArtists won't change at the same time as pushToken changing
		// And assumption that trackedArtists won't change if pushToken is added for the first time or removed, or the user does not have a pushToken
		return 1
	}
	var pushID  = before['pushToken']
	console.log('pushID: ', pushID)
	console.log('new artist added')
	var diff = after['trackedArtists'].filter(i => (before['trackedArtists'].indexOf(i) < 0))
	if (diff.length === 0) {
		diff = before['trackedArtists'].filter(i => (after['trackedArtists'].indexOf(i) < 0))
	}
	return admin.database().ref('/TrackingAppleArtists').once('value', (snap) => {
		console.log('Tracked apple artists: \n', snap.val(), '\ndiff:\n', diff)
		var val = snap.val()

		if (diff.length === 0) {
			return null
		}
		const newArtistID = diff[0]
		var tokens
		if (newArtistID in val) {
			tokens = val[newArtistID]['pushTokens']
			if (remove) {
				tokens = tokens.filter(val => val !== pushID)
			} else {
				tokens.push(pushID)
			}
		} else {
			// artist being tracked for the first time
			// don't have to check for removed because if an artist was not tracked by anyone,
			// no one can untrack them
			tokens = [pushID]
		}
		console.log(context.params.uid, '\n', before, '\n', after, '\nTokens:\n', tokens)
		return admin.database().ref('/TrackingAppleArtists/' + newArtistID + '/pushTokens').set(tokens)
	})
})

exports.testDiffArtists = functions.https.onRequest((req, res) => {
	admin.database().ref('/ArtistsMostRecentSong').once('value', (snap) => {
		console.log(snap.val())
		if (!snap.val()) {
			res.status(200).send('No artists to diff')
			return false
		}
		const val = snap.val()
		var keys = Object.keys(snap.val())
		var ret = val
		ret['keys'] = keys
        var promises = [[]]
        var headers = {
  			"Authorization": 'Bearer ' + key
		}
		for (let i = 0; i < keys.length; i++) {
			url = 'https://api.music.apple.com/v1/catalog/us/artists/' + keys[i] + '/songs'
			promises.push(fetch(url, { method: 'GET', headers: { 'Authorization': 'Bearer ' + key }}).then((res) => {
				let json = res.json()
				console.log(json)
				return json
			}))
		}
		return Promise.all(promises).then( (result) => {
			result.shift()
			console.log(result)
			var dicts = {}
			var changes = {}
			for (let i = 0; i < result.length; i++) {
				let id = keys[i]
				let artist = result[i]['data']
				dicts[id] = []
				console.log('val: ', val[id])
				var newestId = val[id][0]['songId']
				var newestDate = new Date(Date.parse(val[id][0]['date']))
				for (let j = 0; j < artist.length; j++) {
					let song = artist[j]
					let songId = song['id']
					let date = new Date(Date.parse(song['attributes']['releaseDate']))
					console.log('Date: ', date)
					console.log('Newest Date: ', newestDate)
					if (date > newestDate) {
						// This is the case where one of the incoming songs is newer than the previously checked songs.
						// newestDate is initially the date of the song currently listed as most recent in the database.
						let dateStr = date.toISOString().split('T')[0]
						changes[id] = [{
							'songId': songId,
							'date': dateStr
						}]
						newestDate = date
					}
					if (date.toString() === newestDate.toString()) {
						let dateStr = date.toISOString().split('T')[0]
						// This only occurs if the current newest song in the database has the same release date as one of the incoming songs.
						// This will rarely happen in practice.
						if (!changes[id] && newestId !== songId) {
							changes[id] = [{
								'songId': newestId,
								'date': dateStr
							}]
						}
						if (changes[id] && newestId !== songId) {
							// Makes sure nothing happens if there are no new songs yet and the incoming song is the one that is already in the database.
							// This allows us to easily check if the newest song listed in the database for this artist needs to be changed
							// by checking if !changed[id] once all the songs have been checked.
							changes[id].push({
								'songId': songId,
								'date': dateStr
							})
						}
					}
					dicts[id].push({ songId: songId, date: date })
				}

				if (changes[id]) {
					admin.database().ref('/ArtistsMostRecentSong/' + id).set(changes[id])
				}
			}

			ret['promises'] = dicts
			ret['changes'] = changes
			res.status(200).send(ret)
			return true
		}).catch(error => console.log(error))
	})
})

/*
exports.scheduledFunction = functions.pubsub.schedule('every 12 hours').onRun((context) => {
  console.log('This will be run every 12 hours!');
});

async function getNumSongsForArtists(artists) {
	for (const artistID of artists) {

	}
}
*/

