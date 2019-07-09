const functions = require('firebase-functions');
const admin = require('firebase-admin')
const path = require('path')
admin.initializeApp()

const keyPath = path.join(__dirname, 'keys.json')
const keyData = require(keyPath).apple_music
console.log(keyPath)
//const appleMusicKey = (JSON.parse(keyData))
console.log("APPLE MUSIC KEY: ", keyData)

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.updatePushArtistsList = functions.database.ref('/Users/{uid}/trackedArtists').onWrite((change, context) => {
	console.log('Updating push artists list...')
	var pushID  = "00009" // temp, for testing
	const before = change.before.exists() ? change.before.val() : null
	const after = change.after.exists() ? change.after.val() : null
	const remove = before.length > after.length

	console.log('new artist added')
	var diff = after.filter(i => (before.indexOf(i) < 0))
	if (diff.length === 0) {
		diff = before.filter(i => (after.indexOf(i) < 0))
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

/*
exports.scheduledFunction = functions.pubsub.schedule('every 12 hours').onRun((context) => {
  console.log('This will be run every 12 hours!');
});

async function getNumSongsForArtists(artists) {
	for (const artistID of artists) {

	}
}
*/

