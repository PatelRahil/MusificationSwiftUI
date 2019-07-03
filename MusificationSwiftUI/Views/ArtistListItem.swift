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
    var body: some View {
        print("LIST ITEM: \(artist.name)")
        return NavigationButton(destination: ArtistInfoView(artist: $artist, isTracking: dataModel.bindingIsTracking(artist: artist)).environmentObject(viewModel)) {
            Text(artist.name)
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
