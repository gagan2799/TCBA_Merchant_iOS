// To parse the JSON, add this file to your project and do:
//
//   let incompleteTransactionDataModel = try IncompleteTransactionDataModel(json)

import Foundation

typealias IncompleteTransactionDataModel = [IncompleteTransactionDataModelElement]

struct IncompleteTransactionDataModelElement: Codable {
    let posid, storeID, memberID: Int?
    let keyChainCode, memberFullName: String?
    let totalPurchaseAmount, totalPaymentsAdded, balanceRemaining: Double?
}

// MARK: Convenience initializers and mutators

extension IncompleteTransactionDataModelElement {
    init(data: Data) throws {
        self = try JSONDecoder().decode(IncompleteTransactionDataModelElement.self, from: data)
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
        posid: Int?? = nil,
        storeID: Int?? = nil,
        memberID: Int?? = nil,
        keyChainCode: String?? = nil,
        memberFullName: String?? = nil,
        totalPurchaseAmount: Double?? = nil,
        totalPaymentsAdded: Double?? = nil,
        balanceRemaining: Double?? = nil
        ) -> IncompleteTransactionDataModelElement {
        return IncompleteTransactionDataModelElement(
            posid: posid ?? self.posid,
            storeID: storeID ?? self.storeID,
            memberID: memberID ?? self.memberID,
            keyChainCode: keyChainCode ?? self.keyChainCode,
            memberFullName: memberFullName ?? self.memberFullName,
            totalPurchaseAmount: totalPurchaseAmount ?? self.totalPurchaseAmount,
            totalPaymentsAdded: totalPaymentsAdded ?? self.totalPaymentsAdded,
            balanceRemaining: balanceRemaining ?? self.balanceRemaining
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Array where Element == IncompleteTransactionDataModel.Element {
    init(data: Data) throws {
        self = try JSONDecoder().decode(IncompleteTransactionDataModel.self, from: data)
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
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
