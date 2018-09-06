// To parse the JSON, add this file to your project and do:
//
//   let transactionDetailsModel = try TransactionDetailsModel(json)

import Foundation

struct TransactionDetailsModel: Codable {
    let transactions: [TransactionDetailsTransaction]?
}

struct TransactionDetailsTransaction: Codable {
    let customerName: String?
    let customerUserID: Int?
    let transactionDate: String?
    let storeID: Int?
    let storeTitle: String?
    let transactionAmount: Double?
    let transactionID, staffID: Int?
    let staffMemberName: String?
    let payments: [TransactionDetailsPayment]?
    
    enum CodingKeys: String, CodingKey {
        case customerName
        case customerUserID = "customerUserId"
        case transactionDate
        case storeID = "storeId"
        case storeTitle, transactionAmount
        case transactionID = "transactionId"
        case staffID = "staffId"
        case staffMemberName, payments
    }
}

struct TransactionDetailsPayment: Codable {
    let type: String?
    let amount: Double?
}

// MARK: Convenience initializers and mutators

extension TransactionDetailsModel {
    init(data: Data) throws {
        self = try JSONDecoder().decode(TransactionDetailsModel.self, from: data)
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
        transactions: [TransactionDetailsTransaction]?? = nil
        ) -> TransactionDetailsModel {
        return TransactionDetailsModel(
            transactions: transactions ?? self.transactions
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension TransactionDetailsTransaction {
    init(data: Data) throws {
        self = try JSONDecoder().decode(TransactionDetailsTransaction.self, from: data)
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
        customerName: String?? = nil,
        customerUserID: Int?? = nil,
        transactionDate: String?? = nil,
        storeID: Int?? = nil,
        storeTitle: String?? = nil,
        transactionAmount: Double?? = nil,
        transactionID: Int?? = nil,
        staffID: Int?? = nil,
        staffMemberName: String?? = nil,
        payments: [TransactionDetailsPayment]?? = nil
        ) -> TransactionDetailsTransaction {
        return TransactionDetailsTransaction(
            customerName: customerName ?? self.customerName,
            customerUserID: customerUserID ?? self.customerUserID,
            transactionDate: transactionDate ?? self.transactionDate,
            storeID: storeID ?? self.storeID,
            storeTitle: storeTitle ?? self.storeTitle,
            transactionAmount: transactionAmount ?? self.transactionAmount,
            transactionID: transactionID ?? self.transactionID,
            staffID: staffID ?? self.staffID,
            staffMemberName: staffMemberName ?? self.staffMemberName,
            payments: payments ?? self.payments
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension TransactionDetailsPayment {
    init(data: Data) throws {
        self = try JSONDecoder().decode(TransactionDetailsPayment.self, from: data)
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
        type: String?? = nil,
        amount: Double?? = nil
        ) -> TransactionDetailsPayment {
        return TransactionDetailsPayment(
            type: type ?? self.type,
            amount: amount ?? self.amount
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
