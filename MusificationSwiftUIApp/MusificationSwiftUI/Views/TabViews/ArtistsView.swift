//
//  ArtistsView.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/9/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI

struct ArtistsView : View {
    @State var searchString: String = ""
    @EnvironmentObject var viewModel: ContentViewModel
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Artists", text: $searchString, onEditingChanged: { (changed) in
                    self.viewModel.searchArtists(with: self.searchString)
                }) {
                    
                }
                .padding().textFieldStyle(RoundedBorderTextFieldStyle())
                Divider()
                List {
                    ForEach(viewModel.searchedArtists, id: \.id) { artist in
                        ArtistListItem(artist: artist)
                    }
                }
            }
            .navigationBarTitle("Find Artists")
        }
    }
}

#if DEBUG
struct ArtistsView_Previews : PreviewProvider {
    static var previews: some View {
        ArtistsView()
    }
}
#endif
