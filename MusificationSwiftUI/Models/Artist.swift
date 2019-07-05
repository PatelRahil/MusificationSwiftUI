//
//  Artist.swift
//  MusificationSwiftUI
//
//  Created by Rahil Patel on 6/9/19.
//  Copyright © 2019 Rahil. All rights reserved.
//

import Foundation
import UIKit


class Artist: DataParsable {
    typealias Parsable = Artist
    var name: String = ""
    var id: String = ""
    var appleMusicUrlString: String = ""
    var albumsData: [String:Any] = [:]
    var albumUrlStrings: [String] = []
    
    required init() {}
    convenience init(name: String, id: String) {
        self.init()
        self.name = name
        self.id = id
    }
    func parseData<Parsable>(data artistData: [String:Any], success: @escaping (_ result: Parsable) -> Void, fail: @escaping (_ error: Error) -> Void) {
        print("Artist Data: \n\(artistData)")
        if let id = artistData["id"] as? String {
            self.id = id
        } else {
            fail(CustomError("artist data does not have an id or id is not a String."))
        }
        if let attributes = artistData["attributes"] as? [String:Any] {
            if let name = attributes["name"] as? String {
                self.name = name
            } else {
                fail(CustomError("artist attributes does not have a name or name is not a String."))
            }
            if let urlString = attributes["url"] as? String {
                self.appleMusicUrlString = urlString
            } else {
                fail(CustomError("artist attributes does not have a url or url is not a String."))
            }
        } else {
            fail(CustomError("artist data does not have attributes or attributes is not a dictionary of String:Any pairs."))
        }
        if let relationships = artistData["relationships"] as? [String:Any] {
            if let albumsDict = relationships["albums"] as? [String: Any] {
                if let albumsData = albumsDict["data"] as? [[String: String]] {
                    var hrefs: [String] = []
                    for albumData in albumsData {
                        if let href = albumData["href"] {
                            hrefs.append(href)
                        }
                    }
                    self.albumUrlStrings = hrefs
                }
            }
        }
        let ret = self as! Parsable
        success(ret)
    }
    
    func openURL(/*controller: UIViewController*/) {
        print("URL string is invalid: \(self.appleMusicUrlString)?")
        if let url = URL(string: self.appleMusicUrlString) {
            UIApplication.shared.open(url)
            //let svc = SFSafariViewController(url: url)
            //controller.present(svc, animated: true, completion: nil)
        }
        
    }
    func downloadAlbums(success: @escaping (_ result: [Album]) -> Void, fail: @escaping (_ error: Error) -> Void) {
        MusicRequest.getAlbums(with: albumUrlStrings, success: { albums in
            success(albums)
        }) { error in
            fail(error)
        }
    }
}

extension Artist: Hashable {
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
