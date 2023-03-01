//
//  ChatMessagesList.swift
//  Flow Chat
//
//  Created by Hayuuuuu on 2/28/23.
//

import SwiftUI

struct ChatMessagesList: View {
    @State var message: Message
    
    var body: some View {
        if message.receiver == FlowManager.shared.userAddress! {
            if message.content.starts(with: "FLOW Transfer") {
                let amount = message.content.split(separator: " ")[2]
                TokenTransferBubble(token: .Flow, direction: .left, amount: String(amount))
            } else if message.content.starts(with: "USDC Transfer") {
                let amount = message.content.split(separator: " ")[2]
                TokenTransferBubble(token: .USDC, direction: .left, amount: String(amount))
            } else {
                ChatBubble(direction: .left) {
                    Text(message.content)
                        .padding([.leading, .trailing], 20)
                        .padding([.top, .bottom], 15)
                        .foregroundColor(Color.white)
                        .background(Color.green)
                }
                .padding(.horizontal, 20)
            }
        } else {
            if message.content.starts(with: "FLOW Transfer") {
                let amount = message.content.split(separator: " ")[2]
                TokenTransferBubble(token: .Flow, direction: .right, amount: String(amount))
            } else if message.content.starts(with: "USDC Transfer") {
                let amount = message.content.split(separator: " ")[2]
                TokenTransferBubble(token: .USDC, direction: .right, amount: String(amount))
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
    }
}


struct ChatMessagesList_Previews: PreviewProvider {
    static var previews: some View {
        ChatMessagesList(message: Message(content: "fsdfsf", created_at: Date(), receiver: "", receiverFlown: "", sender: "", senderFlown: ""))
    }
}
