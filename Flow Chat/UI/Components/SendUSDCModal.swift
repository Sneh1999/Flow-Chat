//
//  SendUSDCModal.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-28.
//

import SwiftUI
import Flow

struct SendUSDCModal: View {
    
    @State var chatId: String
    @State var recipient: String
    @State var usdcAmount: String = "0"
    @State var showErrorAlert: Bool = false
    @FocusState private var usdcAmountIsFocused: Bool
    @State var avatar: String = ""
    
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
                Image("usdcLogo")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                TextField("0", text: $usdcAmount)
                    .focused($usdcAmountIsFocused)
                    .font(.system(.largeTitle, design: .default, weight: .bold))
                    .frame(width: 50)
                    .keyboardType(.numberPad)
            }
            
            Spacer()
            
            Button("Send") {
                sendUSDC()
            }
            .frame(height: 75)
            .font(.system(.largeTitle, weight: .bold))
            .foregroundColor(.black)
            .padding([.leading, .trailing], 50)
            .background(Color(red: 39/255, green: 116/255, blue: 202/255))
            .cornerRadius(10)
        }
        .alert("Sender or Recipient does not have USDC vault.", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
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
    
    func sendUSDC() {
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
        
        let amount = Decimal(string: self.usdcAmount) ?? 0
        if (amount == 0) {
            return
        }
        
        FlowManager.shared.transferUSDC(amount: amount, recipient: Flow.Address(hex: receiver), showError: $showErrorAlert)
        
        
        if (!showErrorAlert) {
            FirebaseManager.shared.addMessagesToChat(chatId: self.chatId, receiver: receiver, receiverFlown: receiverFlown, sender: FlowManager.shared.userAddress!, senderFlown: senderFlown.isEmpty ? "" : senderFlown[0].name, content: "USDC Transfer \(self.usdcAmount)")
        }
        
        
        
    }
}

struct SendUSDCModal_Previews: PreviewProvider {
    static var previews: some View {
        SendUSDCModal(chatId: "abcdef", recipient: "snoopies.fn")
    }
}
