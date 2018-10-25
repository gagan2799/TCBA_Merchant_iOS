//
//  GetMerchantStoresModel.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 25/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//
// Generated with quicktype
// For more options, try https://app.quicktype.io

import Foundation

struct GetMerchantStoresModel: Codable {
    let stores: [Store]
}

struct Store: Codable {
    let storeID: Int
    let storeTitle, storeCity, storeIcon: String

    enum CodingKeys: String, CodingKey {
        case storeID = "storeId"
        case storeTitle, storeCity, storeIcon
    }
}

// MARK: Convenience initializers

extension GetMerchantStoresModel {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(GetMerchantStoresModel.self, from: data) else { return nil }
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

extension Store {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Store.self, from: data) else { return nil }
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

