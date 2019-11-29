//
//  ArtistInfoView.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/10/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI

struct ArtistInfoView : View {
    @Binding var artist: Artist
    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var dataModel: UserDataModel
    var isTracking: Binding<Bool>
    var body: some View {
        
        VStack {
            Text(artist.name).bold().font(.largeTitle).padding()
            Divider()
            Toggle("", isOn: isTracking).toggleStyle(CustomToggleStyle(label: "Tracking", onColor: Color("Purple")))
            .padding()
            .accentColor(Palette.primaryColor)
            Divider()
            HStack {
                Text("Albums").font(.headline).padding()
                Spacer()
            }
            AlbumsList(albums: $viewModel.displayedAlbums).animation(.easeIn)
            Divider()
            if viewModel.recentSongs.count > 0 {
                Group {
                    HStack {
                        Text("Most Recent Song\(viewModel.recentSongs.count == 1 ? "" : "s") (Released on \(viewModel.recentDate))").font(.headline).padding()
                        Spacer()
                    }
                    List(viewModel.recentSongs, id: \.name) { song in
                        HStack {
                            Text(song.name).padding()
                            Spacer()
                        }
                    }
                    Divider()
                }.animation(.easeIn)
            }
            AppleMusicButton(openURL: artist.openURL).padding()
            Spacer()
        }
        .navigationBarTitle(Text(artist.name))
        .onAppear {
            withAnimation {
                self.viewModel.fetchAlbums(for: self.artist)
                self.viewModel.getRecentSongs(for: self.artist)
            }
        }
        .onDisappear {
            withAnimation {
                self.viewModel.resetSelectedArtist()
            }
        }
        
    }
}

/*
#if DEBUG
struct ArtistInfoView_Previews : PreviewProvider {
    @State static var artist = Artist(name: "Bruno Mars", id: "1")
    @State static var isTracking = false
    static var previews: some View {
        ArtistInfoView(artist: $artist, isTracking: UserDataModel().bindingIsTracking(artist: Artist()))
    }
}
#endif
*/
