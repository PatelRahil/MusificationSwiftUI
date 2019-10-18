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
        
        return VStack {
            Text(artist.name).bold().font(.largeTitle).padding()
            Divider()
            Toggle(isOn: isTracking) {
                Text("Tracking").bold()
            }
            .padding()
            .accentColor(Palette.primaryColor)
            Divider()
            HStack {
                Text("Albums").font(.headline).padding()
                Spacer()
            }
            AlbumsList(albums: $viewModel.displayedAlbums)
            Divider()
            AppleMusicButton(openURL: artist.openURL).padding()
            Spacer()
        }
        .navigationBarTitle(Text(artist.name))
            .onAppear {
                self.viewModel.fetchAlbums(for: self.artist)
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
