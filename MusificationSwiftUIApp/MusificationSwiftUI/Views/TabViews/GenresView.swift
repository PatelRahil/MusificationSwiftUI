//
//  GenresView.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/9/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI

struct GenresView : View {
    @Binding var genres: [Genre]
    var body: some View {
        NavigationView {
            List {
                ForEach(genres, id: \.id) { genre in
                    GenreListItem(genre: genre)
                }
            }
            .navigationBarTitle(Text("Explore Genres"))
        }
    }
}

#if DEBUG
struct GenresView_Previews : PreviewProvider {
    @State static var genres = [Genre(), Genre(), Genre(), Genre(), Genre()]
    static var previews: some View {
        let genreNames = ["Pop", "Hip Hop", "Jazz", "Rock", "Classical"]
        for (index, genre) in genres.enumerated() {
            genre.name = genreNames[index]
            genre.id = UUID().description
        }
        return GenresView(genres: $genres)
    }
}
#endif
