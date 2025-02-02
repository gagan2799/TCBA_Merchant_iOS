//
//  ApiManager.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 25/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import Foundation
import Alamofire

class ApiManager {
    static let shared = ApiManager()
    
    class APIHeaders {
        class func headers() -> HTTPHeaders {
            let headers: HTTPHeaders = [
                "Content-Type"     : "application/x-www-form-urlencoded",
                "Accept"           : "application/json",
                Headers.APIKey     : Headers.APIKeyValue
            ]
            return headers
        }
        
        class func headersForMultipart() -> HTTPHeaders {
            guard GConstant.UserData != nil else {
                return headers()
            }
            guard let accessToken = GConstant.UserData?.accessToken else { return headers() }
            
            let headers: HTTPHeaders = [
                "Content-Type"          : "multipart/form-data",
                "Accept"                : "application/json",
                "Authorization"         : "Bearer \(accessToken)",
                Headers.APIKey          : Headers.APIKeyValue,
                Headers.AppVersionKey   : Headers.AppVersionValue,
                "client_id"             : "tcba_iphone"
            ]
            return headers
        }
        
        class func headersWithBearerToken(contentType: String = "application/json") -> HTTPHeaders {
            let headers: HTTPHeaders = [
                "Content-Type"      : contentType,
                "Accept"            : "application/json",
                "Authorization"     : "Bearer \(GConstant.UserData?.accessToken ?? "")",
                Headers.APIKey      : Headers.APIKeyValue,
                "client_id"         : "tcba_iphone"
            ]
            return headers
        }
    }
    
    class APIError {
        class func handleError(response: DataResponse<Any, AFError>) -> String {
            var errorDescription, reasonDetail, message: String!
            if let AFerror = response.error {
                switch AFerror {
                case .invalidURL(let url):
                    errorDescription = ("Invalid URL: \(url) - \(AFerror.localizedDescription)")
                case .parameterEncodingFailed(let reason):
                    errorDescription = ("Parameter encoding failed: \(AFerror.localizedDescription)")
                    reasonDetail = ("Failure Reason: \(reason)")
                case .multipartEncodingFailed(let reason):
                    errorDescription = ("Multipart encoding failed: \(AFerror.localizedDescription)")
                    reasonDetail = ("Failure Reason: \(reason)")
                case .responseValidationFailed(let reason):
                    errorDescription = ("Response validation failed: \(AFerror.localizedDescription)")
                    reasonDetail = ("Failure Reason: \(reason)")
                    
                    switch reason {
                    case .dataFileNil, .dataFileReadFailed:
                        print("Downloaded file could not be read")
                    case .missingContentType(let acceptableContentTypes):
                        print("Content Type Missing: \(acceptableContentTypes)")
                    case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                        print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                    case .unacceptableStatusCode(let code):
                        print("Response status code was unacceptable: \(code)")
                    case .customValidationFailed(error: _):
                        break
                    }
                    
                case .responseSerializationFailed(let reason):
                    errorDescription = ("Response serialization failed: \(AFerror.localizedDescription)")
                    reasonDetail = ("Failure Reason: \(reason)")
                    
                    let statusCode = AFerror._code
                    let underLayingError = ("Underlying error: \(String(describing: AFerror.underlyingError))")
                    
                    let errorDetail = "\(statusCode) \n \(String(describing: errorDescription)) \n \(String(describing: reasonDetail)) \n \(underLayingError)"
                    message = errorDetail
                case .createUploadableFailed(error: let error):
                    print(error.localizedDescription)
                case .createURLRequestFailed(error: let error):
                    print(error.localizedDescription)
                case .downloadedFileMoveFailed(error: let error, source:  _, destination: _):
                    print(error.localizedDescription)
                case .explicitlyCancelled:
                    print("explicitlyCancelled")
                case .parameterEncoderFailed(reason: let reason):
                    print(reason)
                case .requestAdaptationFailed(error: let error):
                    print(error.localizedDescription)
                case .requestRetryFailed(retryError: _, originalError:  _):
                    print("requestRetryFailed")
                case .serverTrustEvaluationFailed(reason: let reason):
                    print(reason)
                case .sessionDeinitialized:
                    print("sessionDeinitialized")
                case .sessionInvalidated(error: let error):
                    print(error?.localizedDescription ?? "")
                case .sessionTaskFailed(error: let error):
                    print(error.localizedDescription)
                case .urlRequestValidationFailed(reason: let reason):
                    print(reason)
                }
            } else if let error = response.error {
                message = ("URLError occurred: \(error)")
            } else {
                message = ""
            }
            return message == nil ? "" : message
        }
    }
    
    //------------------------------------------------------
    //MARK: - CheckRefreshTokenApi
    /*
     =====================API CALL=====================
     APIName        : Refresh Token
     Url            : "/token"
     Method         : POST
     Parameters     : { grant_type  : refresh_token
     refresh_token  : ""
     client_id      : tcba_iphone
     device_id      : "" }
     ===================================================
     */
    func CallCheckRefreshTokenApi(debugInfo isPrint: Bool = true
        , withBlock completion : @escaping (Bool) -> Void){
        
        guard let expiryDate = GConstant.UserData?.expires else {return}
        let expired = GFunction.shared.compareDateTrueIfExpire(dateString: expiryDate)
        
        if expired {
            let requestModel = RequestModal.mUserData()
            guard let refreshToken      = GConstant.UserData?.refreshToken else{return}
            requestModel.refresh_token  = refreshToken
            requestModel.grant_type     = "refresh_token"
            requestModel.client_id      = "tcba_iphone"
            requestModel.device_id      = GFunction.shared.getDeviceId()
            
            AF.request(GAPIConstant.Url.RefreshToken, method: .post, parameters: requestModel.toDictionary(), encoding: URLEncoding(), headers: APIHeaders.headers()).responseJSON { (response) in
                switch(response.result){
                case .success(let JSON):
                    if isPrint{ print(JSON) }
                    if response.response?.statusCode == 200 {
                        if let data = response.data {
                            DispatchQueue.main.async {
                                GFunction.shared.saveUserDataInDefaults(data)
                                GConstant.UserData = GFunction.shared.getUserDataFromDefaults()
                                completion(true)
                            }
                        }
                    }else {
                        GFunction.shared.makeUserLoginAlert()
                    }
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    GFunction.shared.userLogOut()
                    break
                }
            }
        } else {
            completion(true)
        }
    }
    //------------------------------------------------------
    
    //MARK: - GET
    
    //GET Method
    //Parameter
    //url :- method name of API like user/login
    //parameter : - parameter which is required to pass in API
    //errorAlert : - pass Bool value to decide if any error occcued then display alert or not
    //isLoader : - to decide if Add loader or not
    //isPrint : - to decide print parameter and response
    //completion :- completion block for pass response in class
    
    func GET(strURL url : String
        ,parameter : Dictionary<String,Any>?
        ,withErrorAlert errorAlert : Bool = false
        ,withLoader isLoader : Bool = true
        ,debugInfo isPrint: Bool = false
        ,withBlock completion :@escaping (Data?, Int?, String) -> Void) {
        
        if Connectivity.isConnectedToInternet {
            
            if isPrint {
                print("*****************URL***********************\n")
                print("URL:- \(url)\n")
                print("Parameter:-\(String(describing: parameter))\n")
                print("MethodType:- GET\n")
                print("*****************End***********************\n")
            }
            
            var param = Dictionary<String,Any>()
            if parameter != nil {
                param = parameter!
            }
            
            // add loader if isLoader is true
            DispatchQueue.main.async {
                if isLoader {
                    GFunction.shared.addLoader()
                }
            }
            
            AF.request(url, method: .get, parameters: param, encoding: URLEncoding(), headers: APIHeaders.headersWithBearerToken()).responseJSON(completionHandler: { (response) in
                
                switch(response.result) {
                case .success(let JSON):
                    DispatchQueue.main.async {
                        if isPrint {
                            print(JSON)
                        }
                        
                        // remove loader if isLoader is true
                        if isLoader {
                            GFunction.shared.removeLoader()
                        }
                        
                        var statusCode = 0
                        if let headerResponse = response.response {
                            statusCode = headerResponse.statusCode
                            if statusCode == 401{
                                GFunction.shared.makeUserLoginAlert()
                            }else{
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
                                    completion(response.data, statusCode, APIError.handleError(response: response))
                                })
                            }
                        }
                    }
                    
                // Yeah! Hand response
                case .failure(let error):
                    
                    if isLoader {
                        GFunction.shared.removeLoader()
                    }
                    
                    var statusCode = 0
                    
                    //Logout User
                    if let headerResponse = response.response {
                        statusCode = headerResponse.statusCode
                        if (headerResponse.statusCode == 401) {
                            //TODO: Add your logout code here
                            GFunction.shared.makeUserLoginAlert()
                        }
                    }
                    
                    //Display error Alert if errorAlert is true
                    if(errorAlert) {
                        let err = error as NSError
                        if statusCode != 401
                            && err.code != NSURLErrorTimedOut
                            && err.code != NSURLErrorNetworkConnectionLost
                            && err.code != NSURLErrorNotConnectedToInternet{
                            
                        } else {
                            print(error.localizedDescription)
                        }
                    }
                    completion(nil,statusCode,APIError.handleError(response: response))
                }
            })
        }
    }
    
    func GETWithBearerAuth(strURL url : String
        ,parameter : Dictionary<String,Any>?
        ,withErrorAlert errorAlert : Bool = false
        ,withLoader isLoader : Bool = true
        ,debugInfo isPrint: Bool = true
        ,withBlock completion :@escaping (Data?, Int?, String) -> Void) {
        
        if Connectivity.isConnectedToInternet {
            self.CallCheckRefreshTokenApi { _ in
                if isPrint {
                    print("*****************URL***********************\n")
                    print("URL:- \(url)\n")
                    print("Parameter:-\(String(describing: parameter))\n")
                    print("MethodType:- GET\n")
                    print("*****************End***********************\n")
                }
                var param = Dictionary<String,Any>()
                if parameter != nil {
                    param = parameter!
                }
                
                // add loader if isLoader is true
                DispatchQueue.main.async {
                    if isLoader {
                        GFunction.shared.addLoader()
                    }
                }
                
                AF.request(url, method: .get, parameters: param, encoding: URLEncoding(), headers: APIHeaders.headersWithBearerToken()).responseJSON(completionHandler: { (response) in
                    
                    switch(response.result) {
                    case .success(let JSON):
                        DispatchQueue.main.async {
                            if isPrint {
                                print(JSON)
                            }
                            
                            // remove loader if isLoader is true
                            if isLoader {
                                GFunction.shared.removeLoader()
                            }
                            
                            var statusCode = 0
                            if let headerResponse = response.response {
                                statusCode = headerResponse.statusCode
                                if statusCode == 401{
                                    GFunction.shared.makeUserLoginAlert()
                                }else{
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
                                        completion(response.data, statusCode, APIError.handleError(response: response))
                                    })
                                }
                            }
                        }
                    // Yeah! Hand response
                    case .failure(let error):
                        
                        if isLoader {
                            GFunction.shared.removeLoader()
                        }
                        
                        var statusCode = 0
                        
                        //Logout User
                        if let headerResponse = response.response {
                            statusCode = headerResponse.statusCode
                            if (headerResponse.statusCode == 401) {
                                //TODO: Add your logout code here
                                GFunction.shared.makeUserLoginAlert()
                            }
                        }
                        
                        //Display error Alert if errorAlert is true
                        if(errorAlert) {
                            let err = error as NSError
                            if statusCode != 401
                                && err.code != NSURLErrorTimedOut
                                && err.code != NSURLErrorNetworkConnectionLost
                                && err.code != NSURLErrorNotConnectedToInternet{
                                
                            } else {
                                print(error.localizedDescription)
                            }
                        }
                        completion(nil,statusCode,APIError.handleError(response: response))
                    }
                })
            }
        }
    }
    //------------------------------------------------------
    
    //MARK: - POST
    
    //POST Method
    //Parameter
    //url :- method name of API like user/login
    //parameter : - parameter which is required to pass in API
    //errorAlert : - pass Bool value to decide if any error occcued then display alert or not // default value is false
    //isLoader : - to decide if Add loader or not                                            // default value is true
    //isPrint : - to decide print parameter and response                                     // default value is false
    //blockFormData : - Pass image or array of image if you have to pass in API
    //completion :- completion block for pass response in class
    
    
    func POST(strURL url : String
        , parameter :  Dictionary<String, Any>?
        ,withErrorAlert errorAlert : Bool = false
        ,withLoader isLoader : Bool = true
        ,debugInfo isPrint: Bool = true
        , withBlock completion : @escaping (Data?, Int?, String) -> Void) {
        
        if Connectivity.isConnectedToInternet {
            if isPrint {
                print("*****************URL***********************\n")
                print("URL:- \(url)\n")
                print("Parameter:-\(String(describing: parameter))\n")
                print("MethodType:- POST\n")
                print("*****************End***********************\n")
            }
            
            var param = Dictionary<String,Any>()
            if parameter != nil {
                param = parameter!
            }
            
            // add loader if isLoader is true
            DispatchQueue.main.async {
                if isLoader {
                    GFunction.shared.addLoader()
                }
            }
            
            AF.request(url, method: .post, parameters: param, encoding: URLEncoding(), headers: APIHeaders.headers()).responseJSON(completionHandler: { (response) in
                
                switch(response.result) {
                case .success(let JSON):
                    DispatchQueue.main.async {
                        if isPrint {
                            print(JSON)
                        }
                        
                        // remove loader if isLoader is true
                        if isLoader {
                            GFunction.shared.removeLoader()
                        }
                        
                        var statusCode = 0
                        if let headerResponse = response.response {
                            statusCode = headerResponse.statusCode
                            if statusCode == 401{
                                GFunction.shared.makeUserLoginAlert()
                            }else{
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
                                    completion(response.data, statusCode, APIError.handleError(response: response))
                                })
                            }
                        }
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        
                        if isLoader {
                            GFunction.shared.removeLoader()
                        }
                        
                        var statusCode = 0
                        
                        //Logout User
                        if let headerResponse = response.response {
                            statusCode = headerResponse.statusCode
                            if (headerResponse.statusCode == 401) {
                                //TODO: Add your logout code here
                                GFunction.shared.makeUserLoginAlert()
                            }
                        }
                        
                        //Display error Alert if errorAlert is true
                        if(errorAlert) {
                            let err = error as NSError
                            if statusCode != 401
                                && err.code != NSURLErrorTimedOut
                                && err.code != NSURLErrorNetworkConnectionLost
                                && err.code != NSURLErrorNotConnectedToInternet{
                                
                            } else {
                                print(error.localizedDescription)
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
                            completion(nil, statusCode, APIError.handleError(response: response))
                        })
                    }
                }
            })
        }
    }
    
    func POSTWithBearerAuth(strURL url : String
        , parameter :  Dictionary<String, Any>?
        , withErrorAlert errorAlert : Bool = false
        , withLoader isLoader : Bool = true
        , debugInfo isPrint: Bool = true
        , contentType: String = "application/json"
        , encording: ParameterEncoding = JSONEncoding()
        , withBlock completion : @escaping (Data?, Int?, String) -> Void) {
        
        if Connectivity.isConnectedToInternet {
            self.CallCheckRefreshTokenApi { _ in
                if isPrint {
                    print("*****************URL***********************\n")
                    print("URL:- \(url)\n")
                    print("Parameter:-\(parameter ?? [:])\n")
                    print("MethodType:- POST\n")
                    print("*****************End***********************\n")
                }
                
                var param = Dictionary<String,Any>()
                if parameter != nil {
                    param = parameter!
                }
                
                // add loader if isLoader is true
                DispatchQueue.main.async {
                    if isLoader {
                        GFunction.shared.addLoader()
                    }
                }
                
                
                AF.request(url, method: .post, parameters: param, encoding: encording, headers: APIHeaders.headersWithBearerToken(contentType: contentType)).responseJSON(completionHandler: { (response) in
                    
                    switch(response.result) {
                    case .success(let JSON):
                        DispatchQueue.main.async {
                            if isPrint {
                                print(JSON)
                            }
                            
                            // remove loader if isLoader is true
                            if isLoader {
                                GFunction.shared.removeLoader()
                            }
                            
                            var statusCode = 0
                            if let headerResponse = response.response {
                                statusCode = headerResponse.statusCode
                                if statusCode == 401{
                                    GFunction.shared.makeUserLoginAlert()
                                }else{
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
                                        completion(response.data, statusCode, APIError.handleError(response: response))
                                    })
                                }
                            }
                        }
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            
                            if isLoader {
                                GFunction.shared.removeLoader()
                            }
                            
                            var statusCode = 0
                            
                            //Logout User
                            if let headerResponse = response.response {
                                statusCode = headerResponse.statusCode
                                if (headerResponse.statusCode == 401) {
                                    //TODO: Add your logout code here
                                    GFunction.shared.makeUserLoginAlert()
                                }
                            }
                            
                            //Display error Alert if errorAlert is true
                            if(errorAlert) {
                                let err = error as NSError
                                if statusCode != 401
                                    && err.code != NSURLErrorTimedOut
                                    && err.code != NSURLErrorNetworkConnectionLost
                                    && err.code != NSURLErrorNotConnectedToInternet{
                                    
                                } else {
                                    print(error.localizedDescription)
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
                                completion(nil, statusCode, APIError.handleError(response: response))
                            })
                        }
                    }
                })
            }
        }
    }
    
    func Upload(strURL url : String
        , parameter :  Dictionary<String, Any>?
        ,withErrorAlert errorAlert : Bool = true
        ,withLoader isLoader : Bool = false
        ,debugInfo isPrint: Bool = false
        ,constructingBodyWithBlock blockFormData: ((MultipartFormData?) -> Void)? = nil
        , withBlock completion : @escaping (Data?, Int?, String) -> Void) {
        
        if Connectivity.isConnectedToInternet {
            if isPrint{
                print("*****************URL***********************\n")
                print("URL:- \(url)\n")
                print("Parameter:-\(String(describing: parameter))\n")
                print("MethodType:- POST\n")
                print("*****************End***********************\n")
            }
            
            // add loader if isLoader is true
            DispatchQueue.main.async {
                if isLoader {
                    GFunction.shared.addLoader()
                }
            }
            
            AF.upload(multipartFormData: blockFormData!, to: url, method: .post , headers: APIHeaders.headersForMultipart())
                .response { response in
                    switch(response.result) {
                    case .success(let JSON):
                        DispatchQueue.main.async {
                            if isPrint {
                                if let statusCode = response.response?.statusCode {
                                    print("Status Code: \(statusCode)")
                                }
                                print(JSON as Any)
                            }
                            
                            // remove loader if isLoader is true
                            if isLoader {
                                GFunction.shared.removeLoader()
                            }
                            
                            var statusCode = 0
                            if let headerResponse = response.response {
                                statusCode = headerResponse.statusCode
                                if statusCode == 401{
                                    DispatchQueue.main.async {
                                        GFunction.shared.removeLoader()
                                    }
                                    //                                        GFunction.shared.makeUserLoginAlert()
                                }else{
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
                                        completion(response.data, statusCode, "")
                                    })
                                }
                            }
                        }
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            
                            if isLoader {
                                GFunction.shared.removeLoader()
                            }
                            
                            var statusCode = 0
                            
                            //Logout User
                            if let headerResponse = response.response {
                                statusCode = headerResponse.statusCode
                                print("Status Code: \(statusCode)")
                                if (headerResponse.statusCode == 401) {
                                    //TODO: Add your logout code here
                                    //                                        GFunction.shared.makeUserLoginAlert()
                                }
                            }
                            
                            //Display error Alert if errorAlert is true
                            if(errorAlert) {
                                let err = error as NSError
                                if statusCode != 401
                                    && err.code != NSURLErrorTimedOut
                                    && err.code != NSURLErrorNetworkConnectionLost
                                    && err.code != NSURLErrorNotConnectedToInternet{
                                    
                                } else {
                                    print(error.localizedDescription)
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
                                completion(nil, statusCode, response.error.debugDescription)
                            })
                        }
                    }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
                completion(nil, nil, "")
            })
        }
    }
    
    //MARK: PUT
    
    func PUTWithBearerAuth(strURL url : String
        , parameter :  Dictionary<String, Any>?
        , withErrorAlert errorAlert : Bool = false
        , withLoader isLoader : Bool = true
        , debugInfo isPrint: Bool = true
        , contentType: String = "application/json"
        , encording: ParameterEncoding = JSONEncoding()
        , withBlock completion : @escaping (Data?, Int?, String) -> Void) {
        
        if Connectivity.isConnectedToInternet {
            self.CallCheckRefreshTokenApi { _ in
                if isPrint {
                    print("*****************URL***********************\n")
                    print("URL:- \(url)\n")
                    print("Parameter:-\(parameter ?? [:])\n")
                    print("MethodType:- PUT\n")
                    print("*****************End***********************\n")
                }
                
                var param = Dictionary<String,Any>()
                if parameter != nil {
                    param = parameter!
                }
                
                // add loader if isLoader is true
                DispatchQueue.main.async {
                    if isLoader {
                        GFunction.shared.addLoader()
                    }
                }
                
                AF.request(url, method: .put, parameters: param, encoding: encording, headers: APIHeaders.headersWithBearerToken(contentType: contentType)).responseJSON(completionHandler: { (response) in
                    
                    switch(response.result) {
                    case .success(let JSON):
                        DispatchQueue.main.async {
                            if isPrint {
                                print(JSON)
                            }
                            
                            // remove loader if isLoader is true
                            if isLoader {
                                GFunction.shared.removeLoader()
                            }
                            
                            var statusCode = 0
                            if let headerResponse = response.response {
                                statusCode = headerResponse.statusCode
                                if statusCode == 401{
                                    GFunction.shared.makeUserLoginAlert()
                                }else{
                                    DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
                                        completion(response.data, statusCode, APIError.handleError(response: response))
                                    })
                                }
                            }
                        }
                        
                    case .failure(let error):
                        DispatchQueue.main.async {
                            
                            if isLoader {
                                GFunction.shared.removeLoader()
                            }
                            
                            var statusCode = 0
                            
                            //Logout User
                            if let headerResponse = response.response {
                                statusCode = headerResponse.statusCode
                                if (headerResponse.statusCode == 401) {
                                    //TODO: Add your logout code here
                                    GFunction.shared.makeUserLoginAlert()
                                }
                            }
                            
                            //Display error Alert if errorAlert is true
                            if(errorAlert) {
                                let err = error as NSError
                                if statusCode != 401
                                    && err.code != NSURLErrorTimedOut
                                    && err.code != NSURLErrorNetworkConnectionLost
                                    && err.code != NSURLErrorNotConnectedToInternet{
                                    
                                } else {
                                    print(error.localizedDescription)
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.05, execute: {
                                completion(nil, statusCode, APIError.handleError(response: response))
                            })
                        }
                    }
                })
            }
        }
    }
}
