//
//  AsyncFetchLTC.swift
//  Crypto
//
//  Created by Robert Alexander on 7/7/18.
//  Copyright © 2018 Robert Alexander. All rights reserved.
//

import Foundation

extension FirstViewController{
	
	func updateLTCCell(c:Cell,I:Int){
		var ltc:LTC!
		ltcBalance(c){(completion) in ltc = completion}
		disGroup.notify(queue: .main){
			if Double(ltc.confirmed_balance) >= 0.0 {
				if let p = Double(self.getPrice(name: c.name.lowercased())){
					
					c.balance = String(p * ltc.confirmed_balance)
					c.amount = String(ltc.confirmed_balance)
					c.price = String(describing: p)
				}
			}
			else{
				self.succeed = false
				self.errorArray[I] = "yes"
			}
		}
	}
	
	
	
	func ltcBalance(_ c:Cell, completion: @escaping (LTC?) -> ()){
		self.disGroup.enter()
		var done = false
		let link = "https://chain.so/api/v2/get_address_balance/LTC/" + c.address
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
			if !done{
				self.disGroup.leave()
				let l = LTC(confirmed_balance: -999)
				completion(l)
			}
		}
		guard let url = URL(string: link) else { return }
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let data = data {
				do {
					let balance = try JSONDecoder().decode(LTCN.self, from: data)
					if balance.status == "success"{
						print("ltc")
						self.disGroup.leave()
						done = true
						completion(balance.data)
					}
				} catch let jsonErr {
					print("LTC Error serializing json:", jsonErr)
					self.disGroup.leave()
					done = true
					completion(nil)
					
				}
			}
			}.resume()
	}
}
