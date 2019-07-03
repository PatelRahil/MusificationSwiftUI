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
    var trackedArtistAppleMusicIds: [String] = [] {
        didSet {
            didChange.send(self)
        }
    }
    func isTracking(artist: Artist) -> Bool {
        return trackedArtistAppleMusicIds.contains(artist.id)
    }
}
