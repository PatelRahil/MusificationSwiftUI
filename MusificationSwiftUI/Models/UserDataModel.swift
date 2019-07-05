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

final class UserDataModel: BindableObject {
    var didChange = PassthroughSubject<UserDataModel, Never>()
    var trackedArtists: [Artist] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
    var uid: String? {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
    func isTrackingBinding(for artist: Artist) -> Binding<Bool> {
        return Binding(getValue: {
            return self.trackedArtists.contains(artist)
        }) { (track) in
            if track {
                self.trackedArtists.append(artist)
            } else {
                self.trackedArtists.removeAll { $0 == artist }
            }
        }
    }
    func getTrackedArtists
}
