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
        var type                    : String!
        var code                    : String!
        var memberID                : String!
        var keyChainCode            : String!
        
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
            type                        = json["type"].stringValue
            code                        = json["code"].stringValue
            memberID                    = json["memberID"].stringValue
            keyChainCode                = json["keyChainCode"].stringValue
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
            dictionary["type"]                  = type
            dictionary["code"]                  = code
            dictionary["memberID"]              = memberID
            dictionary["keyChainCode"]          = keyChainCode
            
            return dictionary
        }
    }
    
    class mCreatePOS: NSObject {

        var keyChainCode            : String!
        var staffId                 : Int!
        var totalAmount             : String!
        var memberId                : Int!
        var storeId                 : String!
        
        override init() {
            super.init()
        }
        
        init(fromJson json: JSON!) {
            if json.isEmpty{
                return
            }
            keyChainCode                = json["keyChainCode"].stringValue
            staffId                     = json["staffId"].intValue
            totalAmount                 = json["totalAmount"].string
            memberId                    = json["memberId"].intValue
            storeId                     = json["storeId"].stringValue
        }
        
        func toDictionary() -> [String:Any]{
            var dictionary = [String:Any]()
            
            dictionary["keyChainCode"]          = keyChainCode
            dictionary["staffId"]               = staffId
            dictionary["totalAmount"]           = totalAmount
            dictionary["memberId"]              = memberId
            dictionary["storeId"]               = storeId
            
            return dictionary
        }
    }
}
