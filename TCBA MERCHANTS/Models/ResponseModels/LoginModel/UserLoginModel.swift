// To parse the JSON, add this file to your project and do:
//
//   let userLoginModel = try UserLoginModel(json)

import Foundation

struct UserLoginModel: Codable {
    let accessToken, tokenType: String?
    let expiresIn: Int?
    let refreshToken, asClientID, asDeviceID, userID: String?
    let issued, expires, firstName, lastName: String?
    let isMerchant: Bool?
    let profilePhotoURL: String?
    let isProfileComplete: Bool?
    var pinAction, stores: String?
    let newPin: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case asClientID = "as:client_id"
        case asDeviceID = "as:device_id"
        case userID = "userId"
        case issued = ".issued"
        case expires = ".expires"
        case firstName, lastName, isMerchant
        case profilePhotoURL = "profilePhotoUrl"
        case isProfileComplete, pinAction, stores
        case newPin = "newPin"
    }
}

// MARK: UserLoginModel convenience initializers and mutators

extension UserLoginModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UserLoginModel.self, from: data)
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
        userID: String?? = nil,
        issued: String?? = nil,
        expires: String?? = nil,
        firstName: String?? = nil,
        lastName: String?? = nil,
        isMerchant: Bool?? = nil,
        profilePhotoURL: String?? = nil,
        isProfileComplete: Bool?? = nil,
        pinAction: String?? = nil,
        stores: String?? = nil,
        newPin: String?? = nil
    ) -> UserLoginModel {
        return UserLoginModel(
            accessToken: accessToken ?? self.accessToken,
            tokenType: tokenType ?? self.tokenType,
            expiresIn: expiresIn ?? self.expiresIn,
            refreshToken: refreshToken ?? self.refreshToken,
            asClientID: asClientID ?? self.asClientID,
            asDeviceID: asDeviceID ?? self.asDeviceID,
            userID: userID ?? self.userID,
            issued: issued ?? self.issued,
            expires: expires ?? self.expires,
            firstName: firstName ?? self.firstName,
            lastName: lastName ?? self.lastName,
            isMerchant: isMerchant ?? self.isMerchant,
            profilePhotoURL: profilePhotoURL ?? self.profilePhotoURL,
            isProfileComplete: isProfileComplete ?? self.isProfileComplete,
            pinAction: pinAction ?? self.pinAction,
            stores: stores ?? self.stores,
            newPin: newPin ?? self.newPin
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
