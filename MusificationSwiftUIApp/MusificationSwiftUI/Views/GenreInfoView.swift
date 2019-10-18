//
//  GenreTopArtists.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/29/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI

struct GenreInfoView : View {
    @EnvironmentObject var viewModel: ContentViewModel
    var genre: Genre
    @State var numSongs = defaultSongItemsLimit
    var body: some View {
        List {
            ForEach(viewModel.displayedSongs, id: \.name) { song in
                SongListItem(song: song)
            }
            if self.numSongs < 180 {
                Button(action: {
                    self.numSongs += 20
                    self.viewModel.fetchSongs(for: self.genre, limit: self.numSongs)
                }) {
                    HStack {
                        Spacer()
                        Text("More").foregroundColor(.blue)
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            self.viewModel.fetchSongs(for: self.genre, limit: self.numSongs)
        }
        .navigationBarTitle(Text("Top \(genre.name)"))
    }
}

#if DEBUG
struct GenreInfoView_Previews : PreviewProvider {
    static var previews: some View {
        GenreInfoView(genre: Genre())
    }
}
#endif
