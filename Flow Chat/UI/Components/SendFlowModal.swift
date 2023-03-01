//
//  SendFlowModal.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-27.
//

import SwiftUI
import Flow

struct SendFlowModal: View {
    
    @State var chatId: String
    @State var recipient: String
    @State var flowAmount: String = "0"
    @State var avatar: String = ""
    @FocusState private var flowAmountIsFocused: Bool
    
    var body: some View {
        VStack {
            AsyncImage(url:  URL(string: getAvatar(recipient: self.recipient))) { image in
                image.resizable()
            }
        placeholder: {
            ProgressView()
        }
        .frame(width: 100, height: 100)
        .clipShape(Circle())
            
            Text(self.recipient)
            
            Spacer()
            
            HStack {
                Image("flowLogo")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                TextField("0", text: $flowAmount)
                    .focused($flowAmountIsFocused)
                    .font(.system(.largeTitle, design: .default, weight: .bold))
                    .frame(width: 50)
                    .keyboardType(.numberPad)
            }
            
            Spacer()
            
            Button("Send") {
                sendFlow()
            }
            .frame(height: 75)
            .font(.system(.largeTitle, weight: .bold))
            .foregroundColor(.black)
            .padding([.leading, .trailing], 50)
            .background(Color(red: 0, green: 239/255, blue: 139/255))
            .cornerRadius(10)
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
    
    func sendFlow() {
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
            print(flowns)
            receiverFlown = flowns.isEmpty ? "": flowns[0].name
        }
        
        let senderFlown =  FlownManager.shared.getFlownFromAddress(userAddress: FlowManager.shared.userAddress!)
        
        let amount = Decimal(string: self.flowAmount) ?? 0
        if (amount == 0) {
            return
        }
        
        FlowManager.shared.transferFlow(amount: amount, recipient: Flow.Address(hex: receiver))
        
        FirebaseManager.shared.addMessagesToChat(chatId: self.chatId, receiver: receiver, receiverFlown: receiverFlown, sender: FlowManager.shared.userAddress!, senderFlown: senderFlown.isEmpty ? "" : senderFlown[0].name, content: "FLOW Transfer \(self.flowAmount)")
    }
}

struct SendFlowModal_Previews: PreviewProvider {
    static var previews: some View {
        SendFlowModal(chatId: "abcdef", recipient: "snoopies.fn")
    }
}
