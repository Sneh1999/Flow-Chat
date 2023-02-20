//
//  LoginView.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-19.
//

import SwiftUI
import FCL

struct LoginView: View {
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 500.0, height: 500.0, alignment: .center)
                .clipShape(Circle())
            Button {
                fcl.openDiscovery()
            } label: {
                Text("Connect Wallet")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(colors: [.blue, .purple],                   startPoint: .topLeading,                   endPoint: .bottomTrailing) 
            )
            .cornerRadius(10)
            .padding()
            
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
