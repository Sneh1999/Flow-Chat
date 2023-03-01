//
//  ChatsView.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-20.
//

import SwiftUI
import FCL
import Flow

struct ChatsView: View {
    
    @ObservedObject var firebase = FirebaseManager.shared
    @State var sendNewMessageModalShowing = false
    @State var showChatView = false
    @State var sheetChatID: String
    @State var sheetRecipient: String
    @State var sheetMessage: String
    @State var sheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(firebase.allChats, id: \.self.id!) { chat in
                    
                    NavigationLink {
                        ChatMessagesView(
                            chatId: chat.id!, recipient:
                                    getRecipient(chat: chat), message: ""
                        )
                    } label: {
                        ChatListItem(chat: chat)
                    }
                    
                }
            }
            .listStyle(.inset)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Chats")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        sendNewMessageModalShowing.toggle()
                    }
                    ) {
                        Image(systemName: "square.and.pencil")
                    }
                    .sheet(isPresented: $sendNewMessageModalShowing, content: {
                        SendNewMessage(
                            sheetChatID: $sheetChatID,
                            sheetRecipient: $sheetRecipient,
                            sheetMessage: $sheetMessage,
                            showChatView: $showChatView,
                            sendNewMessageModalShowing: $sendNewMessageModalShowing
                        )
                        .presentationDetents([.large])
                    })
                    .navigationDestination(isPresented: $showChatView) {
                        ChatMessagesView(chatId: sheetChatID, recipient: sheetRecipient)
                    }
                }
            }
        }
        .onAppear {
            
            if (FlowManager.shared.userAddress != nil) {
                FirebaseManager.shared.getMessagesForUser(userAddress: FlowManager.shared.userAddress!)
            }
            
        }
        
    }
    
    func getRecipient(chat: ChatInfo) -> String {
        let message = chat.messages[0]
        let result: String
        if(message.receiver == FlowManager.shared.userAddress!) {
            if (message.senderFlown != "") {
                result = message.senderFlown
            } else {
                result = message.sender
            }
        } else {
            if (message.receiverFlown != "") {
                result = message.receiverFlown
            } else {
                result = message.receiver
            }
        }
        return result
    }
    
    func createChat(recipient: String) {
        guard let myAddress = fcl.currentUser?.addr.description else {
            print(FCLError.unauthenticated.localizedDescription)
            return
        }
        
        let id = FirebaseManager.shared.createChat(primaryUser: myAddress, secondaryUser: recipient)
        print(id)
    }
    
    func getBalance() {
        guard let myAddress = fcl.currentUser?.addr else {
            print(FCLError.unauthenticated.localizedDescription)
            return
        }
        FlowManager.shared.getBalance(address: myAddress)
    }
    
    func getUSDCBalance() {
        guard let myAddress = fcl.currentUser?.addr else {
            print(FCLError.unauthenticated.localizedDescription)
            return
        }
        FlowManager.shared.getUSDCBalance(address: myAddress)
    }
    
    func transferFlow(amount: Decimal) {
        guard let myAddress = fcl.currentUser?.addr else {
            print(FCLError.unauthenticated.localizedDescription)
            return
        }
        FlowManager.shared.transferFlow(amount: amount, recipient: myAddress)
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView(sheetChatID: "", sheetRecipient: "", sheetMessage:"")
    }
}
