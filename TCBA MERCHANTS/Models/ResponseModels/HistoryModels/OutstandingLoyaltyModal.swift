// To parse the JSON, add this file to your project and do:
//
//   let outstandingLoyaltyModel = try OutstandingLoyaltyModel(json)

import Foundation

struct OutstandingLoyaltyModel: Codable {
    let outstandingLoyalty: [OutstandingLoyalty]?
    let totalNumber: Int?
    let totalOutstanding: Double?
}

struct OutstandingLoyalty: Codable {
    let id: Int?
    let name: String?
    let available: Double?
}

// MARK: Convenience initializers and mutators

extension OutstandingLoyaltyModel {
    init(data: Data) throws {
        self = try JSONDecoder().decode(OutstandingLoyaltyModel.self, from: data)
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
        outstandingLoyalty: [OutstandingLoyalty]?? = nil,
        totalNumber: Int?? = nil,
        totalOutstanding: Double?? = nil
        ) -> OutstandingLoyaltyModel {
        return OutstandingLoyaltyModel(
            outstandingLoyalty: outstandingLoyalty ?? self.outstandingLoyalty,
            totalNumber: totalNumber ?? self.totalNumber,
            totalOutstanding: totalOutstanding ?? self.totalOutstanding
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension OutstandingLoyalty {
    init(data: Data) throws {
        self = try JSONDecoder().decode(OutstandingLoyalty.self, from: data)
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
        id: Int?? = nil,
        name: String?? = nil,
        available: Double?? = nil
        ) -> OutstandingLoyalty {
        return OutstandingLoyalty(
            id: id ?? self.id,
            name: name ?? self.name,
            available: available ?? self.available
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
