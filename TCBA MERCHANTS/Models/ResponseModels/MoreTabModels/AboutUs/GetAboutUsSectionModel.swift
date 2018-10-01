//
//  GetAboutUsSectionModel.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 01/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let getAboutUsSectionModel = try GetAboutUsSectionModel(json)

import Foundation

struct GetAboutUsSectionModel: Codable {
    let about: [GetAboutUsSectionAbout]?
}

struct GetAboutUsSectionAbout: Codable {
    let title: String?
    let image: String?
    let link: String?
    let description, modified: String?
}

// MARK: Convenience initializers and mutators

extension GetAboutUsSectionModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GetAboutUsSectionModel.self, from: data)
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
        about: [GetAboutUsSectionAbout]?? = nil
        ) -> GetAboutUsSectionModel {
        return GetAboutUsSectionModel(
            about: about ?? self.about
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension GetAboutUsSectionAbout {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GetAboutUsSectionAbout.self, from: data)
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
        title: String?? = nil,
        image: String?? = nil,
        link: String?? = nil,
        description: String?? = nil,
        modified: String?? = nil
        ) -> GetAboutUsSectionAbout {
        return GetAboutUsSectionAbout(
            title: title ?? self.title,
            image: image ?? self.image,
            link: link ?? self.link,
            description: description ?? self.description,
            modified: modified ?? self.modified
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
