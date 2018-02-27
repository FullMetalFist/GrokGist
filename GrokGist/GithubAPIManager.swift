//
//  GithubAPIManager.swift
//  GrokGist
//
//  Created by Michael Vilabrera on 2/14/18.
//  Copyright © 2018 Michael Vilabrera. All rights reserved.
//

import UIKit
import Alamofire

enum GitHubAPIManagerError: Error {
    case network(error: Error)
    case apiProvidedError(reason: String)
    case authCouldNot(reason: String)
    case authLost(reason: String)
    case objectSerialization(reason: String)
}

class GithubAPIManager {
    static let sharedInstance = GithubAPIManager()
    
    func printPublicGists() {
        Alamofire.request(GistRouter.getPublic()).responseString { response in
            
            if let receivedString = response.result.value {
                print(receivedString)
            }
        }
    }
    
    func fetchPublicGists(completionHandler: @escaping (Result<[Gist]>) -> Void) {
        Alamofire.request(GistRouter.getPublic()).responseJSON { response in
            let result = self.gistArrayFromResponse(response: response)
            
            completionHandler(result)
        }
    }
    
    func imageFrom(urlString: String, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let _ = Alamofire.request(urlString).response { dataResponse in
            guard let data = dataResponse.data else {
                completionHandler(nil, dataResponse.error)
                return
            }
            
            let image = UIImage(data: data)
            completionHandler(image, nil)
        }
    }
    
    private func gistArrayFromResponse(response: DataResponse<Any>) -> Result<[Gist]> {
        guard response.result.error == nil else {
            print(response.result.error!)
            return .failure(GitHubAPIManagerError.network(error: response.result.error!))
        }
        
        guard let jsonArray = response.result.value as? [[String: Any]] else {
            print("didn't get array of gists as JSON")
            return .failure(GitHubAPIManagerError.objectSerialization(reason: "Did not get JSON dictionary in response"))
        }
        
        let gists = jsonArray.flatMap { Gist(json: $0) }
        return .success(gists)
    }
}
