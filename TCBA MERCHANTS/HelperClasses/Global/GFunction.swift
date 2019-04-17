//
//  GFunction.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 25/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

enum EventIdentity: String {
    case anyEvent                   = ""
    case svReloadTbl                = "tblDetailViewReload"
    case pushToPayment              = "pushToPaymentVCFromHistory"
    case checkPayment               = "checkPaymentsForCollectionInPayments"
    case updateLoaderFrame          = "updateLoaderFrame"
    case hideTableContainerPayment  = "hideTableContainerPayment"
    case reloadStaffTable           = "reloadStaffTable"
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
    
    //MARK:-
    func checkPaymentOptions(withPosData posData: PostCreatePOSModel?,Method type: String ,withViewType viewT: viewType) -> Bool {
        var flag = type == "" ? true : false
        guard posData != nil  else { return flag }
        guard let data = posData?.paymentOptions else { return flag }
        if data.count > 0 {
            for item in data {
                if item.type == type {
                    flag = true
                    break
                }
            }
        } else {
            guard let data2 = posData?.payments else { return flag}
            for item in data2 {
                if item.type == type {
                    flag = true
                    break
                }
            }
        }
        
        guard let totalPurchase = posData?.totalPurchaseAmount else { return flag}
        guard let walletBal     = posData?.walletBalance else { return flag }
        guard let prizeFund     = posData?.availablePrizeCash else { return flag }
        guard let loyaltyCash   = posData?.availableLoyaltyCash else { return flag }
        if type         == "Wallet"       && (viewT == .home ? walletBal.isLess(than: totalPurchase) : walletBal.isLessThanOrEqualTo(0.0)) {
            flag = false
        }else if type   == "PrizeWallet"  && (viewT == .home ? prizeFund.isLess(than: totalPurchase) : prizeFund.isLessThanOrEqualTo(0.0)) {
            flag = false
        }else if type   == "LoyaltyCash"  && (viewT == .home ? loyaltyCash.isLess(than: totalPurchase) : loyaltyCash.isLessThanOrEqualTo(0.0)) {
            flag = false
        }else if  type == "" {// For mix payments
            flag = true
        }
        return flag
    }
    
    //------------------------------------------------------
    
    //MARK: - Other Helper Method
    
    func saveUserDataInDefaults(_ encodeData: Data)  {
        let userDefault = UserDefaults.standard
        userDefault.set(encodeData, forKey: GConstant.UserDefaultKeys.UserDataLogin)
        userDefault.synchronize()
    }
    
    func saveUserDetailsInDefaults(_ encodeData: Data)  {
        let userDefault = UserDefaults.standard
        userDefault.set(encodeData, forKey: GConstant.UserDefaultKeys.UserDetails)
        userDefault.synchronize()
    }
    
    func getUserDataFromDefaults() -> UserLoginModel? {
        if let userData =  UserDefaults.standard.value(forKey: GConstant.UserDefaultKeys.UserDataLogin) as? Data{
            let userDataDecoded = try! UserLoginModel.decode(_data: userData)
            return userDataDecoded
        }
        return nil
    }
    
    func getUserDetailsFromDefaults() -> UserDetailsModel? {
        if let userDetails =  UserDefaults.standard.value(forKey: GConstant.UserDefaultKeys.UserDetails) as? Data{
            let userDataDecoded = try! UserDetailsModel.decode(_data: userDetails)
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
    //MARK: json methods
    func json(from object: [String: Any]?) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object!) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func convertToDictionary(text: String) -> [Dictionary<String,Any>]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Dictionary<String,Any>]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    enum TimeFormatType {
        case short
        case full
    }
    
    //MARK: Gradient Line
    enum LineType {
        case vertical
        case horizontal
    }
    
    func getDoubleGradientView(_ frame: CGRect, start startColor: UIColor?, midColor: UIColor?, end endColor: UIColor?, direction: LineType) -> UIView? {
        let completeView = UIView(frame: frame)
        completeView.backgroundColor = UIColor.clear
        //    0 Direction is horizontal
        //    1 direction is vertical
        
        if direction == .horizontal {
            let startPoint = CGPoint(x: 0.0, y: 0.5)
            let endpoint = CGPoint(x: 1.0, y: 0.5)
            var frm = CGRect(x: 0, y: 0, width: completeView.frame.width / 2, height: completeView.frame.height)
            let startView: UIView? = getGradientviewWithFrame(frm, start: startColor, end: midColor, start: startPoint, end: endpoint)
            frm = CGRect(x: completeView.frame.width / 2, y: 0, width: completeView.frame.width / 2, height: completeView.frame.height)
            let endView: UIView? = getGradientviewWithFrame(frm, start: midColor, end: endColor, start: startPoint, end: endpoint)
            if let aView = startView {
                completeView.addSubview(aView)
            }
            if let aView = endView {
                completeView.addSubview(aView)
            }
        } else {
            let startPoint = CGPoint(x: 0.5, y: 0.0)
            let endpoint = CGPoint(x: 0.5, y: 1.0)
            var frm = CGRect(x: 0, y: 0, width: (completeView.frame.width), height: completeView.frame.height / 2)
            let startView: UIView? = getGradientviewWithFrame(frm, start: startColor, end: midColor, start: startPoint, end: endpoint)
            frm = CGRect(x: 0, y: completeView.frame.height / 2, width: (completeView.frame.width), height: completeView.frame.height / 2)
            let endView: UIView? = getGradientviewWithFrame(frm, start: midColor, end: endColor, start: startPoint, end: endpoint)
            if let aView = startView {
                completeView.addSubview(aView)
            }
            if let aView = endView {
                completeView.addSubview(aView)
            }
        }
        return completeView
    }
    
    func getGradientviewWithFrame(_ frm: CGRect, start startColor: UIColor?, end endColor: UIColor?, start startPoint: CGPoint, end endPoint: CGPoint) -> UIView? {
        let lineView = UIView(frame: frm)
        let gradientlayer = CAGradientLayer()
        gradientlayer.frame = lineView.bounds
        if let startCol  = startColor , let endCol = endColor {
            gradientlayer.colors = [startCol.cgColor, endCol.cgColor]
        }
        gradientlayer.startPoint = startPoint
        gradientlayer.endPoint = endPoint
        
        lineView.layer.insertSublayer(gradientlayer, at: 0)
        
        return lineView
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
        guard let yourDate                  = dateFormatter.date(from: dateString) else { return true }//according to date format your date string
        print("Current Date : \(currentDate)")
        print("Expiry Date : \(String(describing: yourDate))")
        return yourDate < currentDate
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
            GConstant.NavigationController = GConstant.MainStoryBoard.instantiateViewController(withIdentifier: "RootNavigation") as? UINavigationController
            UIApplication.shared.delegate?.window??.rootViewController = GConstant.NavigationController
        }
        GConstant.NavigationController.fadeTo(obj)
    }
    
    func userLogin() {
        GConstant.UserData = self.getUserDataFromDefaults()
        let transition: CATransition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.fade
        rootWindow().layer.add(transition, forKey: nil)
        rootWindow().rootViewController = Tabbar.coustomTabBar()
    }
    
    func makeUserLoginAlert() {
        if UIApplication.shared.isNetworkActivityIndicatorVisible == true{
            removeLoader()
        }
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
    
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}
