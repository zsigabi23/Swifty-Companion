//
//  Search.swift
//  Swifty-Companion
//
//  Created by Zolile SIGABI on 2019/10/25.
//  Copyright © 2019 Zolile SIGABI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Search: NSObject {
    var token = String()
        let url = "https://api.intra.42.fr/oauth/token"
        let config = [
            "grant_type": "client_credentials",
            "client_id": "c4e32d758e82af41a2f3b9c3962f54b03367916d35e29a65783f595d56645a33",
            "client_secret": "eeb2255a683b9ba5617ff41b1e08a93515838e83c5b036d4adfa11b2fd1593c5"]

        func makeToken() {
            print("sdsad")
            let verify = UserDefaults.standard.object(forKey: "token")
            if verify == nil {
                Alamofire.request(url, method: .post, parameters: config).validate().responseJSON {
                    response in
                    switch response.result {
                    case .success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            self.token = json["access_token"].stringValue
                            UserDefaults.standard.set(json["access_token"].stringValue, forKey: "token")
                            print("NEW token:", self.token)
                            self.chToken()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
                self.token = verify as! String
                print("SAME token:", self.token)
                chToken()
            }
        }
        
        private func chToken() {
            let url = URL(string: "https://api.intra.42.fr/oauth/token/info")
            let bearer = "Bearer " + self.token
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            print("sdsdsadsda")
            request.setValue(bearer, forHTTPHeaderField: "Authorization")
            Alamofire.request(request as URLRequestConvertible).validate().responseJSON {
                response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("The token will expire in:", json["expires_in_seconds"], "seconds.")
                    }
                case .failure:
                    print("Error: Trying to get a new token...")
                    UserDefaults.standard.removeObject(forKey: "token")
                    self.makeToken()
                }
            }
        }
        
        func checkUser(_ user: String, completion: @escaping (JSON?) -> Void) {
            let userUrl = URL(string: "https://api.intra.42.fr/v2/users/" + user)
            let bearer = "Bearer " + self.token
            print(token)
            print(":")
            var request = URLRequest(url: userUrl!)
            request.httpMethod = "GET"
            request.setValue(bearer, forHTTPHeaderField: "Authorization")
            Alamofire.request(request as URLRequestConvertible).validate().responseJSON {
                response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        completion(json)
                    }
                case .failure:
                    completion(nil)
                    print("Error: This login doesn't exists")
                }
            }
        }
    }
