//
//  Album.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/9/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import Foundation
import UIKit

class Album: DataParsable {
    typealias Parsable = Album
    //let urlPrefix = "https://api.music.apple.com"
    var albumUrl = ""
    var id = ""
    var artworkUrl = ""
    var releaseDate = ""
    var name = ""
    
    required init() {}
    
    func parseData<Parsable>(data albumData: [String : Any], success: @escaping (Parsable) -> Void, fail: @escaping (Error) -> Void) {
        if let _allAlbumData = albumData["data"] as? [[String: Any]] {
            if let allAlbumData = _allAlbumData.first {
                if let attributes = allAlbumData["attributes"] as? [String: Any] {
                    if let artwork = attributes["artwork"] as? [String: Any] {
                        if let artworkUrl = artwork["url"] as? String {
                            self.artworkUrl = artworkUrl
                        } else {
                            fail(CustomError("The data does not have \"artworkUrl\" or it is not String"))
                        }
                    } else {
                        fail(CustomError("The data does not have \"artwork\" or it is not [String: Any]"))
                    }
                    if let albumName = attributes["name"] as? String {
                        self.name = albumName
                    } else {
                        fail(CustomError("The data does not have \"name\" or it is not String"))
                    }
                    if let releaseDate = attributes["releaseDate"] as? String {
                        self.releaseDate = releaseDate
                    } else {
                        fail(CustomError("The data does not have \"releaseDate\" or it is not String"))
                    }
                    if let albumUrl = attributes["url"] as? String {
                        self.albumUrl = albumUrl
                    } else {
                        fail(CustomError("The data does not have \"albumUrl\" or it is not String"))
                    }
                } else {
                    fail(CustomError("The data does not have \"attributes\" or it is not [String: Any]."))
                }
                if let id = allAlbumData["id"] as? String {
                    self.id = id
                } else {
                    fail(CustomError("The data does not have \"id\" or it is not String."))
                }
            } else {
                fail(CustomError("The data array does not have any elements"))
            }
        } else {
            fail(CustomError("The albumData does not have \"data\" or data is not an array of String:Any dictionaries:\n\(albumData)"))
        }
        success(self as! Parsable)
    }
    
    func openURL(/*controller: UIViewController*/) {
        print("URL string: \(self.albumUrl)")
        if let url = URL(string: self.albumUrl) {
            UIApplication.shared.open(url)
            //let svc = SFSafariViewController(url: url)
            //controller.present(svc, animated: true, completion: nil)
        }
        
    }
}

extension Album: Hashable {
    static func == (lhs: Album, rhs: Album) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
