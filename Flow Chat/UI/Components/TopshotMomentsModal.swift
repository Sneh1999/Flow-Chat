//
//  TopshotMomentsModal.swift
//  Flow Chat
//
//  Created by Hayuuuuu on 2/28/23.
//

import SwiftUI
import WrappingHStack

struct TopshotMomentsModal: View {
    @State var chatId: String
    @State var recipient: String
    
    var body: some View {
        if (FlowManager.shared.topshotIds.isEmpty) {
            HStack {
                Text("You own no Dapper Sports NFTs")
            }
            
        } else {
            WrappingHStack {
                ForEach(FlowManager.shared.topshotIds, id: \.self) { topshotId in
                    AsyncImage(url: URL(string: "https://assets.nbatopshot.com/media/\(topshotId)/image"))
                        .frame(width: 200, height: 200)
                }
            }
           
        }
       
    }
}

struct TopshotMomentsModal_Previews: PreviewProvider {
    static var previews: some View {
        TopshotMomentsModal(chatId: "", recipient: "")
    }
}
