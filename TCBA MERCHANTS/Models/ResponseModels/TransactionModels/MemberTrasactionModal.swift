//
//  MemberTrasactionModal.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 14/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let memberTransactionDetailsModel = try MemberTransactionDetailsModel(json)

import Foundation

struct MemberTransactionDetailsModel: Codable {
    let memberID: Int?
    let firstName, lastName: String?
    let totalNumberOfMembers: Int?
    let profileImageURL: String?
    let totalNumberOfTransactions: Int?
    let belongsToMerchantMatrix, firstTimeUse: Bool?
    let totalPurchaseValue: Double?
    let availableLoyaltyCash, availablePrizeCash: Int?
    
    enum CodingKeys: String, CodingKey {
        case memberID, firstName, lastName, totalNumberOfMembers
        case profileImageURL = "profileImageUrl"
        case totalNumberOfTransactions, belongsToMerchantMatrix, firstTimeUse, totalPurchaseValue, availableLoyaltyCash, availablePrizeCash
    }
}

// MARK: Convenience initializers and mutators

extension MemberTransactionDetailsModel {
    init(data: Data) throws {
        self = try JSONDecoder().decode(MemberTransactionDetailsModel.self, from: data)
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
        memberID: Int?? = nil,
        firstName: String?? = nil,
        lastName: String?? = nil,
        totalNumberOfMembers: Int?? = nil,
        profileImageURL: String?? = nil,
        totalNumberOfTransactions: Int?? = nil,
        belongsToMerchantMatrix: Bool?? = nil,
        firstTimeUse: Bool?? = nil,
        totalPurchaseValue: Double?? = nil,
        availableLoyaltyCash: Int?? = nil,
        availablePrizeCash: Int?? = nil
        ) -> MemberTransactionDetailsModel {
        return MemberTransactionDetailsModel(
            memberID: memberID ?? self.memberID,
            firstName: firstName ?? self.firstName,
            lastName: lastName ?? self.lastName,
            totalNumberOfMembers: totalNumberOfMembers ?? self.totalNumberOfMembers,
            profileImageURL: profileImageURL ?? self.profileImageURL,
            totalNumberOfTransactions: totalNumberOfTransactions ?? self.totalNumberOfTransactions,
            belongsToMerchantMatrix: belongsToMerchantMatrix ?? self.belongsToMerchantMatrix,
            firstTimeUse: firstTimeUse ?? self.firstTimeUse,
            totalPurchaseValue: totalPurchaseValue ?? self.totalPurchaseValue,
            availableLoyaltyCash: availableLoyaltyCash ?? self.availableLoyaltyCash,
            availablePrizeCash: availablePrizeCash ?? self.availablePrizeCash
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
