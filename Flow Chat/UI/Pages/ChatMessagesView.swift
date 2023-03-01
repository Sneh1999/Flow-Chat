//
//  ChatMessagesView.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-25.
//

import SwiftUI
import Flow
import UIKit


struct Profile: Decodable {
    let avatar: String
}


struct ChatMessagesView: View {
    
    @ObservedObject var firebase = FirebaseManager.shared
    @Binding var chatId: String
    @Binding var recipient: String
    @Binding var message: String
    @FocusState var messageIsFocused: Bool
    
    @State var showSendFlowModal: Bool = false
    @State var avatar: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ScrollViewReader { value in
                        VStack {
                            Spacer()
                            if ( firebase.allChats.first(where: {$0.id == chatId}) != nil)  {
                                
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
                }
                
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(Color(red: 39/255, green: 116/255, blue: 202/255))
                        .font(.system(size: 25))
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
                            message = ""
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
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(self.recipient).fontWeight(.bold)
                        Spacer()
                        
                        AsyncImage(url:  URL(string: getAvatar(recipient: self.recipient))) { image in
                            image.resizable()
                        }
                            placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                }
            }
        }
        
    }
    
    func getAvatar(recipient: String) -> String {
        // if the user sent a flown name, get the owner address
        if recipient.hasSuffix(".fn") {
            let flown = FlownManager.shared.getAddressFromFlown(flownName: recipient)
            
            if (flown.texts.profile != nil) {
                let jsonData = flown.texts.profile!.data(using: .utf8)!
                if let profile = try? JSONDecoder().decode(Profile.self, from: jsonData) {
                    print("avatar")
                    avatar = profile.avatar
                    return profile.avatar
                } else {
                    print("Invalid Response")
                    avatar = "https://avatar.vercel.sh/" + recipient
                    return "https://avatar.vercel.sh/" + recipient
                }
            }
            
        } else {
            let flowns =   FlownManager.shared.getFlownFromAddress(userAddress: recipient)
            if !flowns.isEmpty  {
                let texts = flowns[0].texts
                if (texts.profile != nil) {
                    let jsonData = texts.profile!.data(using: .utf8)!
                    if let profile = try? JSONDecoder().decode(Profile.self, from: jsonData) {
                        avatar = profile.avatar
                        return profile.avatar
                        
                    } else {
                        print("Invalid Response")
                        return "https://avatar.vercel.sh/" + recipient
                    }
                }
            }
        }
        avatar = "https://avatar.vercel.sh/" + recipient
        return "https://avatar.vercel.sh/" + recipient
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
    }
}

struct ChatMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesView(
            chatId: .constant("Rn4An4tRVyiiiubtidFO"),
            recipient: .constant("0xabcdef"),
            message: .constant("")
        )
    }
}
