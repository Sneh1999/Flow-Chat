//
//  ChatView.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-20.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        HStack {
            Image("profile")
                .resizable()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("Sneh Koul")
                    .fontWeight(.bold)
                
                Text("What are you getting for food?")
            }
            
            Spacer()
            
            VStack {
                Text("13:42")
                    .fontWeight(.light)
                
                ZStack {
                  Circle()
                        .fill(.blue)
                  
                    Text("13")
                        .foregroundColor(.white)
                        .font(.caption)
                }
                .frame(width: 25, height: 25)
            }
        }
        .listRowSeparator(.hidden)
        
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
