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
                            chatId: chat.id!, recipient: FlowManager.shared.userAddress == chat.primary_user ? chat.secondary_user : chat.primary_user
                        )
                    } label: {
                        ChatListItem()
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
                        ChatMessagesView(chatId: self.sheetChatID, recipient: self.sheetRecipient, message: self.sheetMessage)
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
    
    func getFlownFromAddress() {
        guard let myAddress = fcl.currentUser?.addr.description else {
            print(FCLError.unauthenticated.localizedDescription)
            return
        }
        FlownManager.shared.getFlownFromAddress(userAddress: myAddress)
    }
    
    func getAddressFromFlown(flown: String) {
        FlownManager.shared.getAddressFromFlown(flownName: flown)
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
