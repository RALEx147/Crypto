//
//  AsyncFetchBTC.swift
//  Crypto
//
//  Created by Robert Alexander on 7/7/18.
//  Copyright © 2018 Robert Alexander. All rights reserved.
//

import Foundation

extension FirstViewController{
	
	func updateBTCCell(c:Cell,I:Int){
		var btc:BTC!
//		btcBalance(c){(completion) in btc = completion}
		GenericAsync(c){(result: BTC) in btc = result}
		disGroup.notify(queue: .main){
			if btc != nil && Double(btc.balance) >= 0.0{
				if let p = Double(self.getPrice(name: c.name.lowercased())){
					c.balance = String(describing: (btc.balance * p))
					c.price = String(describing: p)
					c.amount = String(describing: btc.balance)
				}
			}
			else{
				self.succeed = false
				self.errorArray[I] = "yes"
			}
			
		}
	}
	
	
	
	
	func btcBalance(_ c:Cell, completion: @escaping (BTC?) -> ()){
		self.disGroup.enter()
		var done = false
		let link = "https://blockexplorer.com/api/addr/" + c.address
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
			if !done{
				self.disGroup.leave()
				let b = BTC(balance: -999)
				completion(b)
			}
		}
		guard let url = URL(string: link) else { return }
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let data = data {
				do {
					let balance = try JSONDecoder().decode(BTC.self, from: data)
					print("btc")
					self.disGroup.leave()
					done = true
					completion(balance)
				} catch let jsonErr {
					print("BTC Error serializing json:", jsonErr)
					
					self.disGroup.leave()
					done = true
					completion(nil)
				}
			}
			}.resume()
	}
	
}
