//
//  ChatMessagesView.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-25.
//

import SwiftUI
import Flow


struct ChatMessagesView: View {
    
    @ObservedObject var firebase = FirebaseManager.shared
    @State var chatId: String
    @State var recipient: String
    @State var message: String = ""
    @FocusState var messageIsFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ScrollViewReader { value in
                        VStack {
                            Spacer()
                            ForEach(firebase.allChats.first(where: {$0.id == chatId})!.messages, id: \.hashValue) { message in
                                if message.receiver == FlowManager.shared.userAddress! {
                                    ChatBubble(direction: .left) {
                                        Text(message.content)
                                            .padding([.leading, .trailing], 20)
                                            .padding([.top, .bottom], 15)
                                            .foregroundColor(Color.white)
                                            .background(Color.green)
                                    }
                                    .padding(.horizontal, 20)
                                } else {
                                    ChatBubble(direction: .right) {
                                        Text(message.content)
                                            .padding([.leading, .trailing], 20)
                                            .padding([.top, .bottom], 15)
                                            .foregroundColor(Color.white)
                                            .background(Color.blue)
                                    }
                                }
                            }
                            .onChange(of: firebase.allChats.first(where: {$0.id == chatId})!.messages.count) { _ in
                                value.scrollTo(firebase.allChats.first(where: {$0.id == chatId})!.messages.last?.hashValue)
                            }
                            
                        }
                    }
                }
                
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(Color(red: 39/255, green: 116/255, blue: 202/255))
                        .font(.system(size: 25))
                    Image(systemName: "florinsign.circle.fill")
                        .foregroundColor(Color(red: 0, green: 239/255, blue: 139/255))
                        .font(.system(size: 25))
                    
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
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(self.recipient).fontWeight(.bold)
                        Spacer()
                        Image("profile")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                }
            }
        }
        
    }
    
    func sendMessage() {
        let recieverFlown = FlownManager.shared.getFlownFromAddress(userAddress: self.recipient)
        let senderFlown = FlownManager.shared.getFlownFromAddress(userAddress: FlowManager.shared.userAddress!)
        FirebaseManager.shared.addMessagesToChat(
            chatId: chatId,
            receiver: self.recipient,
            receiverFlown: recieverFlown.isEmpty ? "" : recieverFlown[0].name,
            sender: FlowManager.shared.userAddress!,
            senderFlown: senderFlown.isEmpty ? "" : senderFlown[0].name,
            content: self.message
        )
    }
}

struct ChatMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesView(
            chatId: "Rn4An4tRVyiiiubtidFO",
            recipient: "0xabcdef"
        )
    }
}
