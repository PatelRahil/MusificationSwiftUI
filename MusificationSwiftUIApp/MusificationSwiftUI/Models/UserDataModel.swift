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
import Firebase

final class UserDataModel: ObservableObject {
    private var dbUserRoot = "/Users"
    var didChange = PassthroughSubject<UserDataModel, Never>()
    @Published var trackedArtists: [Artist] = []
    @Published var uid: String?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(onRecieveArtistId(_:)), name: .didRecievePushArtistId, object: nil)
    }
    
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
                DispatchQueue.main.async { self.trackedArtists = artists }
            })
        }
    }
    static func updatePushToken(for uid: String) {
        InstanceID.instanceID().instanceID { (res, err) in
            if let res = res {
                print("Token ID: \(res.token)")
                let requester = FirebaseRequest()
                requester.uploadData(path: "/Users/\(uid)/pushToken", value: res.token)
            }
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
    @objc private func onRecieveArtistId(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        print(userInfo)
        guard let id = userInfo["artistId"] as? String else { return }
        let pushArtist = trackedArtists.first { $0.id == id }
        guard let artist = pushArtist else { return }
        NotificationCenter.default.post(name: .didRecievePushArtist, object: artist, userInfo: nil)
    }
}
