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
            didChange.send(self)
        }
    }
    func bindingIsTracking(artist: Artist) -> Binding<Bool> {
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
}
