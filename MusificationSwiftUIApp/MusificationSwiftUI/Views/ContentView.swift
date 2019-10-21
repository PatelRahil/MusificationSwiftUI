//
//  ContentView.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/5/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct ContentView : View {
    @EnvironmentObject var viewModel: ContentViewModel
    @EnvironmentObject var userDataModel: UserDataModel
    var body: some View {
        Group {
            if userDataModel.uid != nil {
                TabView {
                        TrackedArtistsView()
                            .tabItem({
                                Text("Tracked")
                            })
                            .tag(0)
                        GenresView(genres: $viewModel.genres)
                            .tabItem({
                                Text("Genres")
                            })
                            .tag(1)
                        ArtistsView()
                            .tabItem({
                                Text("Artists")
                            })
                            .tag(2)
                }
            } else {
                NavigationView {
                    SignInView()
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ContentViewModel())
    }
}
#endif

/*
 [Artist(name: "Bruno Mars", id: "1"),
 Artist(name: "Ariana Grande", id: "2"),
 Artist(name: "Michael Jackson", id: "3")]
 */
