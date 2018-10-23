//
//  GetUserMatrixModel.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//
// Generated with quicktype
// For more options, try https://app.quicktype.io

import Foundation

struct GetUserMatrixModel: Codable {
    let firstName, lastName: String
    let userID: Int
    let profilePhotoURL: String
    let userMatrix: [UserMatrix]

    enum CodingKeys: String, CodingKey {
        case firstName, lastName
        case userID = "userId"
        case profilePhotoURL = "profilePhotoUrl"
        case userMatrix
    }
}

struct UserMatrix: Codable {
    let totalUsers: Int
    let totalMatrixCash: Double
    let totalMatrixCashPending, level: Int
}

// MARK: Convenience initializers

extension GetUserMatrixModel {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(GetUserMatrixModel.self, from: data) else { return nil }
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

extension UserMatrix {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(UserMatrix.self, from: data) else { return nil }
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
