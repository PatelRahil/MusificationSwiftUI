//
//  AlbumButton.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/29/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI

struct AlbumButton : View {
    let album: Album
    var body: some View {
        Button(action: {
            self.album.openURL()
        }) {
            ZStack {
                Palette.primaryColor
                VStack {
                    Text(album.name)
                        .frame(width: CGFloat(albumSize), height: CGFloat(albumSize))
                    .multilineTextAlignment(.center)
                }
            }
        }.lineLimit(nil)
        .cornerRadius(10)
        .accentColor(.white)
    }
}

#if DEBUG
struct AlbumButton_Previews : PreviewProvider {
    static var previews: some View {
        AlbumButton(album: Album())
    }
}
#endif
