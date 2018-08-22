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
}
//MARK:- URLConstants
struct GAPIConstant {
    struct Url {
        
        static let kShareUrl = "http://tcba.mobi/dl/"
        
        private struct Domains {
            static let Dev   = "http://api.tcbadev.com/api/" //Development
            static let Live  = "https://api.thecashbackapp.com/api/" //Production
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
        
        //MARK: - Login Screen Api's
        static var Login: String {
            return Domain  + "token"
        }
        
        static var ForgotUsername: String {
            return BaseURL  + "/Users/GetForgotUsername"
        }
        
        static var ForgotPassword: String {
            return BaseURL  + "/Users/GetForgotPassword"
        }
        
        //MARK: - History Screen Api's
        static var TransactionData: String {
            return BaseURL + "/Merchant/GetMerchantTransactionSummary"
        }
        
        static var IncompleteTransactionData: String {
            return BaseURL + "/Payment/POS/GetIncompletePOSes"
        }
        
        //MARK: - History Details Screen Api's
        static var GetMerchantTransactionDetail: String {
            return BaseURL + "/Merchant/GetMerchantTransactionDetail"
        }
        
        static var GetOutstandingLoyalty: String {
            return BaseURL + "/Merchant/GetOutstandingLoyalty"
        }
        
        //MARK: - QR Transaction Tab
        static var GetMemberTransactionDetails: String {
            return BaseURL + "/Payment/POS/GetMemberTransactionDetails"
        }
        
        static var PostCreatePOS: String {
            return BaseURL + "/Payment/POS/PostCreatePOS"
        }
        
        static var PostCreateTransaction: String {
            return BaseURL + "/Payment/POS/PostCreateTransaction"
        }
        
        static var PostCreateTransactionWithFullPayment: String {
            return BaseURL + "/Payment/POS/PostCreateTransactionWithFullPayment"
        }
        
        static var PostAddPOSPayment: String {
            return BaseURL + "/Payment/POS/PostAddPOSPayment"
        }
        
        static var PostRemoveAllPOSPayments: String {
            return BaseURL + "/Payment/POS/PostRemoveAllPOSPayments"
        }
        
        //MARK: - Share Tab
        static var GetShareContent: String {
            return BaseURL + "/Content/GetShare"
        }
    }
}
