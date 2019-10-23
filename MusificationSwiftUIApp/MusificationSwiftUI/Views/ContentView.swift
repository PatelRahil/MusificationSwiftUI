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
    @State var isPresented = false
    var body: some View {
        Group {
            if userDataModel.uid != nil {
                TabView {
                        TrackedArtistsView()
                            .tabItem({
                                Image(systemName: "location")
                                Text("Tracked")
                            })
                            .tag(0)
                        GenresView(genres: $viewModel.genres)
                            .tabItem({
                                Image(systemName: "globe")
                                Text("Genres")
                            })
                            .tag(1)
                        ArtistsView()
                            .tabItem({
                                Image(systemName: "person")
                                Text("Artists")
                            })
                            .tag(2)
                }.navigationViewStyle(StackNavigationViewStyle())
            } else {
                NavigationView {
                    SignInView()
                }.navigationViewStyle(StackNavigationViewStyle())
            }
        }.onAppear {
            contentAppeared = true
            print("Content View appeared, id = \(self.userDataModel.uid ?? "No user id")")
        }.sheet(isPresented: self.$viewModel.presentPushArtist, onDismiss: {
            self.viewModel.presentPushArtist = false
        }) {
            ArtistInfoView(artist: self.$viewModel.selectedArtist, viewModel: self.viewModel, dataModel: self.userDataModel, isTracking: self.userDataModel.isTrackingBinding(for: self.viewModel.selectedArtist))
        }.popover(isPresented: self.$viewModel.isLoading) {
            Text("Loading")
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
