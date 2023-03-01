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
    @FocusState private var flowAmountIsFocused: Bool
    
    var body: some View {
        VStack {
            Image("profile")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.top, 30)
            
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
        
        FirebaseManager.shared.addMessagesToChat(chatId: self.chatId, receiver: receiver, receiverFlown: receiverFlown, sender: FlowManager.shared.userAddress!, senderFlown: senderFlown[0].name, content: "FLOW Transfer \(self.flowAmount)")
    }
}

struct SendFlowModal_Previews: PreviewProvider {
    static var previews: some View {
        SendFlowModal(chatId: "abcdef", recipient: "snoopies.fn")
    }
}
