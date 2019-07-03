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
    var body: some View {

        NavigationButton(destination: ArtistInfoView(artist: $viewModel.selectedArtist, isTracking: dataModel.isTracking(artist: viewModel.selectedArtist)), isDetail: true, onTrigger: { () -> Bool in
            self.viewModel.fetchArtist(named: self.song.artist)
            return true
        }) {
            VStack(alignment: .leading) {
                Text(song.name).bold()
                Text(song.artist)
            }
        }
    }
}

#if DEBUG
struct SongListItem_Previews : PreviewProvider {
    static var previews: some View {
        SongListItem(song: Song())
    }
}
#endif
