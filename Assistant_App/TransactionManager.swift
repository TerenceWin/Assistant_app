//
//  TransactionManager.swift
//  Assistant_App
//
//  Created by Terence Win on 2026/01/08.
//

import UIKit
import Foundation
import FirebaseFirestore

class TransactionManager{
    static let shared = TransactionManager()
    private let db = Firestore.firestore()
    
    private(set) var allTransactions : [MoneyStruct] = []
    private init(){}
    
    func loadData(completion: (() -> Void)? = nil){
        fetchTransaction{[weak self] fetchedList in
            self?.allTransactions = fetchedList
            completion?()
        }
    }
   
    
    func fetchTransaction(completion: @escaping ([MoneyStruct]) -> Void){
        db.collection(K.collectionName).getDocuments{ (snapshot, error) in
            guard let documents = snapshot?.documents else{
                return
            }
            let transactions = documents.compactMap{
                try? $0.data(as: MoneyStruct.self)
            }
            completion(transactions)
        }
    }
    
    func addTransaction(_ transaction: MoneyStruct, completion: @escaping(Bool) -> Void){
        let id = transaction.id ?? UUID().uuidString
        
        do{
            try db.collection(K.collectionName).document(id).setData(from: transaction) {error in
                if let e = error{
                    print("There was an issue saving data to firebase. \(e)")
                    completion(false)
                }else{
                    print("Successfully saved data.")
                    completion(true)
                }
            }
        }catch{
            completion(false)
        }
    }
    
    func editTransaction(_ transaction: MoneyStruct, completion: @escaping(Bool) -> Void){
        guard !transaction.id!.isEmpty else{
            print("Id is empty. ")
            completion(false)
            return
        }
        
        do{
            try db.collection(K.collectionName).document(transaction.id!).setData(from: transaction)
            
            if let index = self.allTransactions.firstIndex(where: {$0.id == transaction.id}) {
                self.allTransactions[index] = transaction
            }
            completion(true)
        }catch let error{
            print("Error editing the transaction: \(error)")
            completion(false)
        }
    }

    
    func printAllTransactions(){
        print(allTransactions)
    }
}
