//
//  ContentViewModel.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-19.
//

import FCL
import Foundation
import Flow


class ContentViewModel: ViewModel {
    @Published
    private(set) var state: ContentView.ViewState = .init(balance: 0)
    
    func trigger(_ input: ContentView.Action) {
        switch input {
        case .signMessage:
            signMessage()
            
        case .getBalance:
            getBalance()
            
        case let .transferFlow(amount, recipient):
            transferFlow(amount: amount, recipient: recipient)
            
        case let .transferUSDC(amount, recipient):
            transferUSDC(amount: amount, recipient: recipient)
        }
        
            
    }
    
    private func getBalance() {
        Task {
            guard let address = fcl.currentUser?.addr else {
                throw FCLError.unauthenticated
            }
            do {
                let balance: Decimal? = try await fcl.query(script: FlowCadence.getBalance, args: [.address(address)]).decode()
                self.state.balance = balance!
            } catch {
                print(error)
            }
        }
    }
    
    private func transferFlow(amount: Decimal, recipient: Flow.Address) {
        Task {
            do {
                let txId = try await fcl.mutate(cadence: FlowCadence.transferFlow, args: [.ufix64(amount), .address(recipient)])
                FlowManager.shared.subscribeTransaction(txId: txId.hex)
            } catch {
                print(error)
            }
        }
        
    }
    
    private func transferUSDC(amount: Decimal, recipient: Flow.Address) {
        Task {
            do {
                let txId = try await fcl.mutate(cadence: FlowCadence.transferUSDC, args: [.ufix64(amount), .address(recipient)])
                print(txId.hex)
                FlowManager.shared.subscribeTransaction(txId: txId.hex)
            } catch {
                print(error)
            }
        }
        
    }
    
    private func signMessage() {
        Task {
            do {
                let message = try await fcl.signUserMessage(message: "Signing something")
                print(message)
                
            } catch {
                print(error)
            }
        }
    }
}
