//
//  ChatListItem.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-24.
//

import SwiftUI

struct ChatListItem: View {
    
    @State var chat: ChatInfo
    @State var avatar: String = ""
    
    func getUser() -> String {
        if (chat.primary_user == FlowManager.shared.userAddress!) {
            let flowns = FlownManager.shared.getFlownFromAddress(userAddress: chat.secondary_user)
            if flowns.count > 0 {
                return flowns[0].name
            } else {
                return chat.secondary_user
            }
        } else {
            let flowns = FlownManager.shared.getFlownFromAddress(userAddress: chat.primary_user)
            if flowns.count > 0 {
                return flowns[0].name
            } else {
                return chat.primary_user
            }
        }
    }
    
    func getAvatar(recipient: String) -> String  {
        // if the user sent a flown name, get the owner address
        if recipient.hasSuffix(".fn") {
            let flown = FlownManager.shared.getAddressFromFlown(flownName: recipient)
            
            if (flown.texts.profile != nil) {
                let jsonData = flown.texts.profile!.data(using: .utf8)!
                if let profile = try? JSONDecoder().decode(Profile.self, from: jsonData) {
                    print("avatar")
                    avatar = profile.avatar
                    return profile.avatar
                } else {
                    print("Invalid Response")
                    avatar = "https://avatar.vercel.sh/" + recipient
                    return "https://avatar.vercel.sh/" + recipient
                }
            }
            
        } else {
            let flowns =   FlownManager.shared.getFlownFromAddress(userAddress: recipient)
            if !flowns.isEmpty  {
                let texts = flowns[0].texts
                if (texts.profile != nil) {
                    let jsonData = texts.profile!.data(using: .utf8)!
                    if let profile = try? JSONDecoder().decode(Profile.self, from: jsonData) {
                        avatar = profile.avatar
                        return profile.avatar
                        
                    } else {
                        print("Invalid Response")
                        avatar = "https://avatar.vercel.sh/" + recipient
                        return "https://avatar.vercel.sh/" + recipient
                    }
                }
            }
        }
        avatar = "https://avatar.vercel.sh/" + recipient
        return "https://avatar.vercel.sh/" + recipient
    }
    
    
    var body: some View {
        HStack {
            
            AsyncImage(url:  URL(string: getAvatar(recipient: chat.primary_user == FlowManager.shared.userAddress! ? chat.secondary_user : chat.primary_user)) ){ image in
                image.resizable()
            }
        placeholder: {
            ProgressView()
        }
        .frame(width: 70, height: 70)
        .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(getUser())
                    .fontWeight(.bold)
                
                Text(chat.messages.count > 0 ? chat.messages[0].content : "" )
            }
            
            Spacer()
            
            VStack {
                ZStack {
                    Circle()
                        .fill(.blue)
                }
                .frame(width: 25, height: 25)
            }
        }
        .listRowSeparator(.hidden)
    }
    
}



struct ChatListItem_Previews: PreviewProvider {
    static var previews: some View {
        ChatListItem(chat: ChatInfo(primary_user: "", secondary_user: "", messages: []))
    }
}
