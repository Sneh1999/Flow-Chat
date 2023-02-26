//
//  SendNewMessage.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-24.
//

import SwiftUI

struct SendNewMessage: View {
    
    @Binding var sheetChatID: String
    @Binding var sheetRecipient: String
    @Binding var sheetMessage: String
    @Binding var showChatView: Bool
    @Binding var sendNewMessageModalShowing: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("New Message")
                    .fontWeight(.bold)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color(red: 52/255, green: 54/255, blue: 53/255))
            
            HStack {
                Text("To: ")
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                TextField("0x0", text: $sheetRecipient)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            
            Divider()
             .frame(height: 1)
            
            Spacer()

            HStack {
                
                HStack {
                    TextField("What's on your mind?", text: $sheetMessage)
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
    }
    
    func sendMessage() {
        let chatId = FirebaseManager.shared.createChat(primaryUser: FlowManager.shared.userAddress!, secondaryUser: self.sheetRecipient)
        let recieverFlown = FlownManager.shared.getFlownFromAddress(userAddress: self.sheetRecipient)
        let senderFlown = FlownManager.shared.getFlownFromAddress(userAddress: FlowManager.shared.userAddress!)
        FirebaseManager.shared.addMessagesToChat(
            chatId: chatId,
            receiver: self.sheetRecipient,
            receiverFlown: recieverFlown.isEmpty ? "" : recieverFlown[0].name ,
            sender: FlowManager.shared.userAddress!,
            senderFlown: senderFlown.isEmpty ? "" : senderFlown[0].name,
            content: self.sheetMessage
        )
        
        self.sheetChatID = chatId
        self.sheetRecipient = recieverFlown.isEmpty ? "" : recieverFlown[0].name
        self.showChatView.toggle()
        self.sendNewMessageModalShowing.toggle()
    }
}

struct SendNewMessage_Previews: PreviewProvider {
    static var previews: some View {
        SendNewMessage(
            sheetChatID: .constant(""),
            sheetRecipient: .constant(""),
            sheetMessage: .constant(""),
            showChatView: .constant(false),
            sendNewMessageModalShowing: .constant(true)
        )
    }
}
