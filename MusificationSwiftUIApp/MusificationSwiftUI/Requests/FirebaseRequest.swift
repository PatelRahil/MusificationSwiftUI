//
//  FirebaseRequest.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 7/5/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseRequest {
    let db = Database.database()
    func observe(path: String, callback: @escaping (DataSnapshot) -> ()) {
        let ref = db.reference(withPath: path)
        ref.observeSingleEvent(of: .value) { snapshot in
            callback(snapshot)
        }
    }
    func makeSingleObserver(path: String) {
        
    }
    func uploadData(path: String, value: Any?) {
        let ref = db.reference(withPath: path)
        ref.setValue(value)
    }
}
