//
//  SendNewMessage.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-24.
//

import SwiftUI

struct SendNewMessage: View {
    
    @State var toAddress: String = ""
    @State var message: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("New Message")
                    .fontWeight(.bold)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color(red: 52/255, green: 54/255, blue: 53/255))
            
            HStack {
                Text("To: ")
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                TextField("0x0", text: $toAddress)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            
            Divider()
             .frame(height: 1)
            
            Spacer()

            HStack {
                Text("Message: ")
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                
                HStack {
                    TextField("What's on your mind?", text: $message)
                        .frame(maxWidth: .infinity)
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 25))
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 2).foregroundColor(Color(red: 52/255, green: 54/255, blue: 53/255)))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 10)
            
        }
    }
}

struct SendNewMessage_Previews: PreviewProvider {
    static var previews: some View {
        SendNewMessage()
    }
}
