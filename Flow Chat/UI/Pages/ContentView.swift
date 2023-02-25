//
//  ContentView.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-19.
//

import SwiftUI
import FCL
import Combine
import Flow

extension ContentView {
    struct ViewState {
        var balance: Decimal
    }
    
    enum Action {
        case signMessage
        case getBalance
        case transferFlow(Decimal, Flow.Address)
        case transferUSDC(Decimal, Flow.Address)
    }
}


struct ContentView: View {
    @State private var amountOfFlow = "0"
    @State private var amountOfUSDC = "0"
    @State private var flowRecipient = "0xe0529116d77ec74f"
    @State private var usdcRecipient = "0xdc159530934c4910"
    
    @StateObject
    var vm: AnyViewModel<ViewState, Action>
    
    let response = try! fcl.currentUser?.address.asJSONEncodedString() ?? ""
    let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            
            VStack {
             
                Text("I am logged in")
                Text("My balance is: " + vm.state.balance.description + " FLOW tokens")
                    .onReceive(timer) { time in
                        vm.trigger(.getBalance)
                    }

                Text(response)
                
                Group {
                    Group {
                        Text("Amount of flow to transferr")
                        
                        TextField(
                            "Amount of flow to transfer",
                            text: $amountOfFlow
                        )
                        .keyboardType(.decimalPad)
                        .onReceive(Just(amountOfFlow)) { newValue in
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                self.amountOfFlow = filtered
                            }
                        }
                    }
                    
                    Group {
                        Text("Recepient")
                        TextField(
                            "Recepient",
                            text: $flowRecipient
                        ).onReceive(Just(flowRecipient)) { newRecipient in
                            self.flowRecipient = newRecipient
                        }
                    }
                    
                    
                    
                    
                    Button {
                        vm.trigger(.transferFlow(Decimal(string: self.amountOfFlow)!,Flow.Address(hex: self.flowRecipient)  ))
                    } label: {
                        Text("Send Flow")
                    }
                    
                }
                
                
                
                Text("Amount of usdc to transfer")
                TextField(
                    "Amount of usdc to transfer",
                    text: $amountOfUSDC
                )
                .keyboardType(.decimalPad)
                .onReceive(Just(amountOfUSDC)) { newValue in
                    let filtered = newValue.filter { "0123456789.".contains($0) }
                    if filtered != newValue {
                        self.amountOfUSDC = filtered
                    }
                }
                Text("USDC Recepient")
                TextField(
                    "Recepient",
                    text: $usdcRecipient
                ).onReceive(Just(usdcRecipient)) { newRecipient in
                    self.usdcRecipient = newRecipient
                }
                
                Button {
                    vm.trigger(.transferUSDC(Decimal(string: self.amountOfFlow)!,Flow.Address(hex: self.flowRecipient)))
                } label: {
                    Text("Send USDC")
                }
            }
            
        }.onAppear {
            vm.trigger(.getBalance)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: .init(ContentViewModel()))
    }
}
