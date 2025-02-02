//
//  GConstants.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 11/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//
import UIKit
struct GConstant {
    static let APPName                      = "TCBA MERCHANTS"
    static let MainStoryBoard               = UIStoryboard(name: "Main", bundle: .main)
    static var NavigationController         : UINavigationController!
    static var UserData                     : UserLoginModel!
    static var UserDetails                  : UserDetailsModel!
    
    static let kMerchantEmail               = "merchants@thecashbackapp.com"
    static let kAppStoreLink                = "https://itunes.apple.com/in/app/the-cash-back-app/id692743133?mt=8"
    
    // MARK:- APP Colors
    struct AppColor {
        static let white            = UIColor.white
        static let black            = UIColor.black
        static let blue             = UIColor(hexString: "#0073CA")
        static let darkBlue         = UIColor(hexString: "#054476")
        static let orange           = UIColor(hexString: "#F4761E")
        static let grayBG           = UIColor(hexString: "#EBEBEB")
        static let textDark         = UIColor(hexString: "#3A3A3A")
        static let textLight        = UIColor(hexString: "#747474")
        static let grayBorder       = UIColor(hexString: "#D2D2D2")
        
        // Alert Popup Colors
        struct AlertView {
            static let Text     = UIColor.black
            static let Primary  = UIColor.white
        }
    }
    
    //MARK: - Screen (Width - Height)
    struct Screen {
        static let kWidth                       =  UIScreen.main.bounds.size.width
        static var kHeight                      =  UIScreen.main.bounds.size.height
        static var Width                        =  UIScreen.main.bounds.size.width
        static var Height                       =  UIScreen.main.bounds.size.height
        static var HeightAspectRatio:CGFloat    =  kRatio(height: kHeight)
        static var iPhoneXSeries:Bool           =  UIApplication.shared.statusBarFrame.height > 40.0
    }
    
    static func kRatio(height: CGFloat) -> CGFloat {
        if UIApplication.shared.statusBarFrame.height > 40.0 && height == 812.0 {
            //iphone X, iPhone Xs
            return 1
        } else if UIApplication.shared.statusBarFrame.height > 40.0 && height == 896.0 {
            //iPhone XR, Iphone Xs Max
            return 736.0 / 667.0
        } else {
            return height / 667.0
        }
    }
    
    // MARK:- Viewcontrollers Identifiers
    struct VCIdentifier {
        //Login Screen
        static let Login                        = "TMLoginViewController"
        static let ApplyMerchantVC              = "TMApplyMerchantVC"
        //Home Tab
        static let Home                         = "TMHomeViewController"
        //History Tab
        static let History                      = "TMHistoryViewController"
        static let HistoryTransDetail           = "TMHistoryTransDetail"
        static let HistoryDetail                = "TMHistoryDetailVC"
        //QR Tab
        static let Transaction                  = "TMTransactionViewController"
        static let QRScanner                    = "TMQRScannerVC"
        static let MemberTransaction            = "TMMemberTransactionVC"
        static let Anonymous                    = "TMAnonymousVC"
        static let StorePayment                 = "TMStorePaymentVC"
        static let SplitMaster                  = "TMSplitPaymentMasterVC"
        static let SplitDetail                  = "TMSplitPaymentDetailVC"
        static let PinView                      = "TMPinViewController"
        static let PopUP                        = "TMPopUPVC"
        static let PaymentSuccessPopUp          = "TMPaySuccessPopUpVC"
        //Share Tab
        static let Share                        = "TMShareViewController"
        //More Tab
        static let More                         = "TMMoreViewController"
        static let MyBusiness                   = "TMMyBusinessVC"
        static let EditBusiness                 = "TMEditBusinessDetailVC"
        static let TradingHours                 = "TMTradingHoursVC"
        static let DatePicker                   = "TMDatePickerVC"
        static let ContactDetails               = "TMContactDetailVC"
        static let StoreImages                  = "TMStoreImagesVC"
        static let MainImage                    = "TMMainImageVC"
        static let BankDetails                  = "TMBankDetailsVC"
        static let TermOfUse                    = "TMTermOfUseVC"
        static let ContactUs                    = "TMContactUsVC"
        static let RateUs                       = "TMRateUsVC"
        static let AboutUs                      = "TMAboutUsVC"
        static let AboutUsSubLis                = "TMAboutUsSubLisVC"
        static let AppOverView                  = "TMAppOverViewVC"
        static let Video                        = "TMVideoVC"
        static let VideoSubLis                  = "TMVideoSubLisVC"
        static let VideoDetails                 = "TMVideoDetailsVC"
        static let Alerts                       = "TMAlertsVC"
        static let AlertsDetails                = "TMAlertsDetailVC"
        static let Calculator                   = "TMCalculatorVC"
        static let MatrixCalculator             = "TMMatrixCalculatorVC"
    }
    
    //MARK:- UserDefaults
    struct UserDefaultKeys {
        static let AppLaunch            : String = "kAppLaunch"
        static let DeviceId             : String = "kDeviceId"
        static let UserDataLogin        : String = "kLoginUserData"
        static let UserName             : String = "kUserNameLogin"
        static let UserDetails          : String = "kLoginUserDetails"
        static let EnableStaffMode      : String = "kEnableStaffMode"
        static let isStaffLoggedIn      : String = "kStaffLoggedIn"
    }
    
    //MARK:- Messages
    struct Message {
        // Alert messages
        static let kEmailTxtFieldMessage           :String = "Your email is required and must be in a valid format."
        static let kUpdatesSaveMessage             :String = "Your updates have been saved."
        static let kSomthingWrongMessage           :String = "Something went wrong, Please try again"
        static let kEmailSentSuccessMessage        :String = "If your address exists on our systems, an account recovery email has been sent."
        static let kMemberIDTxtFieldMessage        :String = "Your Member ID is required, Please enter a valid Member ID"
        // App permission massages
        static let kPhotoPermissionMessage         :String = "We need to have access to your photos to select a Photo.\nPlease go to the App Settings and allow Photos."
        static let kCameraPermissionMessage        :String = "We need to have access to your camera to take a New Photo.\nPlease go to the App Settings and allow Camera."
        static let kLocationPermissionMessage      :String = "We need to have access to your Current Location to show you nearby Products.\nPlease go to the App Settings and allow Location."
    }
    
    //MARK:- Parameters
    struct Param {
        static let kError       = "error"
        static let kMessage     = "message"
        static let kTitle       = "kTitle"
        static let kAction      = "kAction"
    }
}
