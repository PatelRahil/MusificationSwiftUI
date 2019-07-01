//
//  AlbumsList.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/29/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI

struct AlbumsList : View {
    @Binding var albums: [Album]
    var body: some View {
        ScrollView(isScrollEnabled: true, alwaysBounceHorizontal: true, alwaysBounceVertical: false, showsHorizontalIndicator: true, showsVerticalIndicator: false) {
            HStack {
                ForEach(albums.identified(by: \.id)) { album in
                    AlbumButton(album: album)
                        .shadow(radius: Length(albumShadowRadius))
                    .padding()
                }
            }.frame(height: Length(albumSize + 2 * albumShadowRadius))
        }
    }
}

#if DEBUG
struct AlbumsList_Previews : PreviewProvider {
    @State static var albums = [Album()]
    static var previews: some View {
        AlbumsList(albums: $albums)
    }
}
#endif
