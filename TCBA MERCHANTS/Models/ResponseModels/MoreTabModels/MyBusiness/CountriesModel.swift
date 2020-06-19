//
//  CBCountryStateModel.swift
//  Cash Back
//
//  Created by VarunKumar on 23/04/20.
//  Copyright © 2020 GSBitLabs. All rights reserved.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let cBCountryStateModel = try? newJSONDecoder().decode(CBCountryStateModel.self, from: jsonData)

import Foundation

// MARK: - CBCountryStateModel
public struct CountriesModel: Codable {
    public var countries: [CBCountry]?
    public var states: [CBState]?

    enum CodingKeys: String, CodingKey {
        case countries = "countries"
        case states = "states"
    }

    public init(countries: [CBCountry]?, states: [CBState]?) {
        self.countries = countries
        self.states = states
    }
}

// MARK: - CBCountry
public struct CBCountry: Codable {
    public var active: Bool?
    public var callingCode: String?
    public var countryId: Int?
    public var countryName: String?

    enum CodingKeys: String, CodingKey {
        case active = "active"
        case callingCode = "callingCode"
        case countryId = "countryId"
        case countryName = "countryName"
    }

    public init(active: Bool?, callingCode: String?, countryId: Int?, countryName: String?) {
        self.active = active
        self.callingCode = callingCode
        self.countryId = countryId
        self.countryName = countryName
    }
}

// MARK: - CBState
public struct CBState: Codable {
    public var stateId: Int?
    public var stateName: String?
    public var stateCode: String?
    public var countryId: Int?

    enum CodingKeys: String, CodingKey {
        case stateId = "stateId"
        case stateName = "stateName"
        case stateCode = "stateCode"
        case countryId = "countryId"
    }

    public init(stateId: Int?, stateName: String?, stateCode: String?, countryId: Int?) {
        self.stateId = stateId
        self.stateName = stateName
        self.stateCode = stateCode
        self.countryId = countryId
    }
}
