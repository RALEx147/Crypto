//
//  AsyncFetch.swift
//  Crypto
//
//  Created by Robert Alexander on 7/7/18.
//  Copyright © 2018 Robert Alexander. All rights reserved.
//

import Foundation
extension FirstViewController{
	
	
	func cleanNeo(_ input : NEON) -> [NEO]{
		var output = [NEO]()
		for i in input.balances{
			let num = Double(i.total!) ?? 0.0
			if (i.name == "NEO" || num > 0.00001) {
				output.append(i)
			}
		}
		return output
	}
	
	func updateNEOCell(c:Cell,I:Int){
		var neo:[NEO]!
//		neoBalance(c){(completion) in neo = completion}
		GenericAsync(c) {(result: NEON) in neo = self.cleanNeo(result)}
		disGroup.notify(queue: .main){
			
			
			if neo != nil && !neo.isEmpty{
				
				var tempArr = [String]()
				if !c.subCells.isEmpty{
					for j in c.subCells!{
						tempArr.append(j.name.lowercased())
					}
				}
				tempArr.append("neo")
				
				for i in neo.indices{
					let namee = neo[i].name!
					if let space = namee.index(of: " ") {
						neo[i].name = String(namee[namee.startIndex..<space])
					}
				}
				var newSubcells = [NEO]()
				for i in neo{
					if !tempArr.contains((i.name?.lowercased())!){
						newSubcells.append(i)
					}
				}
				
				
				for x in newSubcells{
					let t = (Double(x.total!)) ?? 0.0
					let p = Double(self.getPrice(name: x.name!.lowercased())) ?? 0.0
					let new = Cell(name: x.name!, tag: x.name!, amount: x.total!, price: String(describing: p), balance: String(describing: (t * p)), address: c.address!, subCells: [Cell]())
					c.subCells!.append(new)
					
					
				}
				
				
				for i in neo{
					if i.name?.lowercased() != "neo"{
						for j in c.subCells!{
							if i.name?.lowercased() == j.name.lowercased() {
								j.amount = i.total
								if let t = (Double(i.total!)), let p = Double(self.getPrice(name: j.name.lowercased())){
									j.balance = String(describing: (t * p))
									j.price = String(describing: p)
									
								}
							}
						}
					}
					
					if i.name?.lowercased() == "neo"{
						c.amount = i.total
						if let t = (Double(i.total!)){
							c.amount = String(describing: t)
							if let p = Double(self.getPrice(name: c.name.lowercased())){
								c.balance = String(describing: (t * p))
								c.price = String(describing: p)
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
	
	
	
	
	
	
	
	
	
	func neoBalance(_ c: Cell, completion: @escaping ([NEO]?) -> ()){
		self.disGroup.enter()
		var done = false
		var fail = false
		let link = "https://otcgo.cn/api/v1/balances/" + c.address
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
			if !done{
				fail = true
				self.disGroup.leave()
				completion([NEO]())
			}
		}
		guard let url = URL(string: link) else { return }
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let data = data {
				do {
					let neo = try JSONDecoder().decode(NEON.self, from: data)
					var output = [NEO]()
					for i in neo.balances{
						let num = Double(i.total!) ?? 0.0
						if (i.name == "NEO" || num > 0.00001) {
							output.append(i)
						}
					}
					print("neo")
					done = true
					if !fail{
						self.disGroup.leave()
					}
					completion(output)
				} catch let jsonErr {
					print("NEO Error serializing json:", jsonErr)
					self.disGroup.leave()
					done = true
					completion(nil)
				}
			}
			}.resume()
	}
	
	
}
