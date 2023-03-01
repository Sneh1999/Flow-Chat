//
//  FlowManager.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-19.
//

import FCL
import Flow
import SwiftUI
import Foundation
import UIKit

class FlowManager: ObservableObject {
    static let shared = FlowManager()
    
    @Published
    private(set) var state: ContentView.ViewState = .init(balance: 0)
    
    @Published
    var pendingTx: String? = nil
    
    @Published
    var userAddress: String? = nil
    
    @Published
    var topshotIds: [Decimal] = []
    
    func setUserAddress(newAddr: String) {
        self.userAddress = newAddr
    }
    
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
    
    func getBalance(address: Flow.Address) {
        Task {
            do {
                let balance: Decimal? = try await fcl.query(script: FlowCadence.getBalance, args: [.address(address)]).decode()
                self.state.balance = balance!
            } catch {
                print(error)
            }
        }
    }
    
    func getUSDCBalance(address: Flow.Address) {
        Task {
            do {
                let balance: Decimal? = try await fcl.query(script: FlowCadence.getUSDCBalance, args: [.address(address)]).decode()
                self.state.balance = balance!
            } catch {
                print(error)
            }
        }
    }
    
    func getTopshotMoments() {
        Task {
            do {
                let ids: [Decimal] = try await fcl.query(script: FlowCadence.fetchTopshotMoments, args: [.address(Flow.Address(hex: userAddress!))]).decode()
                self.topshotIds = ids
            } catch {
                print(error)
            }
        }
    }
    
    func transferFlow(amount: Decimal, recipient: Flow.Address) {
        Task {
            do {
                let txId = try await fcl.mutate(cadence: FlowCadence.transferFlow, args: [.ufix64(amount), .address(recipient)])
                FlowManager.shared.subscribeTransaction(txId: txId.hex)
            } catch {
                print(error)
            }
        }
        
    }
    
    func transferUSDC(amount: Decimal, recipient: Flow.Address, showError: Binding<Bool>) {
        Task {
            do {
                let senderHasUSDCVault: Bool = try await fcl.query(script: FlowCadence.hasUSDCVault, args: [.address(Flow.Address(hex: userAddress!))]).decode()
                if (!senderHasUSDCVault) {
                    showError.wrappedValue.toggle()
                    print("sender doesnt have usdc vault")
                    return
                }
                let recipientHasUSDCVault: Bool = try await fcl.query(script: FlowCadence.hasUSDCVault, args: [.address(recipient)]).decode()
                if (!recipientHasUSDCVault) {
                    showError.wrappedValue.toggle()
                    print("recipient doesnt have usdc vault")
                    return
                }
                let txId = try await fcl.mutate(cadence: FlowCadence.transferUSDC, args: [.ufix64(amount), .address(recipient)])
                print(txId.hex)
                FlowManager.shared.subscribeTransaction(txId: txId.hex)
            } catch {
                print(error)
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
            .put("0xTopshotAddress", value: "0x877931736ee77cff")
    }
    
}
