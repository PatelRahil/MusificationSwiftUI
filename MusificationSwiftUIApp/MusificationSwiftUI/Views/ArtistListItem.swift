//
//  ArtistListItem.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/10/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI

struct ArtistListItem : View {
    @State var artist: Artist
    @EnvironmentObject var viewModel: ContentViewModel
    @EnvironmentObject var dataModel: UserDataModel
    @State var isPresented = false
    var body: some View {
        Button(action: {
            self.isPresented = true
        }) {
            HStack {
                Text(artist.name)
                Spacer()
                Image(systemName: "info.circle.fill").foregroundColor(.gray)
            }
        }.sheet(isPresented: $isPresented) {
            ArtistInfoView(artist: self.$artist, viewModel: self.viewModel, dataModel: self.dataModel, isTracking: self.dataModel.isTrackingBinding(for: self.artist))
        }
    }
}

#if DEBUG
struct ArtistListItem_Previews : PreviewProvider {
    static var previews: some View {
        ArtistListItem(artist: Artist(name: "Bruno Mars", id: "0"))
    }
}
#endif
