//
//  TrackedArtistsView.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/9/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI

struct TrackedArtistsView : View {
    var tracked: [Artist]
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(tracked.identified(by: \.self)) { artist in
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
    TrackedArtistsView(tracked: [
        Artist(name: "Bruno", id: "1"),
        Artist(name: "Ariana", id: "2"),
        Artist(name: "Michael", id: "3")
        ])
    }
}
#endif
