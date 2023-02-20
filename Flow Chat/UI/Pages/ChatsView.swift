//
//  ChatsView.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-20.
//

import SwiftUI

struct ChatsView: View {
    var body: some View {
        NavigationStack {
            List {
                ForEach(0..<20, id: \.self) { _ in
                    ChatView()
                }
            }
            .listStyle(.inset)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Chats")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                    
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
    }
}
