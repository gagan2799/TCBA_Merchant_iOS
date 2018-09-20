//
//  StatesModel.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 20/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let statesModel = try StatesModel(json)

import Foundation

struct StatesModel: Codable {
    let states: [StatesState]?
}

struct StatesState: Codable {
    let stateID: Int?
    let stateName, stateCode: String?
    let countryID: Int?
    
    enum CodingKeys: String, CodingKey {
        case stateID = "stateId"
        case stateName, stateCode
        case countryID = "countryId"
    }
}

// MARK: Convenience initializers and mutators

extension StatesModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StatesModel.self, from: data)
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
        states: [StatesState]?? = nil
        ) -> StatesModel {
        return StatesModel(
            states: states ?? self.states
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension StatesState {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StatesState.self, from: data)
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
        stateID: Int?? = nil,
        stateName: String?? = nil,
        stateCode: String?? = nil,
        countryID: Int?? = nil
        ) -> StatesState {
        return StatesState(
            stateID: stateID ?? self.stateID,
            stateName: stateName ?? self.stateName,
            stateCode: stateCode ?? self.stateCode,
            countryID: countryID ?? self.countryID
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
