//
//  MemberTrasactionModal.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 14/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//
// Generated with quicktype
// For more options, try https://app.quicktype.io

import Foundation

struct MemberTrasactionModal: Codable {
    let memberID: Int?
    let firstName, lastName: String
    let totalNumberOfMembers: Int
    let profileImageURL: String
    let totalNumberOfTransactions: Int
    let belongsToMerchantMatrix, firstTimeUse: Bool
    let totalPurchaseValue, availableLoyaltyCash: Double
    let availablePrizeCash: Int

    enum CodingKeys: String, CodingKey {
        case memberID, firstName, lastName, totalNumberOfMembers
        case profileImageURL = "profileImageUrl"
        case totalNumberOfTransactions, belongsToMerchantMatrix, firstTimeUse, totalPurchaseValue, availableLoyaltyCash, availablePrizeCash
    }
}

// MARK: Convenience initializers

extension MemberTrasactionModal {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(MemberTrasactionModal.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
