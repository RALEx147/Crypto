//
//  CMC.swift
//  Crypto
//
//  Created by Robert Alexander on 12/25/17.
//  Copyright © 2017 Robert Alexander. All rights reserved.
//

import Foundation


class CMC{
    
    
     struct coin: Decodable{
        let name: String?
        let rank: String?
        let price_usd: String?
        let price_btc: String?
        let percent_change_24h: String?
    }
    
    
    static func getCMC(completion: @escaping ([coin]) -> ()){
        let start = DispatchTime.now()
        guard let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/?limit=0") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let coin = try JSONDecoder().decode([coin].self, from: data)
                    let end = DispatchTime.now()
                    print(end.uptimeNanoseconds - start.uptimeNanoseconds)
                    completion(coin)
                } catch let jsonErr {print("Error serializing json:", jsonErr)}
            }
            }.resume()
    }
}
