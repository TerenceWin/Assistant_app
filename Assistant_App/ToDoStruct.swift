//
//  toDoStruct.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/02/16.
//

import FirebaseFirestore
import Foundation

struct ToDoStruct: Codable{
    @DocumentID var id: String?
    var title: String
    var description: String?
    var date: Date
    var category: String //"Personal", "Work", "School", "Home", "Relationship", "Family", "Finance", "Health"
    var location: String //"Zoom", "Current Location", "Others"
}

struct L{
    static let collectionName = "todo"
    static let toDoID = "id"
    static let toDotitle = "title"
    static let toDoDescription = "description"
    static let toDoDate = "date"
    static let toDoCategory = "category"
    static let toDoLocation = "Location"
    
}


