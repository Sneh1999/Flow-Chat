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

struct Message: Codable, Hashable {
    var content: String
    var created_at: Date
    var receiver: String
    var sender: String
}

struct ChatInfo: Codable {
    @DocumentID var id: String?
    var primary_user: String
    var secondary_user: String
    var messages: [Message]
}

class FirebaseManager: ObservableObject {
    
    static let shared = FirebaseManager()
    var db: Firestore!
    
    @Published
    var allChats: [ChatInfo] = []
    
    func getMessagesForUser(userAddress: String)  {
        
        let db = Firestore.firestore()
        db.collection("chats").whereField("primary_user", isEqualTo: userAddress).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let hasThisAlready = self.allChats.contains { $0.id == document.documentID }
                    if (!hasThisAlready) {
                        let decodedChatInfo = try? document.data(as: ChatInfo.self)
                        
                        if (decodedChatInfo != nil ) {
                            print(decodedChatInfo!)
                            self.allChats.append(decodedChatInfo!)
                        }
                    }
                }
                
            }
        }
        db.collection("chats").whereField("secondary_user", isEqualTo: userAddress).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let hasThisAlready = self.allChats.contains { $0.id == document.documentID }
                    if (!hasThisAlready) {
                        let decodedChatInfo = try? document.data(as: ChatInfo.self)
                        
                        if (decodedChatInfo != nil ) {
                            self.allChats.append(decodedChatInfo!)
                        }
                    }
                }
            }
        }
    }
    
    func addMessagesToChat(chatId: String, receiver: String, sender: String, content: String) {
        let db = Firestore.firestore()
        let message = Message(content: content, created_at: Date(), receiver: receiver, sender: sender)
        
        let encodedMessage: [String: Any]
        do {
            // encode the swift struct instance into a dictionary
            // using the Firestore encoder
            encodedMessage = try Firestore.Encoder().encode(message)
        } catch {
            // encoding error
            print(error)
            return
        }
        
        
        db.collection("chats").document(chatId).updateData([
            "messages": FieldValue.arrayUnion([encodedMessage])
        ])
    }
    
    
    func createChat(primaryUser: String, secondaryUser: String) -> String {
        var ref: DocumentReference? = nil
        let db = Firestore.firestore()
        
        ref = db.collection("chats").addDocument(data: [
            "primary_user": primaryUser,
            "secondary_user": secondaryUser,
            "messages": []
        ])
        return ref!.documentID
    }
}
