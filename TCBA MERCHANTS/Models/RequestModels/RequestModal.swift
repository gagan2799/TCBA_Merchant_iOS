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
        var countryId               : String!
        var stateType               : String!
        var userType                : String!
        var fullName                : String!
        var comment                 : String!
        var message                 : String!
        var rating                  : String!
        
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
            countryId                   = json["countryId"].stringValue
            stateType                   = json["stateType"].stringValue
            userType                    = json["userType"].stringValue
            fullName                    = json["fullName"].stringValue
            comment                     = json["comment"].stringValue
            message                     = json["message"].stringValue
            rating                      = json["rating"].stringValue
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
            dictionary["countryId"]             = countryId
            dictionary["stateType"]             = stateType
            dictionary["userType"]              = userType
            dictionary["fullName"]              = fullName
            dictionary["comment"]               = comment
            dictionary["message"]               = message
            dictionary["rating"]                = rating
            return dictionary
        }
    }
    
    class mCreatePOS: NSObject {
        
        var keyChainCode            : String!
        var staffId                 : Int!
        var totalAmount             : String!
        var memberId                : Int!
        var storeId                 : String!
        var accountNumber           : String!
        var execute                 : Int!
        var memberPin               : String!
        var paymentType             : String!
        var posID                   : Int!
        var creditCardToken         : String!
        var amount                  : String!
        
        
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
            accountNumber               = json["accountNumber"].stringValue
            execute                     = json["execute"].intValue
            memberPin                   = json["memberPin"].string
            paymentType                 = json["paymentType"].stringValue
            posID                       = json["posID"].intValue
            creditCardToken             = json["creditCardToken"].stringValue
            amount                      = json["amount"].stringValue
        }
        
        func toDictionary() -> [String:Any]{
            var dictionary = [String:Any]()
            
            dictionary["keyChainCode"]          = keyChainCode
            dictionary["staffId"]               = staffId
            dictionary["totalAmount"]           = totalAmount
            dictionary["memberId"]              = memberId
            dictionary["storeId"]               = storeId
            dictionary["accountNumber"]         = accountNumber
            dictionary["execute"]               = execute
            dictionary["memberPin"]             = memberPin
            dictionary["paymentType"]           = paymentType
            dictionary["posID"]                 = posID
            dictionary["creditCardToken"]       = creditCardToken
            dictionary["amount"]                = amount
            
            return dictionary
        }
    }
    
    class mUpdateStoreContent: NSObject {
        
        var storeId             : String!
        var storeFeatures       : String!
        var storeTerm           : String!
        var storeDescription    : String!
        var storeAbout          : String!
        var days                : [Any]!
        var abn                 : String!
        var businessName        : String!
        var phoneNumber         : String!
        var showAddress         : Int!
        var storeAddress        : [String:Any]!
        var storeEmail          : String!
        var storeTitle          : String!

        override init() {
            super.init()
        }
        
        init(fromJson json: JSON!) {
            if json.isEmpty{
                return
            }
            
            storeId                         = json["storeId"].stringValue
            storeFeatures                   = json["storeFeatures"].stringValue
            storeTerm                       = json["storeTerm"].stringValue
            storeDescription                = json["storeDescription"].stringValue
            storeAbout                      = json["storeAbout"].stringValue
            days                            = json["days"].arrayObject
            abn                             = json["abn"].stringValue
            businessName                    = json["businessName"].stringValue
            phoneNumber                     = json["phoneNumber"].stringValue
            showAddress                     = json["showAddress"].intValue
            storeAddress                    = json["storeAddress"].dictionaryObject
            storeEmail                      = json["storeEmail"].stringValue
            storeTitle                      = json["storeTitle"].stringValue
        }
        
        func toDictionary() -> [String:Any]{
            var dictionary = [String:Any]()
            
            dictionary["storeId"]           = storeId
            dictionary["storeFeatures"]     = storeFeatures
            dictionary["storeTerm"]         = storeTerm
            dictionary["storeDescription"]  = storeDescription
            dictionary["storeAbout"]        = storeAbout
            dictionary["days"]              = days
            dictionary["abn"]               = abn
            dictionary["businessName"]      = businessName
            dictionary["phoneNumber"]       = phoneNumber
            dictionary["showAddress"]       = showAddress
            dictionary["storeAddress"]      = storeAddress
            dictionary["storeEmail"]        = storeEmail
            dictionary["storeTitle"]        = storeTitle
            
            return dictionary
        }
    }
    
    class mUpdateStoreAddress: NSObject {
        
        var address             : String!
        var city                : String!
        var countryId           : Int!
        var postcode            : Int!
        var stateId             : Int!
        
        override init() {
            super.init()
        }
        
        init(fromJson json: JSON!) {
            if json.isEmpty{
                return
            }
            address                         = json["address"].stringValue
            city                            = json["city"].stringValue
            countryId                       = json["countryId"].intValue
            postcode                        = json["postcode"].intValue
            stateId                         = json["stateId"].intValue
        }
        
        func toDictionary() -> [String:Any]{
            var dictionary = [String:Any]()
            
            dictionary["address"]           = address
            dictionary["city"]              = city
            dictionary["countryId"]         = countryId
            dictionary["postcode"]          = postcode
            dictionary["stateId"]           = stateId
            
            return dictionary
        }
    }
}
