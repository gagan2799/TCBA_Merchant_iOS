//
//  GAPIConstant.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 25/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import Foundation

//MARK:- Headers
struct Headers {
    static let APIKey       = "X-APIKey"
    static let APIKeyValue  = "8fa9e7c5b2a3438aa9b1de7ac4309708"
    static let BearerKey    = "Authorization"
    static let BearerValue  = "Bearer \(String(describing: GConstant.UserData.accessToken))"
}
//MARK:- URLConstants
struct GAPIConstant {
    struct Url {
        private struct Domains {
            static let Dev = "http://api.tcbadev.com/api/" //Development
            static let Live = "https://api.thecashbackapp.com/api/" //Production
        }
        
        private  struct Routes {
            static let ApiVersion = "v2"
        }
        
        private  static let Domain = Domains.Dev
        private  static let Route = Routes.ApiVersion
        private  static let BaseURL = Domain + Route
        
        static var RefreshToken: String {
            return Domain  + "token"
        }
        
        static var Login: String {
            return Domain  + "token"
        }
        
        static var ForgotUsername: String {
            return BaseURL  + "/Users/GetForgotUsername"
        }
        
        static var ForgotPassword: String {
            return BaseURL  + "/Users/GetForgotPassword"
        }
    }
}
