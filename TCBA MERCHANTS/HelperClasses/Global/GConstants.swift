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
    
        // Alert Popup Colors
        struct AlertView {
            static let Text     = UIColor.black
            static let Primary  = UIColor.white
        }
    }
    
    //MARK: - Screen (Width - Height)
    struct Screen {
        
        static let kWidth                        =  UIScreen.main.bounds.size.width
        static var kHeight                       =  UIScreen.main.bounds.size.height
        static var Width                         =  UIScreen.main.bounds.size.width
        static var Height                        =  UIScreen.main.bounds.size.height
        static var HeightAspectRatio:CGFloat     =  kHeight / 667.0
    }
    
    // MARK:- Viewcontrollers Identifiers
    struct VCIdentifier {
        //Login Screen
        static let Login                        = "TMLoginViewController"
        //Home Tab
        static let Home                         = "TMHomeViewController"
        //History Tab
        static let History                      = "TMHistoryViewController"
        
        static let HistoryDetail                = "TMHistoryDetailVC"
        //QR Tab
        static let Transection                  = "TMTransactionViewController"
        //Share Tab
        static let Share                        = "TMShareViewController"
        //More Tab
        static let More                         = "TMMoreViewController"
    }
        
    //MARK:- UserDefaults
    struct UserDefaultKeys {
        static let AppLaunch                        : String = "kAppLaunch"
        static let DeviceId                         : String = "kDeviceId"
        static let UserDataLogin                    : String = "kLoginUserData"
        static let UserName                         : String = "kUserNameLogin"
    }
    
    //MARK:- Messages
    struct Message {
        // Alert messages
        static let kEmailTxtFieldMessage           :String = "Your email is required and must be in a valid format."
        static let kSomthingWrongMessage           :String = "Something went wrong, Please try again"
        static let kEmailSentSuccessMessage        :String = "If your address exists on our systems, an account recovery email has been sent."
        static let kMemberIDTxtFieldMessage        :String = "Your Member Id is required, Please enter a valid Member ID"
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
