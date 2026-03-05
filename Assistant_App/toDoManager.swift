//
//  toDoManager.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/02/16.
//

import Foundation
import FirebaseFirestore

class toDoManager{
    static let shared = toDoManager()
    private let db = Firestore.firestore()
    
    private(set) var allToDo : [ToDoStruct] = []
    private init(){}
    
    func loadData(completion: (() -> Void)? = nil) {
        fetchToDo{[weak self] fetchToDos in
            self?.allToDo = fetchToDos
            completion?()
        }
    }
    
    func fetchToDo(completion: @escaping ([ToDoStruct]) -> Void) {
        allToDo = []
        db.collection(L.collectionName).getDocuments{ (snapshot, error) in
            guard let queryDocuments = snapshot?.documents else {return}
            let todos = queryDocuments.compactMap{
                try? $0.data(as: ToDoStruct.self)
            }
            completion(todos)
        }
    }
    
    func addToDo(_ todo: ToDoStruct, completion: @escaping(Bool) -> Void){
        let id = todo.id ?? UUID().uuidString
        
        do{
            try db.collection(L.collectionName).document(id).setData(from: todo){ error in
                if let e = error{
                    print("The was an error while saving your data: \(e)")
                    completion(false)
                }else{
                    print("Successfully saved")
                    completion(true)
                }
            }
        }catch{
            completion(false)
        }
    }
    
    func editToDo(){
        
    }
    
    func deleteToDo(){
        
    }
    
    func printAllToDo(){
        
    }
}
