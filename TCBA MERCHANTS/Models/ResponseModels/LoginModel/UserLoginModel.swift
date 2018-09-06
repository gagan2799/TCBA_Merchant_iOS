// To parse the JSON, add this file to your project and do:
//
//   let userLoginModel = try UserLoginModel(json)

import Foundation

struct UserLoginModel: Codable {
    let accessToken, tokenType: String?
    let expiresIn: Int?
    let refreshToken, asClientID, asDeviceID, issued: String?
    let expires, firstName, lastName: String?
    let isMerchant: Bool?
    let userID: Int?
    let profilePhotoURL: String?
    let isProfileComplete: Bool?
    let stores: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case asClientID = "as:client_id"
        case asDeviceID = "as:device_id"
        case issued = ".issued"
        case expires = ".expires"
        case firstName, lastName, isMerchant
        case userID = "userId"
        case profilePhotoURL = "profilePhotoUrl"
        case isProfileComplete, stores
    }
}

// MARK: Convenience initializers and mutators

extension UserLoginModel {
    init(data: Data) throws {
        self = try JSONDecoder().decode(UserLoginModel.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        accessToken: String?? = nil,
        tokenType: String?? = nil,
        expiresIn: Int?? = nil,
        refreshToken: String?? = nil,
        asClientID: String?? = nil,
        asDeviceID: String?? = nil,
        issued: String?? = nil,
        expires: String?? = nil,
        firstName: String?? = nil,
        lastName: String?? = nil,
        isMerchant: Bool?? = nil,
        userID: Int?? = nil,
        profilePhotoURL: String?? = nil,
        isProfileComplete: Bool?? = nil,
        stores: String?? = nil
        ) -> UserLoginModel {
        return UserLoginModel(
            accessToken: accessToken ?? self.accessToken,
            tokenType: tokenType ?? self.tokenType,
            expiresIn: expiresIn ?? self.expiresIn,
            refreshToken: refreshToken ?? self.refreshToken,
            asClientID: asClientID ?? self.asClientID,
            asDeviceID: asDeviceID ?? self.asDeviceID,
            issued: issued ?? self.issued,
            expires: expires ?? self.expires,
            firstName: firstName ?? self.firstName,
            lastName: lastName ?? self.lastName,
            isMerchant: isMerchant ?? self.isMerchant,
            userID: userID ?? self.userID,
            profilePhotoURL: profilePhotoURL ?? self.profilePhotoURL,
            isProfileComplete: isProfileComplete ?? self.isProfileComplete,
            stores: stores ?? self.stores
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
