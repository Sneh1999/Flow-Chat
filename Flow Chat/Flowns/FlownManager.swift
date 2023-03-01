//
//  FlownManager.swift
//  Flow Chat
//
//  Created by Sneh Koul on 2023-02-25.
//

import Foundation
import UIKit





struct Texts: Decodable {
    let profile : String?
}
struct Flown: Decodable {
    let id: String
    let owner: String
    let name: String
    let texts: Texts
}

class FlownManager: ObservableObject {
    
    static let shared = FlownManager()
    var flownArray: [Flown] = []
    
    func getFlownFromAddress(userAddress: String)  -> [Flown]{
        var url = "https://testnet.flowns.org/api/data/address/"
        url += userAddress
        print(url)
        let flownUrl = URL(string: url)!
        let sem = DispatchSemaphore(value: 0)
        var flownArray: [Flown] = []
        let task = URLSession.shared.dataTask(with: flownUrl) { data, response, error in
            defer { sem.signal() }
            if let data = data {
                if let flowns = try? JSONDecoder().decode([Flown].self, from: data) {
                    flownArray = flowns
                } else {
                    print("Invalid Response")
                    self.flownArray = []
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
                flownArray = []
            }
        }
        task.resume()
        sem.wait(timeout: DispatchTime.distantFuture)
        print("flownsarray")
        print(flownArray)
        return flownArray
    }
    
    
    
    
    
    func getAddressFromFlown(flownName: String) -> Flown {
        var url = "https://testnet.flowns.org/api/data/domain/"
        url += flownName
        print(url)
        let flownUrl = URL(string: url)!
        var userFlown: Flown = Flown(id: "", owner: "", name: "", texts: Texts(profile: ""))
        let sem = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: flownUrl) { data, response, error in
            defer { sem.signal() }
            if let data = data {
                if let flown = try? JSONDecoder().decode(Flown.self, from: data) {
                    print("flown")
                    print(flown)
                    userFlown = flown
                } else {
                    print("Invalid Response")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        task.resume()
        sem.wait(timeout: DispatchTime.distantFuture)
        return userFlown
    }
}
