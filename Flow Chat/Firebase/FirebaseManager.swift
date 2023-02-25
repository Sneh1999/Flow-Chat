//
//  FirebaseManager.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager: ObservableObject {
    
    static let shared = FirebaseManager()
    var db: Firestore!
    
    @Published
    var allChats: [DocumentSnapshot] = []
    
    func getMessagesForUser(userAddress: String)  {

        let db = Firestore.firestore()
        db.collection("chats").whereField("primary_user", isEqualTo: userAddress).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let documentId = document.documentID
                    let hasThisAlready = self.allChats.contains { $0.documentID == documentId }
                    if (!hasThisAlready) {
                        self.allChats.append(document)
                    }
                }
                
            }
        }
        db.collection("chats").whereField("secondary_user", isEqualTo: userAddress).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let documentId = document.documentID
                    let hasThisAlready = self.allChats.contains { $0.documentID == documentId }
                    if (!hasThisAlready) {
                        self.allChats.append(document)
                    }
                }
            }
        }
        print(self.allChats.count)
    }
    
    func addMessagesToChat(chatId: String, reciever: String, sender: String, content: String) {
        let db = Firestore.firestore()
        db.collection("chats").document(chatId).collection("messages").addDocument(data: [
            "reciever": reciever,
            "sender": sender,
            "content": content,
            "created_at": Date()
        ])
    }
    
    
    func createChat(primaryUser: String, secondaryUser: String) -> String {
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()

        ref = db.collection("chats").addDocument(data: [
            "primary_user": primaryUser,
            "secondary_user": secondaryUser
        ])
        return ref!.documentID
    }
}
