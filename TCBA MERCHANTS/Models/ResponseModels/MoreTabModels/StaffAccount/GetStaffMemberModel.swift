//
//  GetStaffMemberModel.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//
// Generated with quicktype
// For more options, try https://app.quicktype.io

import Foundation

struct GetStaffMemberModel: Codable {
    var staffMembers: [StaffMember]
}

struct StaffMember: Codable {
    let staffMemberID: Int
    let active: Bool
    let firstName, lastName, phoneNumber, pinCode: String
    let dateCreated, dateModified: String
    let staffStores: [StaffStore]

    enum CodingKeys: String, CodingKey {
        case staffMemberID = "staffMemberId"
        case active, firstName, lastName, phoneNumber, pinCode, dateCreated, dateModified, staffStores
    }
}

struct StaffStore: Codable {
    let storeID: Int
    let storeName, dateCreated: String
}

// MARK: Convenience initializers

extension GetStaffMemberModel {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(GetStaffMemberModel.self, from: data) else { return nil }
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

extension StaffMember {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(StaffMember.self, from: data) else { return nil }
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

extension StaffStore {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(StaffStore.self, from: data) else { return nil }
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

