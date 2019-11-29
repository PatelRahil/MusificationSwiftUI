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
        ScrollView([.horizontal], showsIndicators: true) {
            HStack {
                ForEach(albums, id: \.id) { album in
                    self.albumButton(album: album)
                }
            }.frame(height: CGFloat(albumSize + 2 * albumShadowRadius + 20))
        }
    }
    func albumButton(album: Album) -> some View {
        let button = AlbumButton(album: album)
        .shadow(radius: CGFloat(albumShadowRadius))
        .padding()
        return button
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
