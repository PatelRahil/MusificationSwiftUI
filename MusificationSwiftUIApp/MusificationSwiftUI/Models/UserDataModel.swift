//
//  UserDataModel.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 7/1/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class UserDataModel: ObservableObject {
    private var dbUserRoot = "/Users"
    var didChange = PassthroughSubject<UserDataModel, Never>()
    @Published var trackedArtists: [Artist] = []
    @Published var uid: String?
    func isTrackingBinding(for artist: Artist) -> Binding<Bool> {
        return Binding(get: {
            return self.trackedArtists.contains(artist)
        }) { (track) in
            if track {
                self.trackedArtists.append(artist)
            } else {
                self.trackedArtists.removeAll { $0 == artist }
            }
            self.updateDB()
        }
    }
    func loadTrackedArtists() {
        guard let uid = self.uid else { return }
        let observer = FirebaseRequest()
        observer.observe(path: "\(dbUserRoot)/\(uid)") { (snapshot) in
            guard let userData = snapshot.value as? [String: Any] else { return }
            guard let trackedArtistIds = userData["trackedArtists"] as? [String] else { return }
            self.getTrackedArtists(ids: trackedArtistIds, success: { artists in
                self.trackedArtists = artists
            })
        }
    }
    private func getTrackedArtists(ids: [String], success: @escaping ([Artist]) -> Void) {
        var trackedArtists: [Artist] = []
        for id in ids {
            MusicRequest.getArtist(id: id, success: { artist in
                trackedArtists.append(artist)
                success(trackedArtists)
            }) { error in
                print("Error getting tracked artists: \(error.localizedDescription)")
            }
        }
    }
    private func updateDB() {
        guard let uid = uid else { return }
        let requester = FirebaseRequest()
        requester.uploadData(path: "\(dbUserRoot)/\(uid)/trackedArtists", value: self.trackedArtists.map { $0.id })
    }
}
