//
//  oldCode.swift
//  Crypto
//
//  Created by Robert Alexander on 12/31/17.
//  Copyright © 2017 Robert Alexander. All rights reserved.
//

import Foundation

//func neoTotal() -> Double?{
//    if neo != nil && !neo.isEmpty  && !all.isEmpty && all != nil{
//        for i in 0...neo.count-1{
//            if let amount = Double(neo[i].total!){
//                if neo[i].name == "NEO"{
//                    if let price = Double(self.getPrice(name: "NEO")){neo[i].price_usd = (amount * price)}}
//                else if neo[i].name == "GAS"{
//                    if let price = Double(self.getPrice(name: "Gas")){neo[i].price_usd = (amount * price)}}
//                else if neo[i].name == "RPX"{
//                    if let price = Double(self.getPrice(name: "Red Pulse")){neo[i].price_usd = (amount * price)}
//                }
//            }
//        }
//        var output = 0.0
//        for i in neo{
//            output += i.price_usd ?? 0
//        }
//        return output
//    }
//    else{return nil}
//}

//  www.data.ripple.com/v2/accounts/rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn/balances

//        let r = Cell(name: "red pulse", tag: "rpx", amount: "0", balance: "0", address: "AX7zArzdTweY8MoDRozgriR7vTQWsaU3yW")
//        let g = Cell(name: "gas", tag: "gas", amount: "0", balance: "0", address: "AX7zArzdTweY8MoDRozgriR7vTQWsaU3yW")
//        let neo = Cell(name: "neo", tag: "main", amount: "0", balance: "0", address: "AX7zArzdTweY8MoDRozgriR7vTQWsaU3yW", subCells: [r, g])
//        let eth = Cell(name: "ethereum", tag: "eth", amount: "0", balance: "0", address: "0x345d1c8c4657c4BF228c0a9c247649Ea533B5D87")
//        self.cellArray.append(neo)
//        self.cellArray.append(eth)
//        self.saveCells()




//        let neo = Cell(name: "NEO", tag: "Main", amount: "0", price: "0", balance: "0", address: "AX7zArzdTweY8MoDRozgriR7vTQWsaU3yW", subCells: [Cell]())
//
//
//        let eth = Cell(name: "ETH", tag: "Ether", amount: "0", price: "0", balance: "0", address: "0x345d1c8c4657c4BF228c0a9c247649Ea533B5D87", subCells: [Cell]())
//                self.cellArray.append(neo)
//                self.cellArray.append(eth)
//                self.saveCells()
//
