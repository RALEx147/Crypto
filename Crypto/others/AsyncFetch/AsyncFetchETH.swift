//
//  AsyncFetchETH.swift
//  Crypto
//
//  Created by Robert Alexander on 7/7/18.
//  Copyright © 2018 Robert Alexander. All rights reserved.
//

import Foundation

extension FirstViewController{
	
	func updateETHCell(c:Cell,I:Int){
		var eth:ETH!
//		ethBalance(c){(completion) in eth = completion}
		GenericAsync(c){(result: ETH) in eth = result}
		disGroup.notify(queue: .main){
			
			if eth != nil && eth.ETH != nil && eth.ETH?.balance != nil{
				c.amount = String(describing: eth.ETH!.balance!)
				
				if let p = Double(self.getPrice(name: c.name.lowercased())){
					c.balance = String(describing: (eth.ETH!.balance! * p))
					c.price = String(describing: p)
					
				}
				
				
				
				var tempArr = [String]()
				if !c.subCells.isEmpty{
					for j in c.subCells!{
						tempArr.append(j.tag.lowercased())
					}
				}
				//bad programming but too lazy and im rushing to get this done
				var currentNamesInSubcell = [String]()
				if eth.tokens != nil{
					for i in eth.tokens!{
						currentNamesInSubcell.append((i.tokenInfo?.symbol?.lowercased())!)
					}
				}
				
				for i in stride(from: c.subCells.count-1, to: -1, by: -1) {
					if !currentNamesInSubcell.contains(c.subCells[i].name.lowercased()){
						c.subCells.remove(at: i)
					}
				}
				
				
				tempArr.append("ethereum")
				
				var newSubcells = [ERC20]()
				if eth.tokens != nil{
					for i in eth.tokens!{
						if !tempArr.contains((i.tokenInfo?.name?.lowercased())!){
							newSubcells.append(i)
						}
					}
				}
				
				
				for x in newSubcells{
					var exp: Int = 0
					if x.tokenInfo?.decimals?.decInt == 0 && x.tokenInfo?.decimals?.decString != ""{
						exp = Int((x.tokenInfo?.decimals?.decString)!)!
					}
					else if x.tokenInfo?.decimals?.decInt != 0{
						exp = (x.tokenInfo?.decimals?.decInt)!
					}
					let divisor = Double(10 ^ exp)
					let t = Double(x.balance!) / divisor
					if let p = Double(self.getPrice(name: (x.tokenInfo?.symbol!.lowercased())!)){
						let new = Cell(name: x.tokenInfo!.symbol!, tag: x.tokenInfo!.name!, amount: String(describing: t), price: String(describing: p), balance: String(describing: (t * p)), address: c.address!, subCells: [Cell]())
						c.subCells!.append(new)
					}
					
				}
				
				
				
				if eth.tokens != nil && !(eth.tokens?.isEmpty)!{
					for i in eth.tokens!{
						for j in c.subCells{
							if i.tokenInfo?.symbol?.lowercased() == j.name.lowercased() {
								if let p = Double(self.getPrice(name: j.name.lowercased())){
									let exp: Int
									if i.tokenInfo?.decimals?.decInt == 0 {
										exp = Int((i.tokenInfo?.decimals?.decString)!)!
									}
									else{
										exp = (i.tokenInfo?.decimals?.decInt)!
									}
									let divisor: Double = Double(truncating: pow(10, exp) as NSNumber)
									let t = Double(i.balance!) / divisor
									j.amount = String(describing: t)
									j.balance = String(describing: (t * p))
									j.price = String(describing: p)
									
								}
							}
							
						}
					}
				}
			}
			else{
				self.succeed = false
				self.errorArray[I] = "yes"
			}
		}
	}
	
	
	
	
	
	
	
	func ethBalance(_ c:Cell, completion: @escaping (ETH?) -> ()){
		self.disGroup.enter()
		var done = false
		let link = "https://api.ethplorer.io/getAddressInfo/" + c.address + "?apiKey=freekey"
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
			if !done{
				self.disGroup.leave()
				let e = ETH(ETH: ether(balance: nil), tokens: nil)
				completion(e)
			}
		}
		
		guard let url = URL(string: link) else { return }
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let data = data {
				do {
					let balance = try JSONDecoder().decode(ETH.self, from: data)
					
					print("eth")
					self.disGroup.leave()
					done = true
					completion(balance)
				} catch let jsonErr {
					print("ETH Error serializing json:", jsonErr)
					self.disGroup.leave()
					done = true
					completion(nil)
				}
			}
			}.resume()
	}
}
