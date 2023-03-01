//
//  TopshotMomentsModal.swift
//  Flow Chat
//
//  Created by Hayuuuuu on 2/28/23.
//

import SwiftUI
import WrappingHStack

struct TopshotMomentsModal: View {
    @ObservedObject var flowManager = FlowManager.shared
    @State var chatId: String
    @State var recipient: String
    
    var body: some View {
        VStack {
            if (flowManager.topshotIds.isEmpty) {
                HStack {
                    Text("You own no Dapper Sports NFTs")
                }
                
            } else {
                WrappingHStack {
                    ForEach(FlowManager.shared.topshotIds, id: \.self) { topshotId in
                        AsyncImage(url:  URL(string: "https://assets.nbatopshot.com/media/\(topshotId)/image")) { image in
                            image.resizable()
                        }
                    placeholder: {
                        ProgressView()
                    }
                    .frame(width: 500, height: 500)
                        
                        Button("Transfer") {
                        }
                        .frame(height: 75)
                        .font(.system(.largeTitle, weight: .bold))
                        .foregroundColor(.green)
                        .padding([.leading, .trailing], 50)
                        .background(Color(red: 39/255, green: 116/255, blue: 202/255))
                        .cornerRadius(10)

                    }
                }
                
            }
        }
        .onAppear {
            flowManager.getTopshotMoments()
        }
       
        
    }
}

struct TopshotMomentsModal_Previews: PreviewProvider {
    static var previews: some View {
        TopshotMomentsModal(chatId: "", recipient: "")
    }
}
