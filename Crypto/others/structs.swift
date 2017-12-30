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


class cells: NSObject{
    var name:String!
    var tag:String?
    var more:String?
    var amount:String!
    var balance:String!
    var subCells = [cells]()
    override var description: String { return "name:\(name!), tag:\(tag ?? ""), more:\(more ?? ""), amount:\(amount!), balance:\(balance!), subCells: \(subCells)||"}

    override init() {
        super.init()
    }
    
    init(coder decoder: NSCoder) {
        self.name = decoder.decodeObject(forKey: "name") as! String
        self.tag = decoder.decodeObject(forKey: "tag") as? String
        self.more = decoder.decodeObject(forKey: "more") as? String
        self.amount = decoder.decodeObject(forKey: "amount") as! String
        self.balance = decoder.decodeObject(forKey: "balance") as! String
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.tag, forKey: "tag")
        coder.encode(self.more, forKey: "more")
        coder.encode(self.amount, forKey: "amount")
        coder.encode(self.balance, forKey: "balance")
        
    }
    
}


class ethCell: cells{
    init(t:String, m:String, a:String, b:String) {
        super.init()
        name = "Ethereum"
        tag = t
        more = m
        amount = a
        balance = b
    }
}

class neoCell: cells{
    var rpx:rpxCell?
    var gas:gasCell?
    
    override var description: String { return super.description + (rpx?.description)! + (gas?.description)!}
    
    init(t:String, m:String, a:String, b:String, r:rpxCell?, g:gasCell?) {
        super.init()
        name = "NEO"
        tag = t
        more = m
        amount = a
        balance = b
        rpx = r
        gas = g
        if gas != nil {subCells.append(gas!)}
        if rpx != nil {subCells.append(rpx!)}

    }
}

class rpxCell: cells {
    init(a:String, b:String) {
        super.init()
        name = "Red Pulse"
        amount = a
        balance = b
    }
}


class gasCell: cells {
    init(a:String, b:String) {
        super.init()
        name = "Gas"
        amount = a
        balance = b
    }
}


class addCoin: cells{
    override init() {
        super.init()
        name = ""
        amount = ""
        balance = ""
        more = ""
        tag = ""
    }
}




