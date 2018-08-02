//
//  GFunction.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 25/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

enum EventIdentity: String {
    case anyEvent = ""
}

class CompletionHandler {
    static let shared = CompletionHandler()
    let Event = EventManager()
    
    func triggerEvent(_ eventIdentifier: EventIdentity, passData: Any?) {
        Event.trigger(eventName: eventIdentifier.rawValue, information: passData)
    }
    
    func litsenerEvent(_ eventIdentifier: EventIdentity, actionBlock: @escaping ((Any?) -> ())) {
        Event.listenTo(eventName: eventIdentifier.rawValue, action: actionBlock)
    }
}

class GFunction: NSObject  {
    
    static let shared   : GFunction = GFunction()
    //------------------------------------------------------
    //MARK:- Loader Method
    
    func addLoader(_ toView : AnyObject? = UIApplication.shared.keyWindow!) {
        LoaderWithLabel.shared.showProgressView(anyView: toView!)
    }
    
    func removeLoader() {
        LoaderWithLabel.shared.hideProgressView()
    }
    
    //------------------------------------------------------
    
    //MARK: - UIACtivityIndicator
    
    func addActivityIndicator(view : UIView) {
        removeActivityIndicator()
        
    }
    
    func removeActivityIndicator() {
        
    }
    
    //------------------------------------------------------
    
    //MARK:- UserDefaults
    
    //------------------------------------------------------
    
    //MARK: - Other Helper Method
    
    func saveUserDetailInDefaults(_ encodeData: Data)  {
        let userDefault = UserDefaults.standard
        userDefault.set(encodeData, forKey: GConstant.UserDefaultKeys.UserDataLogin)
        userDefault.synchronize()
    }
    
func getUserDataFromDefaults() -> UserLoginModel? {
        if let userData =  UserDefaults.standard.value(forKey: GConstant.UserDefaultKeys.UserDataLogin) as? Data{
            let userDataDecoded = try! UserLoginModel.decode(_data: userData)
            return userDataDecoded
        }
        return nil
    }
    
    func saveDataIntoUserDefault (object : AnyObject, key : String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(object, forKey:key)
        UserDefaults.standard.synchronize()
    }
    
    func removeUserDefaults(key: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getDeviceId () -> String {
        if (UserDefaults.standard.value(forKey: GConstant.UserDefaultKeys.DeviceId) != nil) {
            let deviceToken : String? = UserDefaults.standard.value(forKey: GConstant.UserDefaultKeys.DeviceId) as? String
            guard let
                letValue = deviceToken, !letValue.isEmpty else {
                    //print(":::::::::-Value Not Found-:::::::::::")
                    return ""
            }
            return deviceToken!
        }
        return ""
    }
    
    //------------------------------------------------------
    
    enum TimeFormatType {
        case short
        case full
    }
    
    //MARK: - Other Method
    func compareDateTrueIfExpire(dateString : String , dateFormatter formatterString: String = "EEE, dd MM yyyy HH:mm:ss zzz") -> Bool {
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        let dateFormatter                   = DateFormatter()
        dateFormatter.dateFormat            = formatterString //Your date format
        dateFormatter.timeZone              = TimeZone(abbreviation: localTimeZoneAbbreviation)
        
        var currentDate                     = Date()
        let currentDateStr                  = dateFormatter.string(from: currentDate)
        currentDate                         = dateFormatter.date(from: currentDateStr)!
        let yourDate                        = dateFormatter.date(from: dateString) //according to date format your date string
        print("Current Date : \(currentDate)")
        print("Expiry Date : \(String(describing: yourDate))")
        return yourDate! > currentDate
    }
    
    
    func conversionSecondsToPostDuration(_ seconds: Int?, formatType: TimeFormatType) -> String {
        
        guard let seconds = seconds else {
            return ""
        }
        
        let minutes: Int = seconds / 60
        let hours: Int = minutes / 60
        let day: Int = hours / 24
        let week: Int = day / 7
        
        if formatType == .short {
            if seconds / 60 < 1 {
                return "\(Int(seconds))s"
            }
            else if minutes >= 1 && minutes <= 59 {
                return "\(Int(minutes))m"
            }
            else if hours < 24 {
                return "\(Int(hours))h"
            }
            else if day < 7 {
                return "\(Int(day))d"
            }
            else {
                return "\(Int(week))w"
            }
        }else{
            if seconds / 60 < 1 {
                return Int(seconds) > 1 ? "\(Int(seconds)) seconds ago" : "\(Int(seconds)) second ago"
            }
            else if minutes >= 1 && minutes <= 59 {
                return Int(minutes) > 1 ? "\(Int(minutes)) minutes ago" : "\(Int(minutes)) minute ago"
            }
            else if hours < 24 {
                return Int(hours) > 1 ? "\(Int(hours)) hours ago" : "\(Int(hours)) hour ago"
            }
            else if day < 7 {
                return Int(day) > 1 ? "\(Int(day)) days ago" : "\(Int(day)) day ago"
            }
            else {
                return Int(week) > 1 ? "\(Int(week)) weeks ago" : "\(Int(week)) week ago"
            }
        }
        
    }
    
    func convertToJSONString(arrayData : Any) -> String {
        do {
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: arrayData, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                return JSONString
            }
        }
        catch {
            return ""
        }
        return ""
    }
    
    func userLogOut(isFromSplash: Bool = false) {
        // I set the root VC dynamicaly because it depends on wether it's the first time to use the app or if the user is logged in or not
        // Remove userdata from User defaults
         GFunction.shared.removeUserDefaults(key: GConstant.UserDefaultKeys.UserDataLogin)
        let obj = GConstant.MainStoryBoard.instantiateViewController(withIdentifier: GConstant.VCIdentifier.Login) as! TMLoginViewController
        obj.isFromSplash = isFromSplash
        if !isFromSplash {
            GConstant.NavigationController = GConstant.MainStoryBoard.instantiateViewController(withIdentifier: "RootNavigation") as! UINavigationController
            UIApplication.shared.delegate?.window??.rootViewController = GConstant.NavigationController
        }
        GConstant.NavigationController.fadeTo(obj)
    }
    
    func userLogin() {
        GConstant.UserData = self.getUserDataFromDefaults()
        rootWindow().rootViewController = Tabbar.coustomTabBar()
    }
    
    func makeUserLoginAlert() {
        AlertManager.shared.showAlertTitle(title: "Please Login Again", message: "Your session has expired. Please login again to proceed.", buttonsArray: ["Cancel","Login"]) { (buttonIndex : Int) in
            switch buttonIndex {
            case 0 :
                //No clicked
                break
            case 1:
                let obj = GConstant.MainStoryBoard.instantiateViewController(withIdentifier: GConstant.VCIdentifier.Login) as! TMLoginViewController
                let navigationController = UINavigationController(rootViewController:obj)
                     rootWindow().rootViewController?.present(navigationController, animated: true, completion: {
                })
                break
            default:
                break
            }
        }
    }
}
