//
//  FlowTransferShape.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-27.
//

import SwiftUI

struct FlowTransferBubble: View {
    enum Direction {
        case left
        case right
    }
    
    @State var direction: Direction
    @State var amount: String
    
    
    var body: some View {
        HStack {
            Text(self.direction == .left ? "You received \(self.amount) FLOW" : "You sent \(self.amount) FLOW")
            
        }
        .padding([(direction == .left) ? .leading : .trailing, .top, .bottom], 20)
        .padding((direction == .right) ? .leading : .trailing, 50)
        .background(Color(red: 0, green: 239/255, blue: 139/255))
        .cornerRadius(10)
    }
}

struct FlowTransferBubble_Previews: PreviewProvider {
    static var previews: some View {
        FlowTransferBubble(
            direction: .left, amount: "500")
    }
}
