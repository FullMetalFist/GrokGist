//
//  GithubAPIManager.swift
//  GrokGist
//
//  Created by Michael Vilabrera on 2/14/18.
//  Copyright © 2018 Michael Vilabrera. All rights reserved.
//

import Foundation
import Alamofire

class GithubAPIManager {
    static let sharedInstance = GithubAPIManager()
    
    func printPublicGists() {
        Alamofire.request(GistRouter.getPublic()).responseString { response in
            
            if let receivedString = response.result.value {
                print(receivedString)
            }
        }
    }
}
