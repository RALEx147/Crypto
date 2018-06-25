//
//  Cell.swift
//  Crypto
//
//  Created by Robb Alexander on 6/24/18.
//  Copyright © 2018 Robert Alexander. All rights reserved.
//

import Foundation

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
