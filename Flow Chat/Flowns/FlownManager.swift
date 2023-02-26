//
//  FlownManager.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-25.
//

import Foundation
import UIKit


struct Profile: Decodable {
    let avatar: String
}
struct Texts: Decodable {
    let profile: String
}
struct Flown: Decodable {
    let id: String
    let owner: String
    let name: String
    let texts: Texts
}

class FlownManager: ObservableObject {
    
    static let shared = FlownManager()
    
    
    func getFlownFromAddress(userAddress: String) -> [Flown]{
        var url = "https://testnet.flowns.org/api/data/address/"
        url += userAddress
        let flownUrl = URL(string: url)!
        var flownArray: [Flown] = []
        let task = URLSession.shared.dataTask(with: flownUrl) { data, response, error in
            if let data = data {
                if let flowns = try? JSONDecoder().decode([Flown].self, from: data) {
                    flownArray = flowns
                } else {
                    print("Invalid Response")
                    flownArray = []
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
                flownArray = []
            }
        }
        task.resume()
        
        return flownArray
    }
    
    
    func getAddressFromFlown(flownName: String) {
        var url = "https://testnet.flowns.org/api/data/domain/"
        url += flownName
        print(url)
        let flownUrl = URL(string: url)!
        
        let task = URLSession.shared.dataTask(with: flownUrl) { data, response, error in
            if let data = data {
                if let flown = try? JSONDecoder().decode(Flown.self, from: data) {
                    print(flown)
                } else {
                    print("Invalid Response")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
    }
}
