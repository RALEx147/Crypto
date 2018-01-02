//
//  structs.swift
//  Crypto
//
//  Created by Robert Alexander on 12/27/17.
//  Copyright © 2017 Robert Alexander. All rights reserved.
//

import Foundation
import UIKit

struct CMC: Decodable{
    let name: String?
    let rank: String?
    let symbol: String?
    let price_usd: String?
    let price_btc: String?
}
struct NEON: Decodable {
    let balances: [NEO]
}
struct NEO: Decodable {
    let name: String?
    let total: String?
    var price_usd: Double?
    
}
struct ETH: Decodable {
    let result: String?
}


class Cell: NSObject, NSCoding{

    var name:String!
    var tag:String!
    var more:String!
    var amount:String!
    var address:String!
    var balance:String!
    var subCells:[Cell]?
    
    override var description: String { return "name:\(name!), tag:\(tag ?? ""), more:\(more ?? ""), amount:\(amount!), balance:\(balance!), address:\(address!), subCells: \(String(describing: subCells))"}

    override init() {
        super.init()
    }
    
    init(name: String, tag: String, amount: String, balance: String, address: String, subCells: [Cell]? = nil) {
        super.init()
        self.name = name
        self.tag = tag
        self.amount = amount
        self.balance = balance
        self.address = address
        self.subCells = subCells
        self.more = String(describing: subCells?.count ?? 0)
    }
    
    required init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as! String
        self.tag = decoder.decodeObject(forKey: "tag") as? String
        self.more = decoder.decodeObject(forKey: "more") as? String
        self.amount = decoder.decodeObject(forKey: "amount") as! String
        self.address = decoder.decodeObject(forKey: "address") as! String
        self.balance = decoder.decodeObject(forKey: "balance") as! String
        if let key = (decoder.decodeObject(forKey: "subCells") as? NSData) as Data? {
            if let sC:[Cell] = NSKeyedUnarchiver.unarchiveObject(with: key) as? [Cell]{
                self.subCells = sC
            }
        }
    }


    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.tag, forKey: "tag")
        aCoder.encode(self.more, forKey: "more")
        aCoder.encode(self.amount, forKey: "amount")
        aCoder.encode(self.address, forKey: "address")
        aCoder.encode(self.balance, forKey: "balance")
        aCoder.encode(NSKeyedArchiver.archivedData(withRootObject: self.subCells), forKey: "subCells")
        
    }
    
    }





