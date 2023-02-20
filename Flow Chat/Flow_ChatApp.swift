//
//  Flow_ChatApp.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-19.
//

import SwiftUI
import FCL

@main
struct Flow_ChatApp: App {
    
    
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    
    @State
    var isLogin: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLogin {
                ContentView(vm: .init(ContentViewModel()))
            } else {
                LoginView().onReceive(fcl.$currentUser) { value in
                    self.isLogin = (value != nil)
                }
            }
        }
    }
    
}
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FlowManager.shared.setup()
        return true
    }
}
