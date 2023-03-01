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
            .background(.thinMaterial)
            
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
    
    func sendMessage()  {
        var receiver: String = ""
        var receiverFlown: String = ""
        // if the user sent a flown name, get the owner address
        if self.sheetRecipient.hasSuffix(".fn") {
            let flown = FlownManager.shared.getAddressFromFlown(flownName: self.sheetRecipient)
            receiver = flown.owner
            receiverFlown = self.sheetRecipient
        } else {
            receiver = self.sheetRecipient
            let flowns =  FlownManager.shared.getFlownFromAddress(userAddress: self.sheetRecipient)
            print(flowns)
            receiverFlown = flowns.isEmpty ? "": flowns[0].name
        }
        let chatId = FirebaseManager.shared.createChat(primaryUser: FlowManager.shared.userAddress!, secondaryUser: receiver)

        let senderFlown =  FlownManager.shared.getFlownFromAddress(userAddress: FlowManager.shared.userAddress!)
        
        FirebaseManager.shared.addMessagesToChat(
            chatId: chatId,
            receiver: receiver,
            receiverFlown: receiverFlown ,
            sender: FlowManager.shared.userAddress!,
            senderFlown: senderFlown.isEmpty ? "" : senderFlown[0].name,
            content: self.sheetMessage
        )
        
        self.sheetChatID = chatId
        self.sheetRecipient = receiverFlown != "" ? receiverFlown : receiver
        print("rrecep")
        print(self.sheetRecipient)
        self.sheetMessage = ""
        self.sendNewMessageModalShowing.toggle()
        self.showChatView.toggle()
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
