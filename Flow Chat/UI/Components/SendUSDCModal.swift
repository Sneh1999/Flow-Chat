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
    @FocusState private var usdcAmountIsFocused: Bool
    
    var body: some View {
        VStack {
            Image("profile")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.top, 30)
            
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
        
        FlowManager.shared.transferUSDC(amount: amount, recipient: Flow.Address(hex: receiver))
        
        FirebaseManager.shared.addMessagesToChat(chatId: self.chatId, receiver: receiver, receiverFlown: receiverFlown, sender: FlowManager.shared.userAddress!, senderFlown: senderFlown[0].name, content: "USDC Transfer \(self.usdcAmount)")
    
    }
}

struct SendUSDCModal_Previews: PreviewProvider {
    static var previews: some View {
        SendUSDCModal(chatId: "abcdef", recipient: "snoopies.fn")
    }
}
