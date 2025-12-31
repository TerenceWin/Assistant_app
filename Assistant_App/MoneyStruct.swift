//
//  MoneyStruct.swift
//  Assistant_App
//
//  Created by Terence Win on 2025/12/27.
//

import Foundation

struct MoneyStruct{
    let id = UUID()
    let amount: Double
    let date: Date
    let type: String //"earn" or "spend"
    let category: String //salary, food, Unspecify
    let note: String? //Description
}

