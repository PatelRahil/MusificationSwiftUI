//
//  GoogleInButton.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 7/5/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import SwiftUI
import Firebase

struct GoogleSignInButton: UIViewRepresentable {
    var colorScheme: ColorScheme
    let onSignIn: (String) -> Void
    func makeUIView(context: Context) -> GIDSignInButton {
        let btn = GIDSignInButton()
        btn.colorScheme = colorScheme == .dark ? .dark : .light
        btn.style = .standard
        return btn
    }
    func updateUIView(_ uiView: GIDSignInButton, context: Context) {
        
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(onSignIn: onSignIn)
    }
    
    class Coordinator: NSObject, GIDSignInUIDelegate, GIDSignInDelegate {
        var onSignIn: (String) -> Void
        init(onSignIn: @escaping (String) -> Void) {
            self.onSignIn = onSignIn
            super.init()
            GIDSignIn.sharedInstance()?.uiDelegate = self
            GIDSignIn.sharedInstance()?.delegate = self
            DispatchQueue.main.async {
                GIDSignIn.sharedInstance()?.signInSilently()
            }
        }
        func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
            
        }
        func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
            
        }
        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            if error != nil {
                print(error.debugDescription)
                return
            }
            print("Success! Signed in user \(signIn.currentUser.userID ?? " X - There was an issue and there is no current user or userID")")
            onSignIn(signIn.currentUser.userID)
        }
    }
}
