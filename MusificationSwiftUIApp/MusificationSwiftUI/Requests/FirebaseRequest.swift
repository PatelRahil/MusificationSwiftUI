//
//  FirebaseRequest.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 7/5/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseRequest {
    let db = Database.database()
    func observe(path: String, callback: @escaping (DataSnapshot) -> ()) {
        let ref = db.reference(withPath: path)
        ref.observeSingleEvent(of: .value) { snapshot in
            callback(snapshot)
        }
    }
    func makeSingleObserver(path: String) {
        
    }
    func uploadData(path: String, value: Any?) {
        let ref = db.reference(withPath: path)
        ref.setValue(value)
    }
    func getRecentSongs(for artistId: String, callback: @escaping ([Song], String) -> ()) {
        self.observe(path: "ArtistsMostRecentSong/\(artistId)") { (snap) in
            if let data = snap.value as? [[String: String]] {
                var songs: [Song] = []
                var date = ""
                for songData in data {
                    let song = Song()
                    song.artist = songData["artistName"] ?? ""
                    song.name = songData["songName"] ?? ""
                    songs.append(song)
                    date = songData["date"] ?? ""
                }
                callback(songs, date)
            }
        }
    }
}
