//
//  ContentViewModel.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/15/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class ContentViewModel: BindableObject {
    var didChange = PassthroughSubject<ContentViewModel, Never>()
    var trackedArtists: [Artist] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
    var genres: [Genre] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
    var searchedArtists: [Artist] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
    var displayedAlbums: [Album] = [] {
        didSet {
            DispatchQueue.main.async {
                self.didChange.send(self)
            }
        }
    }
    func fetchTrackedArtists() {
        
    }
    func fetchGenres() {
        MusicRequest.getGenres(success: { genres in
            self.genres = genres
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func searchArtists(with prefix: String) {
        MusicRequest.getArtistsStarting(with: prefix, limit: 10, success: { artists in
            self.searchedArtists = artists
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func fetchAlbums(for artist: Artist) {
        artist.downloadAlbums(success: { albums in
            self.displayedAlbums = albums
        }) { error in
            print(error.localizedDescription)
        }
    }
}
