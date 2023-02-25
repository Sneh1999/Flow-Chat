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
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(firebase.allChats, id: \.self.documentID) { chat in
                    ChatListItem()
                }
            }
            .listStyle(.inset)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Chats")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
//                        createChat(recipient: "0xabcdef")
                        sendNewMessageModalShowing.toggle()
                    }
                    ) {
                        Image(systemName: "square.and.pencil")
                    }
                    .sheet(isPresented: $sendNewMessageModalShowing) {
                        SendNewMessage()
                            .presentationDetents([.large])
                    }
                }
            }
        }
        .onAppear {
            if (FlowManager.shared.userAddress != nil) {
                FirebaseManager.shared.getMessagesForUser(userAddress: FlowManager.shared.userAddress!)
            }
            
        }
        
        Button {
            getBalance()
        } label: {
            Text("Get Balance of a address")
        }.padding()
        
        Button {
            transferFlow(amount: 10)
        } label: {
            Text("Transfer Flow")
        }.padding()
        
        Button {
            getUSDCBalance()
        } label: {
            Text("Get USDC balance")
        }.padding()
        
        Button {
            getAddressFromFlown(flown: "snoopies.fn")
        } label: {
            Text("Get Address from Flown")
        }.padding()
        
        Button {
            getFlownFromAddress()
        } label: {
            Text("Get Flown From Address")
        }.padding()
        
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
        FlownManager.shared.getAddressFromFlow(flownName: flown)
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
        ChatsView()
    }
}
