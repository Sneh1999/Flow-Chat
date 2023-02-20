//
//  FlowManager.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-19.
//

import FCL
import Flow
import Foundation
import UIKit

class FlowManager: ObservableObject {
    static let shared = FlowManager()
    
    @Published
       var pendingTx: String? = nil

       func subscribeTransaction(txId: String) {
           Task {
               do {
                   let id = Flow.ID(hex: txId)
                   DispatchQueue.main.async {
                       self.pendingTx = txId
                   }
                   _ = try await id.onceSealed()
                   await UIImpactFeedbackGenerator(style: .light).impactOccurred()
                   DispatchQueue.main.async {
                       self.pendingTx = nil
                   }
               } catch {
                   DispatchQueue.main.async {
                       self.pendingTx = nil
                   }
               }
           }
       }
    
    func setup() {
        let defaultProvider: FCL.Provider = .dapperSC
        let defaultNetwork: Flow.ChainID = .testnet
        let accountProof = FCL.Metadata.AccountProofConfig(appIdentifier: "Flow Chat")
        let walletConnect = FCL.Metadata.WalletConnectConfig(urlScheme: "flow-chat://", projectID: "f621cf2079ef9373d0bac2caec0a7c0b")
        let metadata = FCL.Metadata(appName: "Flow Chat",
                                    appDescription: "Flow Chat App",
                                    appIcon: URL(string: "https://i.imgur.com/jscDmDe.png")!,
                                    location: URL(string: "https://google.com")!,
                                    accountProof: accountProof,
                                    walletConnectConfig: walletConnect)
        fcl.config(metadata: metadata,
                   env: defaultNetwork,
                   provider: defaultProvider)
        
        fcl.config
            .put("0xFlowToken", value: "0x7e60df042a9c0868")
            .put("0xFungibleToken", value: "0x631e88ae7f1d7c20")
            .put("0xFiatToken", value: "0xa983fecbed621163")
        
    }
    
}
