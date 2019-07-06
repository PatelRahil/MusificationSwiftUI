//
//  TrackedArtistsView.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/9/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI

struct TrackedArtistsView : View {
    @EnvironmentObject var dataModel: UserDataModel
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(dataModel.trackedArtists.identified(by: \.self)) { artist in
                        ArtistListItem(artist: artist)
                    }
                }
            }
            .navigationBarTitle(Text("Tracked Artists"))
        }
    }
}

#if DEBUG
struct TrackedArtistsView_Previews : PreviewProvider {
    static var previews: some View {
    TrackedArtistsView()
    }
}
#endif
