// To parse the JSON, add this file to your project and do:
//
//   let transactionDataModel = try TransactionDataModel(json)

import Foundation

struct TransactionDataModel: Codable {
    let tonightAmount, totalTransaction, totalAmount, totalCashBack: Double?
    let todayTransaction, todayAmount, todayCashBack, outstandingLoyalty: Double?
}

// MARK: Convenience initializers and mutators

extension TransactionDataModel {
    init(data: Data) throws {
        self = try JSONDecoder().decode(TransactionDataModel.self, from: data)
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
        tonightAmount: Double?? = nil,
        totalTransaction: Double?? = nil,
        totalAmount: Double?? = nil,
        totalCashBack: Double?? = nil,
        todayTransaction: Double?? = nil,
        todayAmount: Double?? = nil,
        todayCashBack: Double?? = nil,
        outstandingLoyalty: Double?? = nil
        ) -> TransactionDataModel {
        return TransactionDataModel(
            tonightAmount: tonightAmount ?? self.tonightAmount,
            totalTransaction: totalTransaction ?? self.totalTransaction,
            totalAmount: totalAmount ?? self.totalAmount,
            totalCashBack: totalCashBack ?? self.totalCashBack,
            todayTransaction: todayTransaction ?? self.todayTransaction,
            todayAmount: todayAmount ?? self.todayAmount,
            todayCashBack: todayCashBack ?? self.todayCashBack,
            outstandingLoyalty: outstandingLoyalty ?? self.outstandingLoyalty
        )
    }
    
    func jsonData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
