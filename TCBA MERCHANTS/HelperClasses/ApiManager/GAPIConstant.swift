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
    static let AppVersionKey    = "x-tcba-app-version"
    private static let version  = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let AppVersionValue  = "Merchant-" + (version ?? "")
}

//MARK:- URLConstants
struct GAPIConstant {
    struct Url {
        
        static let kShareUrl = "http://tcba.mobi/dl/"
        
        private struct Domains {
            static let Dev   = "http://api.tcbadev.com/api/" /////////////-----> Development
            static let Live  = "https://api.thecashbackapp.com/api/" /////-----> Production
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
        
        //MARK: User Details Api
        static var GetUserDetails: String {
            return BaseURL + "/Users/GetUserDetails"
        }
        
        //MARK: - History Screen Api's
        static var TransactionData: String {
            return BaseURL + "/Merchant/GetMerchantTransactionSummary"
        }
        
        static var IncompleteTransactionData: String {
            return BaseURL + "/Payment/POS/GetIncompletePOSes"
        }
        
        //MARK: History Details Screen Api's
        static var GetMerchantTransactionHistory: String {
            return BaseURL + "/Merchant/GetMerchantTransactionHistory"
        }
        
        static var GetMerchantTransactionDetail: String {
            return BaseURL + "/Merchant/GetMerchantTransactionDetail"
        }
        
        static var GetOutstandingLoyalty: String {
            return BaseURL + "/Merchant/GetOutstandingLoyalty"
        }
        
        static var GetPOS: String {
            return BaseURL + "/Payment/POS/GetPOS"
        }
        
        //MARK: - QR Transaction Tab
        static var GetMemberTransactionDetails: String {
            return BaseURL + "/Payment/POS/GetMemberTransactionDetails"
        }
        
        static var PostInsertStoreCard: String {
            return BaseURL + "/Transaction/PostInsertStoreCard"
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
            return BaseURL + "/Stores/GetShare"
        }
        
        //MARK: - More Tab
        //MARK: <<---My Business--->>
        static var GetStoreContent: String {
            return BaseURL + "/Stores/GetStoreContent"
        }
        static var GetStoreDetails: String {
            return BaseURL + "/Stores/GetStoreDetails"
        }
        
        static var PutUpdateStoreContent: String {
            return BaseURL + "/Stores/PutUpdateStoreContent"
        }

        //MARK: <<---Trading Hours--->>
        static var GetTradingHours: String {
            return BaseURL + "/Stores/GetTradingHours"
        }
        
        static var PutUpdateTradingHours: String {
            return BaseURL + "/Stores/PutUpdateTradingHours"
        }
        
        //MARK: <<---Bank Details--->>
        static var GetMerchantBankInformation: String {
            return BaseURL + "/Bank/GetMerchantBankInformation"
        }
        
        //MARK: <<---Merchants Store Details--->>
        static var GetMerchantStoreDetails: String {
            return BaseURL + "/Stores/GetMerchantStoreDetails"
        }
        
        static var PutUpdateStore: String {
            return BaseURL + "/Stores/PutUpdateStore"
        }
        
        static var GetCountries: String {
            return BaseURL + "/Content/GetCountries"
        }
        
        static var GetStates: String {
            return BaseURL + "/Content/GetStates"
        }
        
        //MARK: Staff Accounts
        static var GetStaffMembers: String {
            return BaseURL + "/Staff/GetStaffMembers"
        }
        
        static var PostNewStaffMember: String {
            return BaseURL + "/Staff/PostNewStaffMember"
        }
        
        static var PutUpdateStaffMember: String {
            return BaseURL + "/Staff/PutUpdateStaffMember"
        }
        
        static var GetStaffLogin: String {
            return BaseURL + "/Staff/GetStaffLogin"
        }
        
        static var GetMerchantStores : String {
            return BaseURL + "/Stores/GetMerchantStores"
        }
        
        static var PostCheckPassword : String {
            return BaseURL + "/Users/PostCheckPassword"
        }
        
        //MARK:Videos
        static var GetVideoMainCategories: String {
            return BaseURL + "/Content/GetVideoMainCategories"
        }
        
        static var GetVideoSubcategories: String {
            return BaseURL + "/Content/GetVideoSubcategoriesOrVideosList"
        }
        
        //MARK: Alerts
        static var GetNotifications: String {
            return BaseURL + "/Notification/GetNotifications"
        }
        
        //MARK: Calculator
        static var GetUserMatrix: String {
            return BaseURL + "/UserMatrix/GetUserMatrix"
        }
        
        //MARK: AboutUs
        static var GetAboutUsSection: String {
            return BaseURL + "/Content/GetAboutUsSection"
        }
        
        //MARK: ContactUs
        static var PostContactUs: String {
            return BaseURL + "/Feedback/PostContactUs"
        }
        
        //MARK: RateUs
        static var PostRateUs: String {
            return BaseURL + "/Feedback/PostRateUs"
        }
        
    }
}
