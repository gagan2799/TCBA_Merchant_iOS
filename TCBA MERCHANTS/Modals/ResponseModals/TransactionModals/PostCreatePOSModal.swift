// To parse the JSON, add this file to your project and do:
//
//   let postCreatePOSModel = try PostCreatePOSModel(json)

import Foundation

struct PostCreatePOSModel: Codable {
    let posid, storeID: Int?
    let storeIsPremium: Bool?
    let storeIcon, storeTitle, storeCity: String?
    let memberID: Int?
    let keyChainCode, memberFullName, profileImageURL: String?
    let walletBalance, availableLoyaltyCash, availablePrizeCash, totalServiceFees: Double?
    let totalTransactionFees, totalAmountPaidByMember, totalAmountReceivedByStore, totalPurchaseAmount: Double?
    var balanceRemaining: Double?
    let paidInFull: Bool?
    let transactionID, storeCardID: Int?
    var payments: [PostCreatePOSPayment]?
    let paymentOptions: [PostCreatePOSPaymentOption]?
    
    enum CodingKeys: String, CodingKey {
        case posid, storeID, storeIsPremium, storeIcon, storeTitle, storeCity, memberID, keyChainCode, memberFullName
        case profileImageURL = "profileImageUrl"
        case walletBalance, availableLoyaltyCash, availablePrizeCash, totalServiceFees, totalTransactionFees, totalAmountPaidByMember, totalAmountReceivedByStore, totalPurchaseAmount, balanceRemaining, paidInFull, transactionID, storeCardID, payments, paymentOptions
    }
}

struct PostCreatePOSPaymentOption: Codable {
    let name, type, accountNumber, token: String?
    let serviceFee, transactionFee, amountPaidByMember, amountReceivedByStore: Double?
}

struct PostCreatePOSPayment: Codable {
    let posPaymentID: Int?
    let name, type, accountNumber, token: String?
    let serviceFee, transactionFee, amountPaidByMember, amountReceivedByStore: Double?
    let paid: Bool?
    let uniqueReference: String?
}

// MARK: Convenience initializers and mutators

extension PostCreatePOSModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PostCreatePOSModel.self, from: data)
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
        storeIsPremium: Bool?? = nil,
        storeIcon: String?? = nil,
        storeTitle: String?? = nil,
        storeCity: String?? = nil,
        memberID: Int?? = nil,
        keyChainCode: String?? = nil,
        memberFullName: String?? = nil,
        profileImageURL: String?? = nil,
        walletBalance: Double?? = nil,
        availableLoyaltyCash: Double?? = nil,
        availablePrizeCash: Double?? = nil,
        totalServiceFees: Double?? = nil,
        totalTransactionFees: Double?? = nil,
        totalAmountPaidByMember: Double?? = nil,
        totalAmountReceivedByStore: Double?? = nil,
        totalPurchaseAmount: Double?? = nil,
        balanceRemaining: Double?? = nil,
        paidInFull: Bool?? = nil,
        transactionID: Int?? = nil,
        storeCardID: Int?? = nil,
        payments: [PostCreatePOSPayment]?? = nil,
        paymentOptions: [PostCreatePOSPaymentOption]?? = nil
        ) -> PostCreatePOSModel {
        return PostCreatePOSModel(
            posid: posid ?? self.posid,
            storeID: storeID ?? self.storeID,
            storeIsPremium: storeIsPremium ?? self.storeIsPremium,
            storeIcon: storeIcon ?? self.storeIcon,
            storeTitle: storeTitle ?? self.storeTitle,
            storeCity: storeCity ?? self.storeCity,
            memberID: memberID ?? self.memberID,
            keyChainCode: keyChainCode ?? self.keyChainCode,
            memberFullName: memberFullName ?? self.memberFullName,
            profileImageURL: profileImageURL ?? self.profileImageURL,
            walletBalance: walletBalance ?? self.walletBalance,
            availableLoyaltyCash: availableLoyaltyCash ?? self.availableLoyaltyCash,
            availablePrizeCash: availablePrizeCash ?? self.availablePrizeCash,
            totalServiceFees: totalServiceFees ?? self.totalServiceFees,
            totalTransactionFees: totalTransactionFees ?? self.totalTransactionFees,
            totalAmountPaidByMember: totalAmountPaidByMember ?? self.totalAmountPaidByMember,
            totalAmountReceivedByStore: totalAmountReceivedByStore ?? self.totalAmountReceivedByStore,
            totalPurchaseAmount: totalPurchaseAmount ?? self.totalPurchaseAmount,
            balanceRemaining: balanceRemaining ?? self.balanceRemaining,
            paidInFull: paidInFull ?? self.paidInFull,
            transactionID: transactionID ?? self.transactionID,
            storeCardID: storeCardID ?? self.storeCardID,
            payments: payments ?? self.payments,
            paymentOptions: paymentOptions ?? self.paymentOptions
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension PostCreatePOSPaymentOption {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PostCreatePOSPaymentOption.self, from: data)
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
        name: String?? = nil,
        type: String?? = nil,
        accountNumber: String?? = nil,
        token: String?? = nil,
        serviceFee: Double?? = nil,
        transactionFee: Double?? = nil,
        amountPaidByMember: Double?? = nil,
        amountReceivedByStore: Double?? = nil
        ) -> PostCreatePOSPaymentOption {
        return PostCreatePOSPaymentOption(
            name: name ?? self.name,
            type: type ?? self.type,
            accountNumber: accountNumber ?? self.accountNumber,
            token: token ?? self.token,
            serviceFee: serviceFee ?? self.serviceFee,
            transactionFee: transactionFee ?? self.transactionFee,
            amountPaidByMember: amountPaidByMember ?? self.amountPaidByMember,
            amountReceivedByStore: amountReceivedByStore ?? self.amountReceivedByStore
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension PostCreatePOSPayment {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PostCreatePOSPayment.self, from: data)
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
        posPaymentID: Int?? = nil,
        name: String?? = nil,
        type: String?? = nil,
        accountNumber: String?? = nil,
        token: String?? = nil,
        serviceFee: Double?? = nil,
        transactionFee: Double?? = nil,
        amountPaidByMember: Double?? = nil,
        amountReceivedByStore: Double?? = nil,
        paid: Bool?? = nil,
        uniqueReference: String?? = nil
        ) -> PostCreatePOSPayment {
        return PostCreatePOSPayment(
            posPaymentID: posPaymentID ?? self.posPaymentID,
            name: name ?? self.name,
            type: type ?? self.type,
            accountNumber: accountNumber ?? self.accountNumber,
            token: token ?? self.token,
            serviceFee: serviceFee ?? self.serviceFee,
            transactionFee: transactionFee ?? self.transactionFee,
            amountPaidByMember: amountPaidByMember ?? self.amountPaidByMember,
            amountReceivedByStore: amountReceivedByStore ?? self.amountReceivedByStore,
            paid: paid ?? self.paid,
            uniqueReference: uniqueReference ?? self.uniqueReference
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
