//
//  VideoCategoryModel.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 05/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let videoCategoryModel = try VideoCategoryModel(json)

import Foundation

struct VideoCategoryModel: Codable {
    let videos: [VideoCategoryVideo]?
}

struct VideoCategoryVideo: Codable {
    let categoryID: Int?
    let title: String?
    let numberOfVideos: Int?
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case title, numberOfVideos
    }
}

// MARK: Convenience initializers and mutators

extension VideoCategoryModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(VideoCategoryModel.self, from: data)
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
        videos: [VideoCategoryVideo]?? = nil
        ) -> VideoCategoryModel {
        return VideoCategoryModel(
            videos: videos ?? self.videos
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension VideoCategoryVideo {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(VideoCategoryVideo.self, from: data)
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
        categoryID: Int?? = nil,
        title: String?? = nil,
        numberOfVideos: Int?? = nil
        ) -> VideoCategoryVideo {
        return VideoCategoryVideo(
            categoryID: categoryID ?? self.categoryID,
            title: title ?? self.title,
            numberOfVideos: numberOfVideos ?? self.numberOfVideos
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
