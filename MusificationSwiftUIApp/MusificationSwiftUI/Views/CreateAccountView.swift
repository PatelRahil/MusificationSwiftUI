//
//  CreateAccountView.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 7/5/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import SwiftUI
import Firebase

struct CreateAccountView : View {
    @State var emailTxt = ""
    @State var passwordTxt = ""
    @State var repeatPasswordTxt = ""
    @State var errorMsg = ""
    var userDataModel: UserDataModel
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Email").font(.headline)
                TextField("johndoe@email.com", text: $emailTxt)
                    .padding()
                Text("Password").font(.headline)
                SecureField("Must be 6 or more characters", text: $passwordTxt)
                    .padding()
                Text("Confirm Password").font(.headline)
                SecureField("Must be 6 or more characters", text: $repeatPasswordTxt)
                    .padding()
            }.padding(.leading, CGFloat(20))
            Button(action: { self.signUp() }) {
                Text("Create Account")
                    .padding([.top, .bottom], 20)
                    .padding([.leading, .trailing], 40)
            }
                .background(Palette.primaryColor)
                .cornerRadius(CGFloat(40))
                .padding()
                .accentColor(.white)
            Text(errorMsg)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                //.padding([.leading, .trailing], 20)
            
        }
    }
    func signUp() {
        if self.passwordTxt != self.repeatPasswordTxt {
            self.errorMsg = "Your passwords do not match. Try again."
            return
        }
        Auth.auth().createUser(withEmail: self.emailTxt, password: self.passwordTxt) { (res, err) in
            if let err = err {
                print(err.localizedDescription)
                self.errorMsg = err.localizedDescription
                return
            }
            if let res = res {
                self.userDataModel.uid = res.user.uid
            }
        }
    }
}

#if DEBUG
struct CreateAccountView_Previews : PreviewProvider {
    static var previews: some View {
        CreateAccountView(userDataModel: UserDataModel())
    }
}
#endif
