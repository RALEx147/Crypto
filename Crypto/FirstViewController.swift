//
//  FirstViewController.swift
//  Crypto
//
//  Created by Robert Alexander on 12/27/17.
//  Copyright © 2017 Robert Alexander. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import CommonCrypto
import Alamofire

let currNames = ["USD","AUS","CAD","CNY","JPY","MXN","SGD","GBP","EUR","KRW","BRL"]

class FirstViewController: UIViewController{
	@IBAction func debug(_ sender: Any) {
		
		
	}
	
	@IBOutlet weak var spacing: UIView!
	@IBOutlet weak var banner: UIImageView!
	@IBOutlet weak var table: UITableView!
	@IBOutlet weak var total: UILabel!
	
	var cellArray = [Cell]()
	var errorArray = [String]()
	var all:[CMC]!
	var c:currency!
	var impact = UIImpactFeedbackGenerator(style: .heavy)
	let nF:NumberFormatter = {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = NumberFormatter.Style.decimal
		return numberFormatter
	}()
	let disGroup = DispatchGroup()
	let disGroup2 = DispatchGroup()
	let disGroup3 = DispatchGroup()
	let constGroup = DispatchGroup()
	
	var loading = false
	let ani1 = LOTAnimationView(name: "1")
	let ani2 = LOTAnimationView(name: "2")
	let ani3 = LOTAnimationView(name: "3")
	let ani4 = LOTAnimationView(name: "4")
	
	override func viewDidLoad() {
		
		self.loadCells()
		
		setErrorArray()
		table.estimatedRowHeight = 130
		table.rowHeight = UITableView.automaticDimension
		self.total.font = UIFont(name: "STHeitiSC-Light", size: 50.0)
		total.font = total.font.withSize(50)
		let format = nF.string(from: NSNumber(value: cleanUp(totalPrice())))
		total.text = "$" + format!
		
		spacing.backgroundColor = UIColor(named: "bg")
		view.backgroundColor = UIColor(named: "bg")
		table.backgroundColor = UIColor(named: "bg")
		table.backgroundView?.backgroundColor = UIColor(named: "bg")
		
		addAddButton(on: addOn)
		setupRefresh()
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
			self.reload(self)
		}
		
		
		
	}
	
	func saveCells(){
		UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: cellArray), forKey: "cellArray")
		UserDefaults.standard.synchronize()
	}
	func loadCells(){
		if let key:NSData = (UserDefaults.standard.object(forKey: "cellArray") as? NSData) {
			cellArray = NSKeyedUnarchiver.unarchiveObject(with: (key as Data)) as! [Cell]
			
			for i in cellArray{
				if i.name == ""{
					if let index = cellArray.index(of: i) {
						cellArray.remove(at: index)
					}
				}
			}
		}
		
	}
	
	func totalPrice() -> Double{
		var out: Double = 0.0
		for i in cellArray.indices{
			if cellArray[i].subCells != nil && !(cellArray[i].subCells?.isEmpty)!{
				for j in cellArray[i].subCells!.indices{
					out += Double(cellArray[i].subCells![j].balance) ?? 0.0
				}
			}
			if let ss:Double = Double(cellArray[i].balance!){
				out += ss
			}
		}
		return out
	}
	
	var succeed = true
	@IBAction func reload(_ sender: Any) {
		if !Reachability.isConnectedToNetwork(){
			let alert = UIAlertController(title: "No Connection", message: "Please connect to the internet and refresh again", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in }))
			self.present(alert, animated: true, completion: nil)
			
		}
		else{
			if !loading{
				self.setErrorArray()
				self.table.reloadData()
				disGroup2.enter()
				loading = true
				self.ani3.setValue(UIColor.white, forKeypath: "end.Ellipse 1.Stroke 1.Color", atFrame: 0)
				self.ani4.setValue(UIColor.white, forKeypath: "2.Group 1.Stroke 1.Color", atFrame: 0)
				
				
				//Currency{(completion) in self.c = completion ?? self.c}
				
				var n = 1
				var out = [CMC]()
				while n < 1700{
					CMCc(n) { (con) in
						for i in con{
							out.append(i)
						}
					}
					n += 100
				}
				
				
				self.ani3.removeFromSuperview()
				self.ani4.removeFromSuperview()
				self.ani2.loopAnimation = true
				self.view.addSubview(self.ani1)
				ani1.translatesAutoresizingMaskIntoConstraints = false
				ani1.contentMode = .scaleToFill
				
				let ani1Lead = ani1.leadingAnchor.constraint(equalTo: self.banner.leadingAnchor)
				ani1Lead.constant = 11.5
				let ani1Bot = ani1.bottomAnchor.constraint(equalTo: self.banner.bottomAnchor)
				ani1Bot.constant = -3
				let ani1h = ani1.heightAnchor.constraint(equalToConstant: 45)
				let ani1w = ani1.widthAnchor.constraint(equalToConstant: 45)
				let cons1:[NSLayoutConstraint] = [ani1Lead, ani1Bot, ani1h, ani1w]
				NSLayoutConstraint.activate(cons1)
				self.view.layoutIfNeeded()
				self.ani1.play{ (finished) in
					self.ani1.removeFromSuperview()
					self.view.addSubview(self.ani2)
					
					self.ani2.translatesAutoresizingMaskIntoConstraints = false
					self.ani2.contentMode = .scaleToFill
					
					let ani2Lead = self.ani2.leadingAnchor.constraint(equalTo: self.banner.leadingAnchor)
					ani2Lead.constant = 11.5
					let ani2Bot = self.ani2.bottomAnchor.constraint(equalTo: self.banner.bottomAnchor)
					ani2Bot.constant = -3
					let ani2h = self.ani2.heightAnchor.constraint(equalToConstant: 45)
					let ani2w = self.ani2.widthAnchor.constraint(equalToConstant: 45)
					let cons2:[NSLayoutConstraint] = [ani2Lead, ani2Bot, ani2h, ani2w]
					NSLayoutConstraint.activate(cons2)
					self.view.layoutIfNeeded()
					self.ani2.play{ (finished) in
						self.ani2.removeFromSuperview()
						self.view.addSubview(self.self.ani3)
						
						self.ani3.translatesAutoresizingMaskIntoConstraints = false
						self.ani3.contentMode = .scaleToFill
						
						let ani3Lead = self.ani3.leadingAnchor.constraint(equalTo: self.banner.leadingAnchor)
						ani3Lead.constant = 11.5
						let ani3Bot = self.ani3.bottomAnchor.constraint(equalTo: self.banner.bottomAnchor)
						ani3Bot.constant = -3
						let ani3h = self.ani3.heightAnchor.constraint(equalToConstant: 45)
						let ani3w = self.ani3.widthAnchor.constraint(equalToConstant: 45)
						let cons3:[NSLayoutConstraint] = [ani3Lead, ani3Bot, ani3h, ani3w]
						NSLayoutConstraint.activate(cons3)
						self.view.layoutIfNeeded()
						self.ani3.play{ (finished) in
							self.view.addSubview(self.ani4)
							self.ani4.translatesAutoresizingMaskIntoConstraints = false
							self.ani4.contentMode = .scaleToFill
							let ani4Lead = self.ani4.leadingAnchor.constraint(equalTo: self.banner.leadingAnchor)
							ani4Lead.constant = 11.5
							let ani4Bot = self.ani4.bottomAnchor.constraint(equalTo: self.banner.bottomAnchor)
							ani4Bot.constant = -3
							let ani4h = self.ani4.heightAnchor.constraint(equalToConstant: 45)
							let ani4w = self.ani4.widthAnchor.constraint(equalToConstant: 45)
							let cons4:[NSLayoutConstraint] = [ani4Lead, ani4Bot, ani4h, ani4w]
							NSLayoutConstraint.activate(cons4)
							self.view.layoutIfNeeded()
							
							self.ani4.play{ (finished) in
								if !self.succeed{
									self.reloadFailed()
								}
								self.impact.impactOccurred()
								self.loading = false
								self.disGroup2.leave()
							}
						}
					}
				}
				constGroup.notify(queue: .main){
					self.all = self.sortPrice(out)
					print(self.all.last?.name)
					self.disGroup.notify(queue: .main){
						self.ani2.loopAnimation = false
					}
					print("setupcmc")
					for i in self.cellArray.indices{
						self.cellArray[i] = self.updateCell(self.cellArray[i],I:i)
					}
				}
				
				disGroup2.notify(queue: .main){
					for i in self.cellArray{
						i.updateMore()
					}
					self.table.reloadData()
					self.reloadSubTable()
					
					
					self.saveCells()
					let format = self.nF.string(from: NSNumber(value: self.cleanUp(self.totalPrice())))
					self.total.text = "$" + format!
				}
			}
		}
	}
	
	func updateCell(_ c: Cell, I:Int) -> Cell{
		succeed = true
		switch c.name.lowercased(){
		case "neo":
			updateNEOCell(c: c, I: I)
		case "eth":
			updateETHCell(c: c, I: I)
		case "ltc":
			updateLTCCell(c: c, I: I)
		case "binance":
			updateBNBCell(c: c, I: I)
		case "xrp":
			updateXRPCell(c: c, I: I)
		case "btc":
			updateBTCCell(c: c, I: I)
		default:
			break
		}
		c.updateMore()
		return c
	}
	
	
	func setErrorArray(){
		errorArray = [String]()
		for _ in cellArray{
			errorArray.append("no")
		}
	}
	
	
	
	func CMCc(_ num: Int, completion: @escaping ([CMC]) -> () ){
		
		self.constGroup.enter()
		var out = [CMC]()
		Alamofire.request("https://api.coinmarketcap.com/v2/ticker/?start=\(num)", method: .get).responseJSON {response in
			do {
				let output = try JSONDecoder().decode(CMCC.self, from: response.data!)
				
				
				for (_, data) in output.data{
					if let n = data.name, let r = data.rank, let p = data.quotes.USD.price, let p24 = data.quotes.USD.percent_change_24h, let s = data.symbol{
						let temp = CMC(name: n, rank: String(describing: r), symbol: s, price_usd: String(describing: p),  percent_change_24h: String(describing: p24))
						out.append(temp)
					}
				}
				self.constGroup.leave()
				completion(out)
			}
			catch{
				print("error: " , error)
				self.constGroup.leave()
			}
			
		}
	}
	
	
	
	
	
	
	func GenericAsync<T: Decodable>(_ c:Cell, completion: @escaping (T) -> ()){
		Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 20
		self.disGroup.enter()
		let type = Cryptos(rawValue: c.name.lowercased())
		let link = getLink(type!, c.address)
		guard let url = URL(string: link) else { return }
		Alamofire.request(url, method: .get).responseJSON {response in
			do {
				print("GenericAsync: " + String(describing: T.self))
				let balance = try JSONDecoder().decode(T.self, from: response.data!)
				self.disGroup.leave()
				
				completion(balance)
				
			} catch let jsonErr {
				print(String(describing: T.self),"Error serializing json:", jsonErr)
				self.disGroup.leave()
			}
		}
	}
	
	func getLink(_ coin: Cryptos,_ address: String) -> String{
		switch coin {
		case .btc:
			return "https://blockexplorer.com/api/addr/" + address
		case .eth:
			return "https://api.ethplorer.io/getAddressInfo/" + address + "?apiKey=freekey"
		case .ltc:
			return "https://chain.so/api/v2/get_address_balance/LTC/" + address
		case .neo:
			return "https://otcgo.cn/api/v1/balances/" + address
		case .xrp:
			return "https://data.ripple.com/v2/accounts/" + address + "/balances"
		case .eos:
			return ""
		}
	}
	
	
	
	
	
	
	enum Cryptos: String{
		case btc
		case eth
		case ltc
		case neo
		case xrp
		case eos
	}
	
	
	
	func sortPrice(_ out:[CMC]) -> [CMC]{
		var ourt = out
		ourt.sort(by: { (lhs: CMC, rhs: CMC) -> Bool in
			
			if let lhsTime = lhs.rank, let rhsTime = rhs.rank {
				return Int(lhsTime)! < Int(rhsTime)!
			}
			
			if lhs.rank == nil && rhs.rank == nil {
				// return true to stay at top
				return false
			}
			
			if lhs.rank == nil {
				// return true to stay at top
				return false
			}
			
			if rhs.rank == nil {
				// return false to stay at top
				return true
			}
			return false
		})
		return ourt
	}
	
	
	
	
	func getPrice(name: String) -> String{
		if self.all != nil{
			for j in self.all{
				let i = j.name?.lowercased()
				let k = j.symbol?.lowercased()
				if i == name.lowercased() || k == name.lowercased(){
					return j.price_usd!
				}
			}
		}
		return "Not Found"
	}
	func cleanUp(_ cash:Double) -> Double{
		var out = cash
		if out < 0.00001 && out >= 0.0{
			out = out.truncate(places: 5)
		}
		if out > 0.00001 && out < 1.0{
			out = out.truncate(places: 5)
		}
		else if out > 1.0 && out < 10.0{
			out = out.truncate(places: 4)
		}
		else if out > 10.0 && out < 100.0{
			out = out.truncate(places: 3)
		}
		else if out > 100.0 && out < 1000000{
			out = out.truncate(places: 2)
		}
		else if out > 1000000{
			out = out.truncate(places: 0)
		}
		return out
	}
	
	
	
	func reloadFailed(){
		ani3.setValue(UIColor(named: "failure")!, forKeypath: "end.Ellipse 1.Stroke 1.Color", atFrame: 0)
		self.ani4.setValue(UIColor(named: "failure")!, forKeypath: "2.Group 1.Stroke 1.Color", atFrame: 0)
		self.impact.impactOccurred()
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
			self.impact.impactOccurred()
		}
	}
	let bg = UIImageView(image: UIImage(named:"refresh"))
	func setupRefresh() {
		bg.frame.origin = CGPoint(x: 18, y: 180)
		self.view.addSubview(bg)
		ani1.frame = CGRect(x: 0, y: 173.5, width: 45, height: 45)
		ani2.frame = CGRect(x: 0, y: 173.5, width: 45, height: 45)
		ani3.frame = CGRect(x: 0, y: 173.5, width: 45, height: 45)
		ani4.frame = CGRect(x: 0, y: 173.5, width: 45, height: 45)
		let tap = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.reload))
		tap.numberOfTapsRequired = 1
		tap.numberOfTouchesRequired = 1
		let tap2 = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.reload))
		tap2.numberOfTapsRequired = 1
		tap2.numberOfTouchesRequired = 1
		ani1.addGestureRecognizer(tap)
		ani1.isUserInteractionEnabled = true
		ani4.addGestureRecognizer(tap2)
		ani4.isUserInteractionEnabled = true
		ani1.setValue(UIColor.white, forKeypath: "start.Ellipse 1.Stroke 1.Color", atFrame: 0)
		ani1.setValue(UIColor.white, forKeypath: "static 3.Ellipse 1.Stroke 1.Color", atFrame: 0)
		ani1.setValue(UIColor.white, forKeypath: "static4.Group 1.Stroke 1.Color", atFrame: 0)
		
		ani1.setValue(UIColor.white, forKeypath: "1.Group 1.Stroke 1.Color", atFrame: 0)
		ani2.setValue(UIColor.white, forKeypath: "middle.Ellipse 1.Stroke 1.Color", atFrame: 0)
		ani3.setValue(UIColor.white, forKeypath: "end.Ellipse 1.Stroke 1.Color", atFrame: 0)
		ani4.setValue(UIColor.white, forKeypath: "2.Group 1.Stroke 1.Color", atFrame: 0)
		self.view.addSubview(self.ani1)
		
		ani1.translatesAutoresizingMaskIntoConstraints = false
		ani1.contentMode = .scaleToFill
		bg.translatesAutoresizingMaskIntoConstraints = false
		bg.contentMode = .scaleToFill
		
		
		let bgLead = bg.leadingAnchor.constraint(equalTo: self.banner.leadingAnchor)
		bgLead.constant = 18
		let bgBot = bg.bottomAnchor.constraint(equalTo: self.banner.bottomAnchor)
		bgBot.constant = -10
		let bgh = bg.heightAnchor.constraint(equalToConstant: 31.5)
		let bgw = bg.widthAnchor.constraint(equalToConstant: 31.5)
		
		
		let ani1Lead = ani1.leadingAnchor.constraint(equalTo: self.banner.leadingAnchor)
		ani1Lead.constant = 11.5
		let ani1Bot = ani1.bottomAnchor.constraint(equalTo: self.banner.bottomAnchor)
		ani1Bot.constant = -3
		let ani1h = ani1.heightAnchor.constraint(equalToConstant: 45)
		let ani1w = ani1.widthAnchor.constraint(equalToConstant: 45)
		
		let cons:[NSLayoutConstraint] = [ani1Lead, ani1Bot, ani1h, ani1w, bgLead, bgBot, bgh, bgw]
		NSLayoutConstraint.activate(cons)
		self.view.layoutIfNeeded()
	}
	
	var addOn = false
	var add:LOTAnimationView?
	var addFrame = CGRect(x: 326, y: 181, width: 30, height: 30)
	func addAddButton(on: Bool){
		
		if add != nil {
			add?.removeFromSuperview()
			add = nil
		}
		let animation = on ? "add2" : "add1"
		add = LOTAnimationView(name: animation)
		add?.isUserInteractionEnabled = true
		add?.frame = addFrame
		
		add?.contentMode = .scaleAspectFill
		addAddGeus()
		self.view.addSubview(add!)
		
		
		add?.translatesAutoresizingMaskIntoConstraints = false
		add?.contentMode = .scaleToFill
		
		let trainlingAdd = add?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
		trainlingAdd?.constant = -18
		let bottomAdd = add?.bottomAnchor.constraint(equalTo: self.banner.bottomAnchor)
		bottomAdd?.constant = -10
		let h = add?.heightAnchor.constraint(equalToConstant: 30)
		let w = add?.widthAnchor.constraint(equalToConstant: 30)
		let cons:[NSLayoutConstraint] = [trainlingAdd!, bottomAdd!, h!, w!]
		NSLayoutConstraint.activate(cons)
		
	}
	func addAddGeus(){
		let tap = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.toggleMenu(recognizer:)))
		tap.numberOfTapsRequired = 1
		add?.addGestureRecognizer(tap)
	}
	@IBAction func toggleMenu (recognizer:UITapGestureRecognizer) {
		if !addOn {
			if showBool{
				self.showAdd()
				add?.play(completion: { (success:Bool) in
					self.addOn = true
					self.addAddButton(on: self.addOn)
				})
			}
		}else{
			if hideBool{
				self.hideAdd()
				add?.play(completion: { (success:Bool) in
					self.addOn = false
					self.addAddButton(on: self.addOn)
				})
			}
			
		}
	}
	func toggleMenuDelagate(){
		if !addOn {
			if showBool{
				self.showAdd()
				add?.play(completion: { (success:Bool) in
					self.addOn = true
					self.addAddButton(on: self.addOn)
				})
			}
		}else{
			if hideBool{
				self.hideAdd()
				add?.play(completion: { (success:Bool) in
					self.addOn = false
					self.addAddButton(on: self.addOn)
				})
			}
			
		}
	}
	
	func fadeMore(){
		let cells = self.table.visibleCells as! Array<CustomTableViewCell>
		for i in cells {
			i.moreLabel.alpha = 0
			i.moreIcon.alpha = 0
			i.toMore.isActive = false
			i.toView.isActive = true
		}
	}
	func defadeMore(){
		let cells = self.table.visibleCells as! Array<CustomTableViewCell>
		for i in cells {
			i.moreLabel.alpha = 1
			i.moreIcon.alpha = 1
			i.toMore.isActive = true
			i.toView.isActive = false
		}
	}
	func reloadSubTable() {
		let cells = self.table.visibleCells as! Array<CustomTableViewCell>
		for i in cells {
			i.subTable.reloadData()
		}
	}
	func reloadSubMore() {
		let cells = self.table.visibleCells as! Array<CustomTableViewCell>
		for i in cells {
			if !i.extended{
				i.more(i.moreIcon)
			}
		}
	}
	func showCopied(){
		let w:CGFloat = 150
		let h:CGFloat = 75
		let darkView = UIView(frame: CGRect(x: (view.frame.width / 2) - (w/2), y: (view.frame.height / 2) - (h/2), width: w, height: h))
		darkView.backgroundColor = .black
		darkView.alpha = 0
		darkView.layer.cornerRadius = 10
		view.addSubview(darkView)
		
		let copyLabel = UILabel(frame: CGRect(x: (view.frame.width / 2) - (w/2), y: (view.frame.height / 2) - (h/2), width: w, height: h))
		copyLabel.alpha = 0
		copyLabel.text = "Copied!"
		copyLabel.font = UIFont(name: "SF-Bold", size: UIFont.systemFontSize)
		copyLabel.textColor = .white
		copyLabel.textAlignment = .center
		view.addSubview(copyLabel)
		
		UIView.animate(withDuration: 0.1, animations: {
			darkView.alpha = 0.8
			copyLabel.alpha = 0.8
		}) { (_) in
			UIView.animate(withDuration: 0.2, delay: 0.8, animations: {
				darkView.alpha = 0
				copyLabel.alpha = 0
			}, completion: { (_) in
				darkView.removeFromSuperview()
				copyLabel.removeFromSuperview()
			})
		}
		
	}
	
	@IBOutlet var totalHeight: NSLayoutConstraint!
	@IBOutlet weak var bannerHeight: NSLayoutConstraint!
	var showBool = true
	var doneButtonTouched = false
	var becomeEdit = false
	var hideBool = true
	func showAdd(){
		
		showBool = false
		let superView = parent as! ViewController
		self.bannerHeight.constant = 100
		self.totalHeight.constant = 10
		superView.gradient.constant = 30
		
		//        table.reloadData()
		//        self.reloadSubTable()
		self.reloadSubMore()
		self.reloadSubTable()
		self.reloadSubMore()
		becomeEdit = true
		UIView.animate(withDuration: 0.3, delay: 0.08, options: .curveEaseOut, animations: {
			let head = self.table.tableHeaderView
			head?.frame = CGRect(x: (head?.frame.origin.x)!, y: (head?.frame.origin.y)!, width: (head?.frame.width)!, height: (head?.frame.height)! - 5)
			self.view.layoutIfNeeded()
			superView.view.layoutIfNeeded()
			superView.icon.frame.origin.y = -39
			superView.icon.alpha = 0
			superView.halo.frame.origin.y = -29
			superView.halo.alpha = 0
			superView.top?.frame.origin.y = -30
			superView.top?.alpha = 0
			
			superView.profileImage.frame.origin.y = -30
			superView.profileImage.alpha = 0
			
			self.add?.frame.origin.y = 60
			self.total.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
			self.bg.frame.origin.y = 59
			self.ani1.frame.origin.y = 52
			self.ani2.frame.origin.y = 52
			self.ani3.frame.origin.y = 52
			self.ani4.frame.origin.y = 52
			self.addFrame.origin.y = 60
			self.fadeMore()
		}, completion: ({ (end) in
			self.add?.frame.origin.y = 60
			let add = Cell(name: "", tag: "", amount: "", price: "", balance: "", address: "", subCells: [Cell]())
			self.cellArray.insert(add, at: 0)
			self.errorArray.insert("no", at: 0)
			
			self.table.performBatchUpdates({
				self.table.isEditing = true
				self.table.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
			}) { (_) in self.table.reloadData()
				self.showBool = true
				
			}
		}))
		
		
	}
	func hideAdd(){
		hideBool = false
		let superView = parent as! ViewController
		
		
		
		
		self.cellArray.remove(at: 0)
		self.errorArray.remove(at: 0)
		let indx = IndexPath(row: 0, section: 0)
		let x = self.table.cellForRow(at: indx) as! CustomTableViewCell
		becomeEdit = false
		
		self.table.performBatchUpdates({
			table.isEditing = false
			self.table.deleteRows(at: [indx], with: .fade)
		}) { (_) in
			UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
				let head = self.table.tableHeaderView
				head?.frame = CGRect(x: (head?.frame.origin.x)!, y: (head?.frame.origin.y)!, width: (head?.frame.width)!, height: (head?.frame.height)! + 5)
				self.bannerHeight.constant = 223
				self.totalHeight.constant = 28.5
				superView.gradient.constant = 98
				self.view.layoutIfNeeded()
				superView.icon.frame.origin.y = 39
				superView.icon.alpha = 1
				superView.halo.frame.origin.y = 29
				superView.halo.alpha = 1
				superView.top?.frame.origin.y = 30
				superView.top?.alpha = 1
				superView.profileImage?.frame.origin.y = 30
				superView.profileImage.alpha = 1
				self.total.transform = CGAffineTransform(scaleX: 1, y: 1)
				self.bg.frame.origin.y = 180
				self.ani1.frame.origin.y = 173.5
				self.ani2.frame.origin.y = 173.5
				self.ani3.frame.origin.y = 173.5
				self.ani4.frame.origin.y = 173.5
				self.add?.frame.origin.y = 181
				self.addFrame.origin.y = 181
				self.defadeMore()
				
				
				
			}, completion: ({ (end) in
				//                self.table.reloadData()
				self.hideBool = true
				if end{
					DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
						
						if !x.addBool{
							x.height.constant = 75
							x.updateConstraints()
							x.layoutIfNeeded()
							x.newAddress.alpha = 0
							x.ltcButton.alpha = 0
							x.btcButton.alpha = 0
							x.neoButton.alpha = 0
							x.xrpButton.alpha = 0
							x.ethButton.alpha = 0
							x.eosButton.alpha = 0
							x.sub.alpha = 0
							x.lab.alpha = 0
							x.imgg.alpha = 0
							x.line.alpha = 0
							x.done.alpha = 0
							x.back.alpha = 0
							x.address.alpha = 0
							x.nickname.alpha = 0
							x.qr.alpha = 0
							x.addCoin.alpha = 1
							x.address.text = ""
							x.nickname.text = ""
							x.done.setImage(UIImage(named: "undone"), for: .normal)
							x.done.isUserInteractionEnabled = false
							x.bottomCons.isActive = false
							x.subBottom.isActive = true
							x.addBool = !x.addBool
							//                            for i in self.cellArray{
							//                                i.updateMore()
							//                            }
							//                            self.table.reloadData()
							//                            self.reloadSubTable()
							
						}
						
					}
				}
			}))
		}
		
		
		
		
		
	}
	
}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource, DoneDelagate, CopiedDelagate {
	
	fileprivate func addCleanAddress(_ type: String, _ nick: String, _ cleanAddress: String) {
		self.toggleMenuDelagate()
		let add = Cell(name: type, tag: nick, amount: "0.0", price: "0.0", balance: "0.0", address: cleanAddress, subCells: [Cell]())
		self.errorArray.insert("no", at: 0)
		self.cellArray.insert(add, at: 0)
		self.table.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
		self.saveCells()
		self.reload(self)
	}
	
	func isLTCAddress(_ cleanAddress: String) -> Bool
	{return cleanAddress.count == 34 && cleanAddress.isBase58 && cleanAddress[cleanAddress.startIndex] == "3" || cleanAddress[cleanAddress.startIndex] == "L" || cleanAddress[cleanAddress.startIndex] == "M"}
	
	func isBTCAddress(_ cleanAddress: String) -> Bool
	{return cleanAddress.count >= 25 && cleanAddress.count <= 34 && cleanAddress.isBase58 && cleanAddress[cleanAddress.startIndex] == "1"}
	
	func isNEOAddress(_ cleanAddress: String) -> Bool
	{return cleanAddress.count == 34 && cleanAddress.isBase58 && cleanAddress[cleanAddress.startIndex] == "A"}
	
	func isXRPAddress(_ cleanAddress: String) -> Bool
	{return cleanAddress.count >= 25 && cleanAddress.count <= 35 && cleanAddress.isBase58 && cleanAddress[cleanAddress.startIndex] == "r"}
	
	func isETHAddress(_ cleanAddress: String) -> Bool
	{return cleanAddress.count == 42 && String(cleanAddress[cleanAddress.index(cleanAddress.startIndex, offsetBy: 2)...]).isEthHash && String(cleanAddress[..<cleanAddress.index(cleanAddress.startIndex, offsetBy: 2)]) == "0x"}
	

	func pressdone(type: String, address: String, nick: String) {
		
		if !doneButtonTouched{
			doneButtonTouched = true
			switch type{
			case "BTC":
				self.doneButtonTouched = false
				let cleanAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
				if isBTCAddress(cleanAddress){
					addCleanAddress(type, nick, cleanAddress)
				}
				else{print("fail")}
			case "ETH":
				self.doneButtonTouched = false
				let cleanAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
				if isETHAddress(cleanAddress){
					addCleanAddress(type, nick, cleanAddress)
				}
				else{print("fail")}
			case "XRP":
				self.doneButtonTouched = false
				let cleanAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
				if isXRPAddress(cleanAddress){
					addCleanAddress(type, nick, cleanAddress)
				}
				else{print("fail")}
			case "NEO":
				self.doneButtonTouched = false
				let cleanAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
				if isNEOAddress(cleanAddress){
					addCleanAddress(type, nick, cleanAddress)
				}
				else{print("fail")}
			case "LTC":
				self.doneButtonTouched = false
				let cleanAddress = address.trimmingCharacters(in: .whitespacesAndNewlines)
				if isLTCAddress(cleanAddress){
					addCleanAddress(type, nick, cleanAddress)
				}
				else{print("fail")}
			default:
				break
			}
		}
	}
	
	
	func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
		if (proposedDestinationIndexPath.row == 0) {
			return IndexPath(row: 1, section: proposedDestinationIndexPath.section)
		}
		return proposedDestinationIndexPath
	}
	
	
	
	
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		tableView.backgroundColor = UIColor(named: "bg")
		cell.contentView.backgroundColor = UIColor(named: "bg")
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cellArray.count
	}
	
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = table.dequeueReusableCell(withIdentifier: "cell2") as! CustomTableViewCell
		let cur = self.cellArray[indexPath.row]
		let errorCheck = self.errorArray[indexPath.row]
		cell.cellView?.layer.cornerRadius = 10
		cell.name?.text = cur.tag
		cell.moreIcon.tag = indexPath.row
		cell.addressText = cur.address
		cell.imgg.layer.minificationFilter = CALayerContentsFilter.trilinear
		cell.imgg.layer.minificationFilterBias = 0.03
		if cur.name != "BINANCE"{
			cell.tagg?.text = cur.name + ": " + cur.address
		}
		else{
			cell.tagg?.text = cur.name
		}
		if cur.address == ""{
			cell.tagg?.text = ""
			cell.money?.text = ""
			cell.moreLabel.text = ""
			cell.addCoin.setImage(#imageLiteral(resourceName: "addCoin"), for: .normal)
			cell.addCoin.isUserInteractionEnabled = true
			cell.moreIcon.alpha = 0
		}
		else{
			
			var cash = Double(cur.balance!) ?? 0.0
			cell.imagee?.image = UIImage(named: cur.name!)
			let more = cur.more!
			
			cell.addCoin.setImage(UIImage(), for: .normal)
			cell.moreIcon.isUserInteractionEnabled = true
			cell.addCoin.isUserInteractionEnabled = false
			cell.moreLabel?.text = ""
			if Int(more) != nil && Int(more)! > 0{
				cell.moreLabel?.text = more + " more"
				for i in cur.subCells!{
					cash += Double(i.balance!) ?? 0.0
				}
			}
			
			if errorCheck == "yes"{
				cell.moreIcon.setImage(UIImage(named:"moreError"), for: .normal)
			}
			else{
				cell.moreIcon.setImage(UIImage(named:"more"), for: .normal)
			}
			
			cash = cleanUp(cash)
			let format = nF.string(from: NSNumber(value: cash))
			cell.money?.text = "$" + format!
			let placeholder = Cell(name: "", tag: "", amount: "", price: "", balance: "", address: "", subCells: [Cell]())
			cell.cells = [placeholder]
			if cur.more.count > 0{
				if cur.name != "BINANCE"{
					cell.cells.append(cur)
				}
				for i in 0..<Int(cur.more)!{
					cell.cells.append(cur.subCells![i])
				}
				
			}
			cell.subTable.separatorColor = UIColor(named: "bg")
			
		}
		cell.subTable.layer.cornerRadius = 10
		if cell.extended{
			cell.subTable.frame = CGRect(x: cell.subTable.frame.origin.x, y: cell.subTable.frame.origin.y, width: cell.subTable.frame.width, height: cell.subTable.frame.width)
		}
		else{
			cell.subTable.frame = CGRect(x: cell.subTable.frame.origin.x, y: cell.subTable.frame.origin.y, width: cell.subTable.frame.width, height: 45)
		}
		cell.doneDelagate = self
		cell.copiedDelagate = self
		cell.layoutIfNeeded()
		return cell
	}
	
	func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		if becomeEdit{
			return indexPath.row != 0
		}
		else{
			return false
		}
	}
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		if becomeEdit{
			return indexPath.row != 0
		}
		else{
			return false
		}
		
		
	}
	
	
	
	
	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		if destinationIndexPath.row != 0 {
			let movedObject = self.cellArray[sourceIndexPath.row]
			let movedObject2 = self.errorArray[sourceIndexPath.row]
			self.cellArray.remove(at: sourceIndexPath.row)
			self.cellArray.insert(movedObject, at: destinationIndexPath.row)
			self.errorArray.remove(at: sourceIndexPath.row)
			self.errorArray.insert(movedObject2, at: destinationIndexPath.row)
			self.saveCells()
			NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(cellArray)")
			// To check for correctness enable: self.tableView.reloadData()
		}
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			print("Deleted")
			
			self.cellArray.remove(at: indexPath.row)
			self.errorArray.remove(at: indexPath.row)
			self.table.deleteRows(at: [indexPath], with: .automatic)
			self.saveCells()
		}
	}
	
	
}
extension String {
	func hmac(base64key key: String) -> String {
		let algorithm = CCHmacAlgorithm(kCCHmacAlgSHA256)
		let keyLength = key.lengthOfBytes(using: .utf8)
		let messageLength = self.lengthOfBytes(using: .utf8)
		let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
		
		var output = [UInt8](repeating: 0, count: digestLength)
		
		key.withCString { keyPtr in
			self.withCString { messagePtr in
				CCHmac(algorithm, keyPtr, keyLength, messagePtr, messageLength, &output)
			}
		}
		
		let result = output.map { b in String(format: "%02x", b) }.joined()
		return result
	}
	var isBase58: Bool {
		let allowed = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
		let characterSet = CharacterSet(charactersIn: allowed)
		guard rangeOfCharacter(from: characterSet.inverted) == nil else {
			return false
		}
		return true
	}
	var isEthHash: Bool {
		let allowed = "abcdefABCDEF0123456789"
		let characterSet = CharacterSet(charactersIn: allowed)
		guard rangeOfCharacter(from: characterSet.inverted) == nil else {
			return false
		}
		return true
	}
}
extension Double{
	func truncate(places : Int)-> Double{
		return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
		
	}
}
class NeverClearView: UIView {
	override var backgroundColor: UIColor? {
		didSet {
			if backgroundColor?.cgColor.alpha == 0 {
				backgroundColor = oldValue
			}
		}
	}
}
