//
//  AlertNotificationsModel.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 05/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
// To parse the JSON, add this file to your project and do:
//
//   let alertNotificationsModel = try AlertNotificationsModel(json)

import Foundation

struct AlertNotificationsModel: Codable {
    let notifications: [AlertNotificationsNotification]?
}

struct AlertNotificationsNotification: Codable {
    let notificationID: Int?
    let title, description, videoLink, dateCreated: String?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case notificationID = "notificationId"
        case title, description, videoLink, dateCreated, image
    }
}

// MARK: Convenience initializers and mutators

extension AlertNotificationsModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AlertNotificationsModel.self, from: data)
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
        notifications: [AlertNotificationsNotification]?? = nil
        ) -> AlertNotificationsModel {
        return AlertNotificationsModel(
            notifications: notifications ?? self.notifications
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension AlertNotificationsNotification {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(AlertNotificationsNotification.self, from: data)
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
        notificationID: Int?? = nil,
        title: String?? = nil,
        description: String?? = nil,
        videoLink: String?? = nil,
        dateCreated: String?? = nil,
        image: String?? = nil
        ) -> AlertNotificationsNotification {
        return AlertNotificationsNotification(
            notificationID: notificationID ?? self.notificationID,
            title: title ?? self.title,
            description: description ?? self.description,
            videoLink: videoLink ?? self.videoLink,
            dateCreated: dateCreated ?? self.dateCreated,
            image: image ?? self.image
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
