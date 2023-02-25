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
            
            Button {
                fcl.openDiscovery()
            } label: {
                Text("Connect Wallet")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(height: 75)
            .padding([.leading, .trailing], 50)
            .background(.black)
            .cornerRadius(10)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 1
        .accentColor(Color.black)
        .background(Color(red: 0, green: 239/255, blue: 139/255))
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
