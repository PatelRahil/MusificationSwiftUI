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
                TextField($searchString, placeholder: Text("Search Artists"), onEditingChanged: { (changed) in
                    self.viewModel.searchArtists(with: self.searchString)
                })
                .padding().textFieldStyle(.roundedBorder)
                Divider()
                List {
                    ForEach(viewModel.searchedArtists.identified(by: \.id)) { artist in
                        ArtistListItem(artist: artist)
                    }
                }
            }
            .navigationBarTitle(Text("Find Artists"))
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
