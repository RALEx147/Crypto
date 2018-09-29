//
//  AsyncFetchXRP.swift
//  Crypto
//
//  Created by Robert Alexander on 7/7/18.
//  Copyright © 2018 Robert Alexander. All rights reserved.
//

import Foundation

extension FirstViewController{
	
	func updateXRPCell(c:Cell,I:Int){
		var xrp:[XRP]!
		xrpBalance(c){(completion) in xrp = completion}
		var already = [String]()
		for k in c.subCells{
			already.append(k.name)
		}
		
		
		disGroup.notify(queue: .main){
			var dict = [String:Double]()
			
			
			
			if let list = xrp{
				for i in list{
					
					if let amount = Double(i.value!){
						if amount > 0.001 || amount < -0.001{
							
							if dict[i.currency!] != nil{
								dict[i.currency!]! += amount
							}
							else{
								dict[i.currency!] = amount
							}
						}
					}
				}
			}
			else{
				self.succeed = false
				self.errorArray[I] = "yes"
			}
			let xrpArray = Array(dict)
			for i in xrpArray{
				if i.key == "XRP"{
					if let p = Double(self.getPrice(name: c.name.lowercased())){
						
						c.amount = String(describing: i.value)
						c.price = String(describing: p)
						c.balance = String(i.value * p)
					}
					
				}
				else{
					if !already.contains(i.key){
						if currNames.contains(i.key){
							if let p = Double(self.getCurrency( i.key)){
								let new = Cell(name: i.key, tag: i.key, amount: String(i.value), price: String(p), balance: String(Double(i.value) * p), address: c.address, subCells: [Cell]())
								c.subCells.append(new)
							}
						}
						else{
							if let p = Double(self.getPrice(name: i.key)){
								let new = Cell(name: i.key, tag: i.key, amount: String(i.value), price: String(p), balance: String(Double(i.value) * p), address: c.address, subCells: [Cell]())
								c.subCells.append(new)
							}
						}
					}
					else{
						for u in c.subCells{
							if i.key.lowercased() == u.name.lowercased(){
								c.amount = String(describing: i.value)
								if currNames.contains(i.key){
									print(i.key, self.getCurrency(u.name))
									if let p = Double(self.getCurrency(u.name)){
										u.price = String(p)
										u.balance = String(i.value * p)
									}
								}
								else{
									if let p = Double(self.getPrice(name: u.name)){
										u.price = String(p)
										u.balance = String(i.value * p)
									}
								}
							}
						}
					}
				}
			}
			c.subCells.sort(by: { $0.balance > $1.balance })
			
		}
	}
	
	
	
	
	
	
	
	
	func xrpBalance(_ c:Cell, completion: @escaping ([XRP]) -> ()){
		self.disGroup.enter()
		var done = false
		let link = "https://data.ripple.com/v2/accounts/" + c.address + "/balances"
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
			if !done{
				self.disGroup.leave()
				completion([XRP]())
			}
		}
		
		guard let url = URL(string: link) else { return }
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let data = data {
				do {
					let balance = try JSONDecoder().decode(XRPN.self, from: data)
					
					if balance.result == "success"{
						done = true
					}
					else{
						done = false
					}
					print("xrp")
					self.disGroup.leave()
					completion(balance.balances!)
				} catch let jsonErr {
					print("XRP Error serializing json:", jsonErr)
				}
			}
			}.resume()
	}
}
