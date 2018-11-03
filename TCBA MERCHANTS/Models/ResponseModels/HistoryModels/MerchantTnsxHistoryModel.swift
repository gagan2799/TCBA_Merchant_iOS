//
//  MerchantTnsxHistoryModel.swift
//  
//
//  Created by varun@gsbitlabs on 03/11/18.
//
// To parse the JSON, add this file to your project and do:
//
//   let merchantTnsxHistoryModel = try MerchantTnsxHistoryModel(json)

import Foundation

struct MerchantTnsxHistoryModel: Codable {
    let success: Bool?
    let message: String?
    let transactionCount: Int?
    let transactionValue, totalDebits, totalCredits: Double?
    let transactions: [MerchantTnsxHistoryTransaction]?
}

struct MerchantTnsxHistoryTransaction: Codable {
    let amount, commission: Double?
    let createDate: String?
    let credits, debits: Double?
    let description: String?
    let net: Double?
    let payments: [MerchantTnsxHistoryPayment]?
    let runningBalance: Double?
    let sortBy: Int?
    let title: String?
    let transactionID: Int?
}

struct MerchantTnsxHistoryPayment: Codable {
    let amount, commission, credits, debits: Double?
    let description: String?
    let sortBy, transactionID: Int?
}

// MARK: Convenience initializers and mutators

extension MerchantTnsxHistoryModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MerchantTnsxHistoryModel.self, from: data)
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
        success: Bool?? = nil,
        message: String?? = nil,
        transactionCount: Int?? = nil,
        transactionValue: Double?? = nil,
        totalDebits: Double?? = nil,
        totalCredits: Double?? = nil,
        transactions: [MerchantTnsxHistoryTransaction]?? = nil
        ) -> MerchantTnsxHistoryModel {
        return MerchantTnsxHistoryModel(
            success: success ?? self.success,
            message: message ?? self.message,
            transactionCount: transactionCount ?? self.transactionCount,
            transactionValue: transactionValue ?? self.transactionValue,
            totalDebits: totalDebits ?? self.totalDebits,
            totalCredits: totalCredits ?? self.totalCredits,
            transactions: transactions ?? self.transactions
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension MerchantTnsxHistoryTransaction {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MerchantTnsxHistoryTransaction.self, from: data)
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
        amount: Double?? = nil,
        commission: Double?? = nil,
        createDate: String?? = nil,
        credits: Double?? = nil,
        debits: Double?? = nil,
        description: String?? = nil,
        net: Double?? = nil,
        payments: [MerchantTnsxHistoryPayment]?? = nil,
        runningBalance: Double?? = nil,
        sortBy: Int?? = nil,
        title: String?? = nil,
        transactionID: Int?? = nil
        ) -> MerchantTnsxHistoryTransaction {
        return MerchantTnsxHistoryTransaction(
            amount: amount ?? self.amount,
            commission: commission ?? self.commission,
            createDate: createDate ?? self.createDate,
            credits: credits ?? self.credits,
            debits: debits ?? self.debits,
            description: description ?? self.description,
            net: net ?? self.net,
            payments: payments ?? self.payments,
            runningBalance: runningBalance ?? self.runningBalance,
            sortBy: sortBy ?? self.sortBy,
            title: title ?? self.title,
            transactionID: transactionID ?? self.transactionID
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension MerchantTnsxHistoryPayment {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MerchantTnsxHistoryPayment.self, from: data)
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
        amount: Double?? = nil,
        commission: Double?? = nil,
        credits: Double?? = nil,
        debits: Double?? = nil,
        description: String?? = nil,
        sortBy: Int?? = nil,
        transactionID: Int?? = nil
        ) -> MerchantTnsxHistoryPayment {
        return MerchantTnsxHistoryPayment(
            amount: amount ?? self.amount,
            commission: commission ?? self.commission,
            credits: credits ?? self.credits,
            debits: debits ?? self.debits,
            description: description ?? self.description,
            sortBy: sortBy ?? self.sortBy,
            transactionID: transactionID ?? self.transactionID
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
