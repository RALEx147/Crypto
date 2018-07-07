//
//  AsyncFetchBNB.swift
//  Crypto
//
//  Created by Robert Alexander on 7/7/18.
//  Copyright © 2018 Robert Alexander. All rights reserved.
//

import Foundation
import Alamofire

extension FirstViewController{
	
	func updateBNBCell(c:Cell,I:Int){
		var bnb: [BinanceCoins]!
		self.bnbBalacne(c){(completion) in bnb = completion}
		self.disGroup.notify(queue: .main){
			
			var nameArr = [String]()
			var bnbArr = [String]()
			for i in c.subCells{
				nameArr.append(i.name)
			}
			c.balance = "0"
			c.amount = "0"
			c.price = "0"
			if bnb != nil{
				
				for i in bnb{
					bnbArr.append(i.asset!.lowercased())
				}
				print(bnbArr)
				for i in stride(from: c.subCells.count-1, to: -1, by: -1) {
					if !bnbArr.contains(c.subCells[i].name.lowercased()){
						c.subCells.remove(at: i)
					}
				}
				
				for i in bnb{
					if !nameArr.contains(i.asset!){
						if let a = Double(i.free!), let p = Double(self.getPrice(name: i.asset!)){
							c.subCells.append(Cell(name: i.asset!, tag: "", amount: i.free!, price: self.getPrice(name: i.asset!), balance: String(describing: (a * p)), address: "", subCells: [Cell]()))
						}
					}
					else{
						for i in c.subCells{
							for j in bnb{
								if i.name!.lowercased() == j.asset!.lowercased(){
									i.amount = j.free!
									i.price = self.getPrice(name: j.asset!)
									if let a = Double(j.free!), let p = Double(self.getPrice(name: j.asset!)){
										i.balance = String(describing: (a * p))
									}
								}
							}
						}
					}
				}
			}
			else {
				self.succeed = false
				self.errorArray[I] = "yes"
			}
			
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	func bnbBalacne(_ c:Cell, completion: @escaping ([BinanceCoins]) -> ()){
		
		let seperate = c.address.split(separator: " ")
		let apikey = String(seperate[0])
		let secret = String(seperate[1])
		let time = Int64(NSDate().timeIntervalSince1970*1000)
		let signkey = "timestamp=\(time)"
		let signature = signkey.hmac(base64key:secret)
		let headers: HTTPHeaders = ["X-MBX-APIKEY": apikey]
		var out = [BinanceCoins]()
		self.disGroup.enter()
		
		let manager = Alamofire.SessionManager.default
		manager.session.configuration.timeoutIntervalForRequest = 15
		
		manager.request("https://api.binance.com/api/v3/account?timestamp=\(time)&signature=\(signature)", method: .get, headers: headers).responseJSON {response in
			do {
				debugPrint(response)
				let binance = try JSONDecoder().decode(Binance.self, from: response.data!)
				guard let balances = binance.balances else{throw MyError.runtimeError("balances is nil")}
				
				for i in balances{
					if let amount = Double(i.free!) {
						if amount > 0{
							out.append(i)
						}
					}
				}
				
				let final = out.filter {
					if let price = Double(self.getPrice(name: $0.asset!.lowercased())) {
						return Double($0.free!)! * price > 0.5
					}
					else{
						return false
					}
				}
				self.disGroup.leave()
				completion(final)
			}
			catch{
				print("bnb error", error)
				self.disGroup.leave()
			}
			
		}
	}
}
