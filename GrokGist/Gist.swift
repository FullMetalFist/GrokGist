//
//  Gist.swift
//  GrokGist
//
//  Created by Michael Vilabrera on 2/14/18.
//  Copyright © 2018 Michael Vilabrera. All rights reserved.
//

import Foundation

/*
 {"url":"https://api.github.com/gists/ccd28549044236567f4ea12deb5d0285",
 "forks_url":"https://api.github.com/gists/ccd28549044236567f4ea12deb5d0285/forks",
 "commits_url":"https://api.github.com/gists/ccd28549044236567f4ea12deb5d0285/commits",
 "id":"ccd28549044236567f4ea12deb5d0285",
 "git_pull_url":"https://gist.github.com/ccd28549044236567f4ea12deb5d0285.git",
 "git_push_url":"https://gist.github.com/ccd28549044236567f4ea12deb5d0285.git",
 "html_url":"https://gist.github.com/ccd28549044236567f4ea12deb5d0285",
 "files":{"playground.rs":{"filename":"playground.rs","type":"text/plain","language":"Rust","raw_url":"https://gist.githubusercontent.com/anonymous/ccd28549044236567f4ea12deb5d0285/raw/fa9489c443616a3c95b9ec816b8707f01fccdf40/playground.rs","size":367}},"public":true,"created_at":"2018-02-14T19:40:29Z","updated_at":"2018-02-14T19:40:29Z","description":"Rust code shared from the playground","comments":0,"user":null,"comments_url":"https://api.github.com/gists/ccd28549044236567f4ea12deb5d0285/comments","truncated":false},{"url":"https://api.github.com/gists/670752b139ce8ee1612cd447e23ec013","forks_url":"https://api.github.com/gists/670752b139ce8ee1612cd447e23ec013/forks","commits_url":"https://api.github.com/gists/670752b139ce8ee1612cd447e23ec013/commits","id":"670752b139ce8ee1612cd447e23ec013","git_pull_url":"https://gist.github.com/670752b139ce8ee1612cd447e23ec013.git","git_push_url":"https://gist.github.com/670752b139ce8ee1612cd447e23ec013.git","html_url":"https://gist.github.com/670752b139ce8ee1612cd447e23ec013","files":{"gistfile1.txt":{"filename":"gistfile1.txt","type":"text/plain","language":"Text","raw_url":"https://gist.githubusercontent.com/anonymous/670752b139ce8ee1612cd447e23ec013/raw/55e28220d9ae9b1749b9555c0c2a6fe0f633ef81/gistfile1.txt","size":94}},
 "public":true,
 "created_at":"2018-02-14T19:40:26Z",
 "updated_at":"2018-02-14T19:40:26Z",
 "description":"http://www.clubdelacom.fr/sites/default/files/formulaire_cv/psg_real_madrid_en_direct_live.pdf",
 "comments":0,
 "user":null,
 "comments_url":"https://api.github.com/gists/670752b139ce8ee1612cd447e23ec013/comments","truncated":false}
 */

class Gist {
    var id: String?
    var description: String?
    var ownerLogin: String?
    var ownerAvatarURL: String?
    var url: String?
    
    required init() { }
    
    required init?(json: [String: Any]) {
        guard let description = json["description"] as? String, let idValue = json["id"] as? String, let url = json["url"] as? String else {
            return nil
        }
        self.description = description
        self.id = idValue
        self.url = url
        
        if let ownerJson = json["owner"] as? [String: Any] {
            self.ownerLogin = ownerJson["login"] as? String
            self.ownerAvatarURL = ownerJson["avatar_url"] as? String
        }
    }
}
