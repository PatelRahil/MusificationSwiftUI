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
	const before = change.before.val()['trackedArtists'] ? change.before.val()['trackedArtists'] : null
	const after = change.after.val()['trackedArtists'] ? change.after.val()['trackedArtists'] : null
	const remove = before === null ? false : after === null ? true : before.length > after.length
	if (!change.before.val()['pushToken'] || !change.after.val()['pushToken'] || change.before.val()['pushToken'] !== change.after.val()['pushToken']) {
		// Function was triggered by push token being changed
		// Makes assumption that trackedArtists won't change at the same time as pushToken changing
		// And assumption that trackedArtists won't change if pushToken is added for the first time or removed, or the user does not have a pushToken
		return 1
	}
	var pushID  = change.before.val()['pushToken']
	var diff = before ? after.filter(i => (before.indexOf(i) < 0)) : after
	if (diff.length === 0) {
		diff = after ? before.filter(i => (after.indexOf(i) < 0)) : before
	}
	return admin.database().ref('/TrackingAppleArtists').once('value', (snap) => {
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
		return admin.database().ref('/TrackingAppleArtists/' + newArtistID + '/pushTokens').set(tokens)
	})
})

// If a new artist is being tracked, this function is called so that the artist is added to the ArtistsMostRecentSong list
exports.updateArtistRecentSong = functions.database.ref('/TrackingAppleArtists/{artistId}').onWrite((change, context) => {
	if (change.before.exists()) {
		// Don't do anything if the artist was there before
		// This occurs whenever a new push token is added to an already existing artist
		// This still needs to be tested ( script: have multiple devices add the same artist and see if the rest of this function is run or not )
		return 1
	}
	const artistId = context['params']['artistId']
	const url = 'https://api.music.apple.com/v1/catalog/us/artists/' + artistId + '/songs'
	return fetch(url, { method: 'GET', headers: { 'Authorization': 'Bearer ' + key }}).then((res) => {
		let json = res.json()
		return json
	}).then(res => {
		const data = res['data']
		newestSongs = []
		newestDate = null
		for (let i = 0; i < data.length; i++) {
			const song = data[i]
			const songId = song['id']
			const date = new Date(Date.parse(song['attributes']['releaseDate']))
			const artistName = song['attributes']['artistName']
			const songName = song['attributes']['name']
			if (newestSongs.length === 0 || date > newestDate) {
				let dateStr = date.toISOString().split('T')[0]
				newestSongs = [{
					'songId': songId,
					'date': dateStr,
					'artistName': artistName,
					'songName': songName
				}]
				newestDate = date
			} else if (date.toString() === newestDate.toString()) {
				let dateStr = date.toISOString().split('T')[0]
				newestSongs.push({
					'songId': songId,
					'date': dateStr,
					'artistName': artistName,
					'songName': songName
				})
			}
		}
		return admin.database().ref('/ArtistsMostRecentSong/' + artistId).set(newestSongs)
	})
})

exports.sendPushForNewSongs = functions.database.ref('/ArtistsMostRecentSong/{id}').onWrite((change, context) => {
	if (!change.before.exists()) {
		// Don't do anything if the artist was just now added to the list
		// That is the only scenario that this ref's value should change, other than if there is a new song releaesed.
		return 1
	}
	const id = context['params']['id']
	return admin.database().ref('/TrackingAppleArtists/' + id + '/pushTokens').once('value', (snap) => {
		const val = change.after.val()
		var body = ""
		var title = ""
		if (val.length > 1) {
			title = val[0]['artistName'] + ' came out with ' + val.length + ' new songs!'
			body = "The new songs are"
			for (let i = 0; i < val.length; i++) {
				if (i === val.length - 1) {
					body += ' and'
				}
				body += ' "' + val[i]['songName'] + '",'
			}
			body += ' and they were released on ' + val[0]['date']
		} else {
			title = val[0]['artistName'] + ' came out with a new song!'
			body = 'The new song is "' + val[0]['songName'] + '", and it was released on ' + val[0]['date']
		}
		const payload = {
        	notification: {
          		title: title,
          		body: body
          		// icon: follower.photoURL
        	}
      	}
      	const tokens = snap.val()
      	return admin.messaging().sendToDevice(tokens, payload).then(res => {
      		return res
      	})

	})
})

exports.updatePushTokens = functions.database.ref('/Users/{uid}/pushToken').onWrite((change, context) => {
	if (!change.before.exists()) {
		// There was no push token for this user before
		return 1
	}
	let oldToken = change.before.val()
	let newToken = change.after.exists() ? change.after.val() : null
	let uid = context['params']['uid']
	return admin.database().ref('/Users/' + uid + '/trackedArtists').once('value', (snap) => {
		let artistIds = snap.val()
		var promises = []
		for (let i = 0; i < artistIds.length; i++) {
			artistId = artistIds[i]
			promises.push(admin.database().ref('/TrackingAppleArtists/' + artistId + '/pushTokens').once('value', (snapshot) => {
				return snapshot.val()
			}).then(res => {
				return res
			}))
		}
		return Promise.all(promises).then( (res) => {

			console.log("RES: ", res[0].val())
			for (let i = 0; i < res.length; i++) {
				let artist = res[i].val()
				let artistId = artistIds[i]
				var tokens = []
				for (let j = 0; j < artist.length; j++) {
					let token = artist[j]
					if (token !== oldToken) {
						tokens.push(token)
					}
				}
				tokens.push(newToken)
				admin.database().ref('/TrackingAppleArtists/' + artistId + '/pushTokens').set(tokens)
			}
			return res[0].val()
		})
	})
})

exports.testDiffArtists = functions.https.onRequest((req, res) => {
	admin.database().ref('/ArtistsMostRecentSong').once('value', (snap) => {
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
			const url = 'https://api.music.apple.com/v1/catalog/us/artists/' + keys[i] + '/songs'
			promises.push(fetch(url, { method: 'GET', headers: { 'Authorization': 'Bearer ' + key }}).then((res) => {
				let json = res.json()
				return json
			}))
		}
		return Promise.all(promises).then( (result) => {
			result.shift()
			var dicts = {}
			var changes = {}
			for (let i = 0; i < result.length; i++) {
				let id = keys[i]
				let artist = result[i]['data']
				dicts[id] = []
				var newestId = val[id][0]['songId']
				var newestDate = new Date(Date.parse(val[id][0]['date']))
				var newestArtistName = val[id][0]['artistName'] === null ? "" : val[id][0]['artistName']
				var newestSongName = val[id][0]['songName'] === null ? "" : val[id][0]['songName']
				for (let j = 0; j < artist.length; j++) {
					let song = artist[j]
					let songId = song['id']
					let date = new Date(Date.parse(song['attributes']['releaseDate']))
					let artistName = song['attributes']['artistName']
					let songName = song['attributes']['name']
					if (date > newestDate) {
						// This is the case where one of the incoming songs is newer than the previously checked songs.
						// newestDate is initially the date of the song currently listed as most recent in the database.
						let dateStr = date.toISOString().split('T')[0]
						changes[id] = [{
							'songId': songId,
							'date': dateStr,
							'artistName': artistName,
							'songName': songName
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
								'date': dateStr,
								'artistName': artistName,
								'songName': songName
							}]
						}
						if (changes[id] && newestId !== songId) {
							// Makes sure nothing happens if there are no new songs yet and the incoming song is the one that is already in the database.
							// This allows us to easily check if the newest song listed in the database for this artist needs to be changed
							// by checking if !changed[id] once all the songs have been checked.
							changes[id].push({
								'songId': songId,
								'date': dateStr,
								'artistName': artistName,
								'songName': songName
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

