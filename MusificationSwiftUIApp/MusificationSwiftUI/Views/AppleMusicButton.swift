//
//  AppleMusicButton.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/29/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI

struct AppleMusicButton : View {
    let openURL: () -> ()
    var body: some View {
        Button(action: {
            self.openURL()
        }) {
            VStack {
                Image(systemName: "music.note")
                Text("Apple Music")
            }
        }
    }
}

#if DEBUG
struct AppleMusicButton_Previews : PreviewProvider {
    static var previews: some View {
        AppleMusicButton(openURL: doNothing)
    }
    static func doNothing() {
        
    }
}
#endif
