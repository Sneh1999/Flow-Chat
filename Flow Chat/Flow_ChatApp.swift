//
//  Flow_ChatApp.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-19.
//

import SwiftUI
import FCL
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Firestore.firestore()
        FlowManager.shared.setup()
        
        return true
    }
}

@main
struct Flow_ChatApp: App {
    
    
    //    @UIApplicationDelegateAdaptor(AppDelegate.self)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State
    var isLogin: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLogin {
//                ContentView(vm: .init(ContentViewModel()))
                ChatsView(sheetChatID: "", sheetRecipient: "", sheetMessage: "")
                
            } else {
                LoginView().onReceive(fcl.$currentUser) { value in
                    if (value != nil) {
                        FlowManager.shared.setUserAddress(newAddr: (value?.addr.description)!)
                    }
                    self.isLogin = (value != nil)
                }
            }
        }
    }
    
}
