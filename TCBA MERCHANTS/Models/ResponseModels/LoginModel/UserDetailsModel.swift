//
//  UserDetailsModel.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 21/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
// To parse the JSON, add this file to your project and do:
//
//   let userDetailsModel = try UserDetailsModel(json)

import Foundation

struct UserDetailsModel: Codable {
    let userID: Int?
    let username, firstName, lastName, abn: String?
    let email, phoneNumber, address, city: String?
    let postcode: String?
    let stateID: Int?
    let state: String?
    let countryID: Int?
    let countryName: String?
    let profileImageURL: String?
    let dob, gender: String?
    let isMerchant: Bool?
    let qrCodeImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case username, firstName, lastName, abn, email, phoneNumber, address, city, postcode
        case stateID = "stateId"
        case state
        case countryID = "countryId"
        case countryName
        case profileImageURL = "profileImageUrl"
        case dob, gender, isMerchant, qrCodeImage
    }
}

// MARK: Convenience initializers and mutators

extension UserDetailsModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UserDetailsModel.self, from: data)
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
        userID: Int?? = nil,
        username: String?? = nil,
        firstName: String?? = nil,
        lastName: String?? = nil,
        abn: String?? = nil,
        email: String?? = nil,
        phoneNumber: String?? = nil,
        address: String?? = nil,
        city: String?? = nil,
        postcode: String?? = nil,
        stateID: Int?? = nil,
        state: String?? = nil,
        countryID: Int?? = nil,
        countryName: String?? = nil,
        profileImageURL: String?? = nil,
        dob: String?? = nil,
        gender: String?? = nil,
        isMerchant: Bool?? = nil,
        qrCodeImage: String?? = nil
        ) -> UserDetailsModel {
        return UserDetailsModel(
            userID: userID ?? self.userID,
            username: username ?? self.username,
            firstName: firstName ?? self.firstName,
            lastName: lastName ?? self.lastName,
            abn: abn ?? self.abn,
            email: email ?? self.email,
            phoneNumber: phoneNumber ?? self.phoneNumber,
            address: address ?? self.address,
            city: city ?? self.city,
            postcode: postcode ?? self.postcode,
            stateID: stateID ?? self.stateID,
            state: state ?? self.state,
            countryID: countryID ?? self.countryID,
            countryName: countryName ?? self.countryName,
            profileImageURL: profileImageURL ?? self.profileImageURL,
            dob: dob ?? self.dob,
            gender: gender ?? self.gender,
            isMerchant: isMerchant ?? self.isMerchant,
            qrCodeImage: qrCodeImage ?? self.qrCodeImage
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
