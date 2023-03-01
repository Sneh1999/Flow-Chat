//
//  FlowTransferShape.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-27.
//

import SwiftUI

struct TokenTransferBubble: View {
    enum Direction {
        case left
        case right
    }
    
    enum TokenType {
        case USDC
        case Flow
    }
    
    @State var token: TokenType
    @State var direction: Direction
    @State var amount: String
    
    
    var body: some View {
        HStack {
            if direction == .right {
                Spacer()
            }
            HStack {
                if token == .USDC {
                    Image("usdcLogo")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                    
                    Text(self.direction == .left ? "You received \(self.amount) \(token == .USDC ? "USDC" : "Flow")" : "You sent \(self.amount) \(token == .USDC ? "USDC" : "Flow")")
                } else {
                    Image("flowLogo")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                    
                    Text(self.direction == .left ? "You received \(self.amount) \(token == .USDC ? "USDC" : "Flow")" : "You sent \(self.amount) \(token == .USDC ? "USDC" : "Flow")")
                }
                
            }
            .padding([.leading, .trailing], 20)
            .padding([.top, .bottom], 15)
            .foregroundColor(Color.white)
            .background(token == .USDC ? Color(red: 39/255, green: 116/255, blue: 202/255) : Color(red: 0, green: 239/255, blue: 139/255))
            .clipShape(ChatBubbleShape(direction: direction == .left ? .left : .right))
            
            if direction == .left {
                Spacer()
            }
        }.padding([(direction == .left) ? .leading : .trailing, .top, .bottom], 20)
        .padding((direction == .right) ? .leading : .trailing, 50)
    }
}

struct TokenTransferBubble_Previews: PreviewProvider {
    static var previews: some View {
        TokenTransferBubble(
            token: .Flow,
            direction: .left, amount: "500")
    }
}
