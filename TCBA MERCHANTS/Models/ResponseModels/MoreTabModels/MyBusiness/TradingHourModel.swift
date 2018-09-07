//
//  TradingHourModal.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 06/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
// To parse the JSON, add this file to your project and do:
//
//   let tradingHourModel = try TradingHourModel(json)

import Foundation

struct TradingHourModel: Codable {
    var days: [TradingHourDay]?
}

struct TradingHourDay: Codable {
    var status, day: String?
    var shifts: [TradingHourShift]?
}

struct TradingHourShift: Codable {
    var startTime, endTime: String?
}

// MARK: Convenience initializers and mutators

extension TradingHourModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TradingHourModel.self, from: data)
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
        days: [TradingHourDay]?? = nil
        ) -> TradingHourModel {
        return TradingHourModel(
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

extension TradingHourDay {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TradingHourDay.self, from: data)
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
        shifts: [TradingHourShift]?? = nil
        ) -> TradingHourDay {
        return TradingHourDay(
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

extension TradingHourShift {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(TradingHourShift.self, from: data)
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
        ) -> TradingHourShift {
        return TradingHourShift(
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
