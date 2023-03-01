//
//  ChatMessagesView.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-25.
//

import SwiftUI
import Flow
import UIKit

struct ChatMessagesView: View {
    
    @ObservedObject var firebase = FirebaseManager.shared
    @State var chatId: String
    @State var recipient: String
    @State var message: String = ""
    @FocusState var messageIsFocused: Bool
    
    @State var showSendFlowModal: Bool = false
    @State var showSendUSDCModal: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ScrollViewReader { value in
                    VStack {
                        Spacer()
                        let chat = firebase.allChats.first(where: {$0.id == chatId})
                        if (chat != nil)  {
                            let chatMessages = chat!.messages
                            ForEach(chatMessages, id: \.hashValue) { message in
                                ChatMessagesList(message: message)
                                    .onChange(of: chatMessages.count) { _ in
                                        value.scrollTo(chatMessages.last?.hashValue)
                                    }
                            }
                        }
                    }
                }
            }
            
            HStack {
                Button {
                    showSendUSDCModal.toggle()
                } label: {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(Color(red: 39/255, green: 116/255, blue: 202/255))
                        .font(.system(size: 25))
                }
                
                Button {
                    showSendFlowModal.toggle()
                } label: {
                    Image(systemName: "florinsign.circle.fill")
                        .foregroundColor(Color(red: 0, green: 239/255, blue: 139/255))
                        .font(.system(size: 25))
                }
                
                HStack {
                    Spacer()
                    
                    TextField("What's on your mind?", text: $message)
                        .frame(maxWidth: .infinity)
                        .focused($messageIsFocused)
                    
                    Button(action: {
                        sendMessage()
                        messageIsFocused.toggle()
                        
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 25))
                    }
                    
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2).foregroundColor(Color(red: 52/255, green: 54/255, blue: 53/255)))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            .sheet(isPresented: $showSendFlowModal) {
                SendFlowModal(chatId: chatId, recipient: recipient)
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $showSendUSDCModal) {
                SendUSDCModal(chatId: chatId, recipient: recipient)
                    .presentationDetents([.medium])
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(self.recipient).fontWeight(.bold)
                    Spacer()
                    AsyncImage(url: URL(string: FlownManager.shared.getAvatar(recipient: self.recipient)))
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
            }
        }
    }
    
    
    
    func sendMessage() {
        if (self.message.isEmpty) {
            return
        }
        
        var receiver: String = ""
        var receiverFlown: String = ""
        // if the user sent a flown name, get the owner address
        if self.recipient.hasSuffix(".fn") {
            let flown = FlownManager.shared.getAddressFromFlown(flownName: self.recipient)
            receiver = flown.owner
            receiverFlown = self.recipient
        } else {
            receiver = self.recipient
            let flowns =  FlownManager.shared.getFlownFromAddress(userAddress: self.recipient)
            receiverFlown = flowns.isEmpty ? "": flowns[0].name
        }
        let senderFlown = FlownManager.shared.getFlownFromAddress(userAddress: FlowManager.shared.userAddress!)
        FirebaseManager.shared.addMessagesToChat(
            chatId: chatId,
            receiver: receiver,
            receiverFlown: receiverFlown,
            sender: FlowManager.shared.userAddress!,
            senderFlown: senderFlown.isEmpty ? "" : senderFlown[0].name,
            content: self.message
        )
        
        self.message = ""
    }
    
}

struct ChatMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesView(
            chatId: "Rn4An4tRVyiiiubtidFO",
            recipient: "0xabcdef",
            message: ""
        )
    }
}
