//
//  SignInView.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 7/5/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI

struct SignInView : View {
    @EnvironmentObject var userDataModel: UserDataModel
    var body: some View {
        VStack {
            GoogleSignInButton { uid in
                print("callback \(uid)")
                self.userDataModel.uid = uid
            }
        }
    }
}

#if DEBUG
struct SignInView_Previews : PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
#endif
