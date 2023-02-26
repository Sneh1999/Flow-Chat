//
//  ChatMessagesView.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-25.
//

import SwiftUI

struct ChatMessagesView: View {
    
    @State var chatId: String
    @State var recipient: String
    @State var message: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ChatBubble(direction: .left) {
                    Text("Hello!")
                        .padding(.all, 20)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                }
                .padding(.horizontal, 20)
                ChatBubble(direction: .right) {
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse ut semper quam. Phasellus non mauris sem. Donec sed fermentum eros. Donec pretium nec turpis a semper. ")
                        .padding(.all, 20)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
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
                        Button(action: {
                            sendMessage()
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
        FirebaseManager.shared.addMessagesToChat(
            chatId: self.chatId,
            receiver: self.recipient,
            sender: FlowManager.shared.userAddress!,
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
