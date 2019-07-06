//
//  SignInView.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 7/5/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI
import Firebase

struct SignInView : View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @EnvironmentObject var userDataModel: UserDataModel
    @State var emailTxt = ""
    @State var passwordTxt = ""
    var body: some View {
        VStack {
            Spacer()
            TextField($emailTxt, placeholder: Text("Email"), onEditingChanged: { (changed) in
                
            }) {
                
            }
                .padding()
                .border(Color.primary, cornerRadius: 10)
                .padding([.leading, .trailing])
            SecureField($passwordTxt, placeholder: Text("Password"), onCommit: {
                
            })
                .padding()
                .border(Color.primary, cornerRadius: 10)
                .padding([.leading, .trailing])
            Button(action: {
                self.signIn(email: self.emailTxt, password: self.passwordTxt)
            }) {
                return Text("Sign In")
            }
                .padding()
                .frame(width: 200)
                .background(Palette.primaryColor)
                .cornerRadius(40)
                .shadow(radius: 4)
                .accentColor(.white)
                .padding(.bottom)
            Divider()
            GoogleSignInButton(colorScheme: self.colorScheme) { uid in
                self.userDataModel.uid = uid
                self.userDataModel.loadTrackedArtists()
            }
                .frame(width: 150)
                .padding(.top)
            Spacer()
            PresentationButton(destination: CreateAccountView(userDataModel: userDataModel)) {
                Text("Create an account")
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let error = err {
                print(error)
                return
            }
            if let result = res {
                print(result.user.uid)
                self.userDataModel.uid = result.user.uid
                self.userDataModel.loadTrackedArtists()
            }
        }
    }
}

#if DEBUG
struct SignInView_Previews : PreviewProvider {
    static var previews: some View {
        SignInView().environmentObject(UserDataModel())
    }
}
#endif
