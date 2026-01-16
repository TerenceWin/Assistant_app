//
//  MoneyStruct.swift
//  Assistant_App
//
//  Created by Terence Win on 2025/12/27.
//

import Foundation
import FirebaseFirestore

struct MoneyStruct: Codable{
    @DocumentID var id: String?
    var amount: Int
    var date: Date
    var type: String //"earn" or "spend"
    var category: String //salary, food, Unspecify
    var note: String? //Description
}

struct WeeklyKey: Hashable, Codable{
    let year: Int
    let month: Int
    let day: Int
    let hour: Int
}

struct K{
    static let collectionName = "transaction"
    static let transactionID = "id"
    static let transactionamount = "amount"
    static let transactionDate = "date"
    static let transactionType = "type"
    static let transactionCategory = "category"
    static let transactionNote = "note"
}
