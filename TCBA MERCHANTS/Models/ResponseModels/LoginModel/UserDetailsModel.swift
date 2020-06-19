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
    public var userId: Int?
    public var userMatrixNodeId: Int?
    public var username: String?
    public var firstName: String?
    public var lastName: String?
    public var abn: String?
    public var email: String?
    public var phoneNumber: String?
    public var address: String?
    public var city: String?
    public var postcode: String?
    public var stateId: Int?
    public var state: String?
    public var countryId: Int?
    public var countryName: String?
    public var profileImageUrl: String?
    public var dob: String?
    public var gender: String?
    public var isMerchant: Bool?
    public var qrCodeImage: String?
    public var walletIsActive: Bool?
    public var walletNumber: String?
    public var pinAction: String?
    public var isProfileComplete: Bool?
    public var shareLink: String?
    public var shareMessage: String?

    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case userMatrixNodeId = "userMatrixNodeId"
        case username = "username"
        case firstName = "firstName"
        case lastName = "lastName"
        case abn = "abn"
        case email = "email"
        case phoneNumber = "phoneNumber"
        case address = "address"
        case city = "city"
        case postcode = "postcode"
        case stateId = "stateId"
        case state = "state"
        case countryId = "countryId"
        case countryName = "countryName"
        case profileImageUrl = "profileImageUrl"
        case dob = "dob"
        case gender = "gender"
        case isMerchant = "isMerchant"
        case qrCodeImage = "qrCodeImage"
        case walletIsActive = "walletIsActive"
        case walletNumber = "walletNumber"
        case pinAction = "pinAction"
        case isProfileComplete = "isProfileComplete"
        case shareLink = "shareLink"
        case shareMessage = "shareMessage"
    }

    public init(userId: Int?, userMatrixNodeId: Int?, username: String?, firstName: String?, lastName: String?, abn: String?, email: String?, phoneNumber: String?, address: String?, city: String?, postcode: String?, stateId: Int?, state: String?, countryId: Int?, countryName: String?, profileImageUrl: String?, dob: String?, gender: String?, isMerchant: Bool?, qrCodeImage: String?, walletIsActive: Bool?, walletNumber: String?, pinAction: String?, isProfileComplete: Bool?, shareLink: String?, shareMessage: String?) {
        self.userId = userId
        self.userMatrixNodeId = userMatrixNodeId
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.abn = abn
        self.email = email
        self.phoneNumber = phoneNumber
        self.address = address
        self.city = city
        self.postcode = postcode
        self.stateId = stateId
        self.state = state
        self.countryId = countryId
        self.countryName = countryName
        self.profileImageUrl = profileImageUrl
        self.dob = dob
        self.gender = gender
        self.isMerchant = isMerchant
        self.qrCodeImage = qrCodeImage
        self.walletIsActive = walletIsActive
        self.walletNumber = walletNumber
        self.pinAction = pinAction
        self.isProfileComplete = isProfileComplete
        self.shareLink = shareLink
        self.shareMessage = shareMessage
    }
}
