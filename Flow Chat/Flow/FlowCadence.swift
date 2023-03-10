//
//  FlowCadence.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-20.
//

import Foundation

class FlowCadence {
    static let getBalance =
    """
    // This script reads the balance field of an account's FlowToken Balance
    import FungibleToken from 0xFungibleToken
    import FlowToken from 0xFlowToken
    
    pub fun main(account: Address): UFix64 {
    
        let vaultRef = getAccount(account)
            .getCapability(/public/flowTokenBalance)
            .borrow<&FlowToken.Vault{FungibleToken.Balance}>()
            ?? panic("Could not borrow Balance reference to the Vault")
    
        return vaultRef.balance
    }
    """
    
    static let getUSDCBalance =
    """
    import FungibleToken from 0xFungibleToken
    import FiatToken from 0xFiatToken
    
    pub fun main(account: Address): UFix64 {
        let acct = getAccount(account)
        let vaultRef = acct.getCapability(FiatToken.VaultBalancePubPath)
            .borrow<&FiatToken.Vault{FungibleToken.Balance}>()
            ?? panic("Could not borrow Balance reference to the Vault")
    
        return vaultRef.balance
    }
    """
    
    static let hasUSDCVault =
    """
    import FungibleToken from 0xFungibleToken
    import FiatToken from 0xFiatToken
    
    pub fun main(account: Address): Bool {
        let acct = getAccount(account)
        
        if acct.getCapability(FiatToken.VaultBalancePubPath).borrow<&FiatToken.Vault{FungibleToken.Balance}>() != nil {
            return true
        }
    
        return false
    }
    """
    
    static let transferUSDC =
    """
    import FungibleToken from 0xFungibleToken
    import FiatToken from 0xFiatToken
    
    transaction(amount: UFix64, to: Address) {
    
        // The Vault resource that holds the tokens that are being transferred
        let sentVault: @FungibleToken.Vault
    
        prepare(signer: AuthAccount) {
    
            // Get a reference to the signer's stored vault
            let vaultRef = signer.borrow<&FiatToken.Vault>(from: FiatToken.VaultStoragePath)
                ?? panic("Could not borrow reference to the owner's Vault!")
    
            // Withdraw tokens from the signer's stored vault
            self.sentVault <- vaultRef.withdraw(amount: amount)
        }
    
        execute {
    
            // Get the recipient's public account object
            let recipient = getAccount(to)
    
            // Get a reference to the recipient's Receiver
            let receiverRef = recipient.getCapability(FiatToken.VaultReceiverPubPath)
                .borrow<&{FungibleToken.Receiver}>()
                ?? panic("Could not borrow receiver reference to the recipient's Vault")
    
            // Deposit the withdrawn tokens in the recipient's receiver
            receiverRef.deposit(from: <-self.sentVault)
        }
    }
    """
    
    static let transferFlow =
    """
    // This transaction is a template for a transaction that
    // could be used by anyone to send tokens to another account
    // that has been set up to receive tokens.
    //
    // The withdraw amount and the account from getAccount
    // would be the parameters to the transaction
    import FungibleToken from 0xFungibleToken
    import FlowToken from 0xFlowToken
    
    transaction(amount: UFix64, to: Address) {
    
        // The Vault resource that holds the tokens that are being transferred
        let sentVault: @FungibleToken.Vault
    
        prepare(signer: AuthAccount) {
    
            // Get a reference to the signer's stored vault
            let vaultRef = signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)
                ?? panic("Could not borrow reference to the owner's Vault!")
    
            // Withdraw tokens from the signer's stored vault
            self.sentVault <- vaultRef.withdraw(amount: amount)
        }
    
        execute {
    
            // Get a reference to the recipient's Receiver
            let receiverRef =  getAccount(to)
                .getCapability(/public/flowTokenReceiver)
                .borrow<&{FungibleToken.Receiver}>()
                ?? panic("Could not borrow receiver reference to the recipient's Vault")
    
            // Deposit the withdrawn tokens in the recipient's receiver
            receiverRef.deposit(from: <-self.sentVault)
        }
    }
    """
    
    static let fetchTopshotMoments =
    """
    import TopShot from 0xTopshotAddress

    pub fun main(account: Address): [UInt64] {

        let acct = getAccount(account)

        let collectionRef = acct.getCapability(/public/MomentCollection)
                                .borrow<&{TopShot.MomentCollectionPublic}>()
    
        if collectionRef == nil {
            return []
        }

        return collectionRef!.getIDs()
    }
    """
}
