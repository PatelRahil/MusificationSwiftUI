//
//  CustomTab.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/9/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI

struct CustomTab : View, Hashable {
    var text, imageName: String
    var body: some View {
        VStack {
            Image(systemName: imageName)
            Text(text)
        }
    }
}

#if DEBUG
struct CustomTab_Previews : PreviewProvider {
    static var previews: some View {
        CustomTab(text: "Marked", imageName: "star")
    }
}
#endif
