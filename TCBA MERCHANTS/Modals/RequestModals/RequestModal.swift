//
//  RequestModal.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 25/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import SwiftyJSON

class RequestModal: NSObject {
    //MARK: - Login Modal
    class mUserData: NSObject {
        var refresh_token           : String!
        var username                : String!
        var email                   : String!
        var grant_type              : String!
        var password                : String!
        var client_id               : String!
        var device_id               : String!
        var storeID                 : String!
        
        
        override init() {
            super.init()
        }
        
        init(fromJson json: JSON!) {
            if json.isEmpty{
                return
            }
            username                    = json["username"].stringValue
            email                       = json["email"].stringValue
            password                    = json["password"].stringValue
            grant_type                  = json["grant_type"].stringValue
            client_id                   = json["client_id"].stringValue
            device_id                   = json["device_id"].stringValue
            refresh_token               = json["refresh_token"].stringValue
            storeID                     = json["storeID"].stringValue
        }
        
        func toDictionary() -> [String:Any]{
            var dictionary = [String:Any]()
            dictionary["username"]              = username
            dictionary["email"]                 = email
            dictionary["password"]              = password
            dictionary["grant_type"]            = grant_type
            dictionary["client_id"]             = client_id
            dictionary["device_id"]             = device_id
            dictionary["refresh_token"]         = refresh_token
            dictionary["storeID"]               = storeID
            return dictionary
        }
    }
}
