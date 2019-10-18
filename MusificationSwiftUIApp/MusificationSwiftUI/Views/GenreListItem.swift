//
//  GenreListItem.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/29/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI

struct GenreListItem : View {
    var genre: Genre
    var body: some View {
        NavigationLink(destination: GenreInfoView(genre: genre)) {
            Text(genre.name)
        }
    }
}

#if DEBUG
struct GenreListItem_Previews : PreviewProvider {
    static var previews: some View {
        GenreListItem(genre: Genre())
    }
}
#endif
