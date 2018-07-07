//
//  AsyncFetchCurrency.swift
//  Crypto
//
//  Created by Robert Alexander on 7/7/18.
//  Copyright © 2018 Robert Alexander. All rights reserved.
//

import Foundation

extension FirstViewController{
	
	
	
	
	func Currency(completion: @escaping (currency?) -> ()){
		self.disGroup3.enter()
		
		var done = false
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
			if !done{
				self.disGroup3.leave()
				completion(nil)
			}
		}
		guard let url = URL(string: "https://api.fixer.io/latest?base=USD") else { return }
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let data = data {
				do {
					
					let coin = try JSONDecoder().decode(currency.self, from: data)
					print("currency")
					self.disGroup3.leave()
					done = true
					completion(coin)
				} catch let jsonErr {
					print("CURENCY Error serializing json:", jsonErr)
				}
			}
			}.resume()
	}
	
	
	
	func getCurrency(_ name: String) -> String{
		switch name{
		case "AUD":
			return String(1 / c.rates.AUD)
		case "CNY":
			return String(1 / c.rates.CNY)
		case "JPY":
			return String(1 / c.rates.JPY)
		case "CAD":
			return String(1 / c.rates.CAD)
		case "MXN":
			return String(1 / c.rates.MXN)
		case "GBP":
			return String(1 / c.rates.GBP)
		case "EUR":
			return String(1 / c.rates.EUR)
		case "SGD":
			return String(1 / c.rates.SGD)
		case "KRW":
			return String(1 / c.rates.KRW)
		case "BRL":
			return String(1 / c.rates.BRL)
		case "USD":
			return "1"
		default:
			return "Not Found"
		}
	}
	
	
	
	func addCurrencies(){
		all.append(CMC(name: "USD", rank: "", symbol: "USD", price_usd: "1", percent_change_24h: ""))
		all.append(CMC(name: "AUD", rank: "", symbol: "AUD", price_usd: String(1 / c.rates.AUD), percent_change_24h: ""))
		all.append(CMC(name: "CAD", rank: "", symbol: "CAD", price_usd: String(1 / c.rates.CAD), percent_change_24h: ""))
		all.append(CMC(name: "CNY", rank: "", symbol: "CNY", price_usd: String(1 / c.rates.CNY), percent_change_24h: ""))
		all.append(CMC(name: "BRL", rank: "", symbol: "BRL", price_usd: String(1 / c.rates.BRL), percent_change_24h: ""))
		all.append(CMC(name: "KRW", rank: "", symbol: "KRW", price_usd: String(1 / c.rates.KRW), percent_change_24h: ""))
		all.append(CMC(name: "EUR", rank: "", symbol: "EUR", price_usd: String(1 / c.rates.EUR), percent_change_24h: ""))
		all.append(CMC(name: "GBP", rank: "", symbol: "GBP", price_usd: String(1 / c.rates.GBP), percent_change_24h: ""))
		all.append(CMC(name: "MXN", rank: "", symbol: "MXN", price_usd: String(1 / c.rates.MXN), percent_change_24h: ""))
		all.append(CMC(name: "JPY", rank: "", symbol: "JPY", price_usd: String(1 / c.rates.JPY), percent_change_24h: ""))
		all.append(CMC(name: "SGD", rank: "", symbol: "SGD", price_usd: String(1 / c.rates.SGD), percent_change_24h: ""))
	}
	
	
}
