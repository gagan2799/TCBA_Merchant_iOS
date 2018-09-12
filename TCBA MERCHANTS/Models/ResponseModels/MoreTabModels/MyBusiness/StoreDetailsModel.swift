//
//  StoreDetailsModel.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 12/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let storeDetailsModel = try StoreDetailsModel(json)

import Foundation

struct StoreDetailsModel: Codable {
    let storeID, merchantID: Int?
    let merchantEmailAddress, created, modified, storeTitle: String?
    let storeDescription, storeTerms, storeFeatures, storeAbout: String?
    let storeIcon: String?
    let storeEmail: String?
    let latitude, longitude: Double?
    let cashback, loyalty, cbaMatrixCash, firstLevelUserMatrixCash: Int?
    let userMatrixCash, totalAmountPercentage: Int?
    let showAddress: Bool?
    let businessName, abn, phoneNumber: String?
    let businessHours: StoreDetailsBusinessHours?
    let storeImages: [StoreDetailsStoreImage]?
    
    enum CodingKeys: String, CodingKey {
        case storeID = "storeId"
        case merchantID = "merchantId"
        case merchantEmailAddress, created, modified, storeTitle, storeDescription, storeTerms, storeFeatures, storeAbout, storeIcon, storeEmail, latitude, longitude, cashback, loyalty, cbaMatrixCash, firstLevelUserMatrixCash, userMatrixCash, totalAmountPercentage, showAddress, businessName, abn, phoneNumber, businessHours, storeImages
    }
}

struct StoreDetailsBusinessHours: Codable {
    let days: [StoreDetailsDay]?
}

struct StoreDetailsDay: Codable {
    let status, day: String?
    let shifts: [StoreDetailsShift]?
}

struct StoreDetailsShift: Codable {
    let startTime, endTime: String?
}

struct StoreDetailsStoreImage: Codable {
    let imageID, imageOrder: Int?
    let imageURLOriginal: String?
    
    enum CodingKeys: String, CodingKey {
        case imageID = "imageId"
        case imageOrder
        case imageURLOriginal = "imageUrlOriginal"
    }
}

// MARK: Convenience initializers and mutators

extension StoreDetailsModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StoreDetailsModel.self, from: data)
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
        storeID: Int?? = nil,
        merchantID: Int?? = nil,
        merchantEmailAddress: String?? = nil,
        created: String?? = nil,
        modified: String?? = nil,
        storeTitle: String?? = nil,
        storeDescription: String?? = nil,
        storeTerms: String?? = nil,
        storeFeatures: String?? = nil,
        storeAbout: String?? = nil,
        storeIcon: String?? = nil,
        storeEmail: String?? = nil,
        latitude: Double?? = nil,
        longitude: Double?? = nil,
        cashback: Int?? = nil,
        loyalty: Int?? = nil,
        cbaMatrixCash: Int?? = nil,
        firstLevelUserMatrixCash: Int?? = nil,
        userMatrixCash: Int?? = nil,
        totalAmountPercentage: Int?? = nil,
        showAddress: Bool?? = nil,
        businessName: String?? = nil,
        abn: String?? = nil,
        phoneNumber: String?? = nil,
        businessHours: StoreDetailsBusinessHours?? = nil,
        storeImages: [StoreDetailsStoreImage]?? = nil
        ) -> StoreDetailsModel {
        return StoreDetailsModel(
            storeID: storeID ?? self.storeID,
            merchantID: merchantID ?? self.merchantID,
            merchantEmailAddress: merchantEmailAddress ?? self.merchantEmailAddress,
            created: created ?? self.created,
            modified: modified ?? self.modified,
            storeTitle: storeTitle ?? self.storeTitle,
            storeDescription: storeDescription ?? self.storeDescription,
            storeTerms: storeTerms ?? self.storeTerms,
            storeFeatures: storeFeatures ?? self.storeFeatures,
            storeAbout: storeAbout ?? self.storeAbout,
            storeIcon: storeIcon ?? self.storeIcon,
            storeEmail: storeEmail ?? self.storeEmail,
            latitude: latitude ?? self.latitude,
            longitude: longitude ?? self.longitude,
            cashback: cashback ?? self.cashback,
            loyalty: loyalty ?? self.loyalty,
            cbaMatrixCash: cbaMatrixCash ?? self.cbaMatrixCash,
            firstLevelUserMatrixCash: firstLevelUserMatrixCash ?? self.firstLevelUserMatrixCash,
            userMatrixCash: userMatrixCash ?? self.userMatrixCash,
            totalAmountPercentage: totalAmountPercentage ?? self.totalAmountPercentage,
            showAddress: showAddress ?? self.showAddress,
            businessName: businessName ?? self.businessName,
            abn: abn ?? self.abn,
            phoneNumber: phoneNumber ?? self.phoneNumber,
            businessHours: businessHours ?? self.businessHours,
            storeImages: storeImages ?? self.storeImages
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension StoreDetailsBusinessHours {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StoreDetailsBusinessHours.self, from: data)
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
        days: [StoreDetailsDay]?? = nil
        ) -> StoreDetailsBusinessHours {
        return StoreDetailsBusinessHours(
            days: days ?? self.days
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension StoreDetailsDay {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StoreDetailsDay.self, from: data)
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
        status: String?? = nil,
        day: String?? = nil,
        shifts: [StoreDetailsShift]?? = nil
        ) -> StoreDetailsDay {
        return StoreDetailsDay(
            status: status ?? self.status,
            day: day ?? self.day,
            shifts: shifts ?? self.shifts
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension StoreDetailsShift {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StoreDetailsShift.self, from: data)
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
        startTime: String?? = nil,
        endTime: String?? = nil
        ) -> StoreDetailsShift {
        return StoreDetailsShift(
            startTime: startTime ?? self.startTime,
            endTime: endTime ?? self.endTime
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension StoreDetailsStoreImage {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StoreDetailsStoreImage.self, from: data)
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
        imageID: Int?? = nil,
        imageOrder: Int?? = nil,
        imageURLOriginal: String?? = nil
        ) -> StoreDetailsStoreImage {
        return StoreDetailsStoreImage(
            imageID: imageID ?? self.imageID,
            imageOrder: imageOrder ?? self.imageOrder,
            imageURLOriginal: imageURLOriginal ?? self.imageURLOriginal
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
