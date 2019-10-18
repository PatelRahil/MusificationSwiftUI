//
//  SongListItem.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/29/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI

struct SongListItem : View {
    var song: Song
    @EnvironmentObject var viewModel: ContentViewModel
    @EnvironmentObject var dataModel: UserDataModel
    @State var artistLoaded = false
    var body: some View {
        Button(action: {
            self.viewModel.fetchArtist(named: self.song.artist, success: {
                self.artistLoaded = true
            })
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text(song.name).bold()
                    Text(song.artist)
                }
            //    .padding()
                Spacer()
                Image(systemName: "info.circle.fill").foregroundColor(.gray)
            }
        }
        .sheet(isPresented: $artistLoaded, content: {
            ArtistInfoView(artist: self.$viewModel.selectedArtist, viewModel: self.viewModel, dataModel: self.dataModel, isTracking: self.dataModel.isTrackingBinding(for: self.viewModel.selectedArtist))
        })
    }
}

#if DEBUG
struct SongListItem_Previews : PreviewProvider {
    static var previews: some View {
        SongListItem(song: Song())
    }
}
#endif
