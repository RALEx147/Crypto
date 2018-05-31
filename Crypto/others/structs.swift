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
        let rank: Int
        let name: String
        let symbol: String
        let quotes: CMCC1
    }

    
    let data: [String: inner]
    
    
}

struct CMCC1: Decodable{
    let USD: CMCC2
}
struct CMCC2: Decodable{
    let price: Double
    let percent_change_24h: Double
}

class Cell: NSObject, NSCoding{
    
    var name:String!
    var tag:String!
    var more:String!
    var amount:String!
    var price:String!
    var address:String!
    var balance:String!
    var subCells:[Cell]!
    
    override var description: String { return "name:\(name!)\n tag:\(tag ?? "")\n more:\(more ?? "")\n price:\(price!)\n amount:\(amount!)\n balance:\(balance!)\n address:\(address!)\n subCells: \n\n\(String(describing: subCells))\n---------------------\n"}
    
    override init() {
        super.init()
    }
    
    init(name: String, tag: String, amount: String, price: String, balance: String, address: String, subCells: [Cell]) {
        super.init()
        self.name = name
        self.tag = tag
        self.amount = amount
        self.balance = balance
        self.price = price
        self.address = address
        self.subCells = subCells
        self.more = String(describing: subCells.count)
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as! String
        self.tag = decoder.decodeObject(forKey: "tag") as? String
        self.more = decoder.decodeObject(forKey: "more") as? String
        self.amount = decoder.decodeObject(forKey: "amount") as! String
        self.address = decoder.decodeObject(forKey: "address") as! String
        self.price = decoder.decodeObject(forKey: "price") as! String
        
        self.balance = decoder.decodeObject(forKey: "balance") as! String
        if let key = (decoder.decodeObject(forKey: "subCells") as? NSData) as Data? {
            self.subCells = NSKeyedUnarchiver.unarchiveObject(with: key) as! [Cell]
        }
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.tag, forKey: "tag")
        aCoder.encode(self.more, forKey: "more")
        aCoder.encode(self.amount, forKey: "amount")
        aCoder.encode(self.price, forKey: "price")
        aCoder.encode(self.address, forKey: "address")
        aCoder.encode(self.balance, forKey: "balance")
        aCoder.encode(NSKeyedArchiver.archivedData(withRootObject: self.subCells), forKey: "subCells")
        
    }
    
    func updateMore(){
        self.more = String(describing: subCells.count)
    }
    
    
    
    
}




