//
//  Connectivity.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 25/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    //shared instance
    static let shared = NetworkManager()
    
    let manager = Alamofire.NetworkReachabilityManager()

    func startNetworkReachabilityObserver() {
        manager?.startListening { status in
            switch status {
            case .notReachable, .unknown :
                GFunction.shared.removeLoader()
                AlertManager.shared.showAlertTitle(title: "Network Issue!", message: "TCBA Merchants has failed to retrieve data. Please check your Internet connection and try again")
            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
                print("The network is reachable over the WiFi/WWAN connection")
            }
        }
    }
}

class Connectivity {
    class var isConnectedToInternet:Bool {
        if NetworkReachabilityManager()!.isReachable {
            return true
        }else{
            GFunction.shared.removeLoader()
            AlertManager.shared.showAlertTitle(title: "Network Issue!", message: "TCBA Merchants has failed to retrieve data. Please check your Internet connection and try again")
            return false
        }
    }
}
