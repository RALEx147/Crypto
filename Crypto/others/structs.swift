//
//  structs.swift
//  Crypto
//
//  Created by Robert Alexander on 12/27/17.
//  Copyright © 2017 Robert Alexander. All rights reserved.
//

import Foundation
import UIKit

struct currency: Decodable {
    let rates: rates
}
struct rates: Decodable {
    let AUD: Double
    let CAD: Double
    let EUR: Double
    let GBP: Double
    let CNY: Double
    let JPY: Double
    let SGD: Double
    let MXN: Double
    let KRW: Double
    let BRL: Double
    
}

struct CMC: Decodable{
    let name: String?
    let rank: String?
    let symbol: String?
    let price_usd: String?
    let percent_change_24h: String?
}
struct NEON: Decodable {
    let balances: [NEO]
}
struct NEO: Decodable {
    var name: String?
    let total: String?
    var price_usd: Double?
    
}



struct BTC: Decodable {
    let balance: Double
}
struct LTCN: Decodable {
    let status: String
    let data: LTC
}
struct LTC: Decodable {
    let confirmed_balance: Double
}



struct XRPN: Decodable {
    let result: String?
    let balances: [XRP]?
}

struct XRP: Decodable {
    var currency: String?
    let value: String?
    var price_usd: Double?
    
}


struct ETH: Decodable {
    let ETH: ether?
    let tokens: [ERC20]?
}
struct ERC20: Decodable{
    let tokenInfo: ERC20Info?
    let balance: Double?
}
struct ERC20Info: Decodable {
    let name: String?
    var decimals: Dec?
    let symbol: String?
}
struct Dec: Decodable {
    let decString: String
    let decInt: Int
    
    init(from decoder: Decoder) throws {
        let container =  try decoder.singleValueContainer()
        
        // Check for a boolean
        do {
            decString = try container.decode(String.self)
            decInt = 0
        } catch {
            // Check for an integer
            decInt = try container.decode(Int.self)
            decString = ""
        }
    }
}

struct ether: Decodable{
    let balance: Double?
}

struct Binance: Decodable {
    let balances: [BinanceCoins]?
}
struct BinanceCoins: Decodable{
    let asset: String?
    let free: String?
}


struct CMCC: Decodable{
    struct inner: Decodable {
        let rank: Int?
        let name: String?
        let symbol: String?
        let quotes: CMCC1
    }

    
    let data: [String: inner]
    
    
}

struct CMCC1: Decodable{
    let USD: CMCC2
}
struct CMCC2: Decodable{
    let price: Double?
    let percent_change_24h: Double?
}





