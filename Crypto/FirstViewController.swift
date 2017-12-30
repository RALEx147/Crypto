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


class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var content = [[[(String, String)]]]()
    
    @IBOutlet weak var spacing: UIView!
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.backgroundColor = UIColor(named: "bg")
        cell.contentView.backgroundColor = UIColor(named: "bg")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return cellArray.count
        
    }
    

    var edit = false
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell2") as! CustomTableViewCell
        let cur = self.cellArray[indexPath.row]
        cell.cellView?.layer.cornerRadius = 10
        cell.name?.text = cur.name
        cell.tagg?.text = cur.tag
        if cur.name == ""{
            cell.money?.text = ""
            cell.moreLabel.text = ""
            
            cell.addCoin.setImage(#imageLiteral(resourceName: "addCoin"), for: .normal)
            cell.addCoin.isUserInteractionEnabled = true
            cell.moreIcon.isUserInteractionEnabled = false
        }
        else{
            var cash = Double(cur.balance)!
            cell.imagee?.image = UIImage(named: cur.name)
            cell.moreIcon.imageView?.image = #imageLiteral(resourceName: "more")
            cell.moreIcon.setImage(#imageLiteral(resourceName: "more"), for: .normal)
            let more = cur.more!
            cell.addCoin.setImage(UIImage(), for: .normal)
            cell.moreIcon.isUserInteractionEnabled = true
            cell.addCoin.isUserInteractionEnabled = false
            cell.moreLabel?.text = more
            if Int(more) != nil {
                cell.moreLabel?.text = more + " more"
                for i in cur.subCells{
                    cash += Double(i.balance)!
                }
            }
            cash = cleanUp(cash)
            cell.money?.text = "$" + String(cash)
        }
        cell.subTable.layer.cornerRadius = 10
        if cell.extended{
            cell.subTable.frame = CGRect(x: cell.subTable.frame.origin.x, y: cell.subTable.frame.origin.y, width: cell.subTable.frame.width, height: cell.subTable.frame.width)
        }
        else{
            cell.subTable.frame = CGRect(x: cell.subTable.frame.origin.x, y: cell.subTable.frame.origin.y, width: cell.subTable.frame.width, height: 45)
        }
        return cell
    }
    func cleanUp(_ cash:Double) -> Double{
        var out = cash
        if out < 1.0 && out >= 0.0{
            out = out.truncate(places: 5)
        }
        else if out > 1.0 && out < 10.0{
            out = out.truncate(places: 4)
        }
        else if out > 10.0 && out < 100.0{
            out = out.truncate(places: 3)
        }
        else if out > 100.0{
            out = out.truncate(places: 2)
        }
        return out
    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = table.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
    //        let array = Array(self.keys)
    //        print(array)
    //        cell.cellView?.layer.cornerRadius = 10
    //
    //        if array[indexPath.row].key == "neo"{
    //            cell.name?.text = "NEO"
    //            cell.imagee?.image = #imageLiteral(resourceName: "NEO")
    //            cell.tagg?.text = array[indexPath.row].value
    //            self.disGroup2.notify(queue: .main){
    //
    //
    //                cell.money?.text = "$" + String(describing: self.neoTotal()!.truncate(places: 2))
    //            }
    //
    //
    //        }
    //        else if array[indexPath.row].key == "eth"{
    //            cell.name?.text = "Ethereum"
    //            cell.tagg?.text = array[indexPath.row].value
    //            cell.imagee?.image = #imageLiteral(resourceName: "ETH")
    //            disGroup2.notify(queue: .main){
    //                let outt = String(describing: self.ethTotal()!.truncate(places: 2))
    //                cell.money?.text = "$" + outt
    //            }
    //            cell.moreLabel.text = ""
    //
    //        }
    //        else if array[indexPath.row].key == "zADDCOIN"{
    //            cell.name?.text = ""
    //            cell.tagg?.text = ""
    //            cell.imagee?.image = UIImage()
    //            cell.money?.text = ""
    //            cell.moreIcon.imageView?.image = UIImage()
    //            cell.moreLabel.text = ""
    //        }
    //        else{
    //            cell.name?.text = "Error"
    //            cell.imagee?.image = #imageLiteral(resourceName: "halo")
    //        }
    //
    //        return cell
    //    }
    
    @IBOutlet weak var banner: UIImageView!
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var total: UILabel!
    var keys = [String: String]()
    var all:[CMC]!
    var neo:[NEO]!
    var eth:ETH!
    var impact = UIImpactFeedbackGenerator(style: .heavy)
    let disGroup = DispatchGroup()
    let disGroup2 = DispatchGroup()
    var loading = false
    var cellArray = [cells]()
    
    let ani1 = LOTAnimationView(name: "1")
    let ani2 = LOTAnimationView(name: "2")
    let ani3 = LOTAnimationView(name: "3")
    let ani4 = LOTAnimationView(name: "4")
    
    override func viewDidLoad() {
        disGroup2.enter()
        keys["neo"] = "AX7zArzdTweY8MoDRozgriR7vTQWsaU3yW"
        keys["eth"] = "0x345d1c8c4657c4BF228c0a9c247649Ea533B5D87"
        
        self.total.font = UIFont(name: "STHeitiSC-Light", size: 50.0)
        total.font = total.font.withSize(50)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let format = numberFormatter.string(from: NSNumber(value:UserDefaults.standard.double(forKey: "total")))
        total.text = "$" + format!
        
        spacing.backgroundColor = UIColor(named: "bg")
        view.backgroundColor = UIColor(named: "bg")
        table.backgroundColor = UIColor(named: "bg")
        table.backgroundView?.backgroundColor = UIColor(named: "bg")
        
        addAddButton(on: addOn)
        setupRefresh()
        
    }
    
    
    @IBAction func reload(_ sender: Any) {
        if !loading{
            loading = true
            self.ani3.setValue(UIColor.white, forKeypath: "end.Ellipse 1.Stroke 1.Color", atFrame: 0)
            self.ani4.setValue(UIColor.white, forKeypath: "2.Group 1.Stroke 1.Color", atFrame: 0)
            Construct{(completion) in self.all = completion}
            neoBalance{(completion) in self.neo = completion}
            ethBalance{(completion) in self.eth = completion}
            
            
            
            self.ani3.removeFromSuperview()
            self.ani4.removeFromSuperview()
            self.ani2.loopAnimation = true
            self.view.addSubview(self.ani1)
            self.ani1.play{ (finished) in
                self.ani1.removeFromSuperview()
                self.view.addSubview(self.ani2)
                self.ani2.play{ (finished) in
                    self.ani2.removeFromSuperview()
                    self.view.addSubview(self.ani3)
                    self.ani3.play{ (finished) in
                        self.view.addSubview(self.ani4)
                        self.ani4.play{ (finished) in
                            if self.all == nil || self.all.isEmpty || self.neo.isEmpty || self.neo == nil || self.eth == nil{
                                self.unfinished()
                            }
                            else{
                                let n = self.neoTotal() ?? 0.0
                                let e = self.ethTotal() ?? 0.0
                                let cash = n.truncate(places: 2) + e.truncate(places: 2)
                                UserDefaults().set(cash, forKey: "total")
                                self.total.text = "$" + String(cash)
                            }
                            self.impact.impactOccurred()
                            self.loading = false
                            self.disGroup2.leave()
                        }
                    }
                }
            }
            
            disGroup.notify(queue: .main){
                self.ani2.loopAnimation = false
            }
            
            disGroup2.notify(queue: .main){
                var rCell:rpxCell?
                var gCell:gasCell?
                var nCell:neoCell?
                var eCell:ethCell?
                
                eCell = ethCell(t: self.keys["eth"]!, m: "", a: (String(describing: self.ethTotal(trueValue: true)!)), b: String(describing: self.ethTotal()!))
                for i in self.neo{
                    if i.name == "RPX"{
                        
                        rCell = rpxCell(a: i.total!, b: (String(i.price_usd!)))
                    }
                    if i.name == "GAS"{
                        
                        gCell = gasCell(a: i.total!, b: (String(i.price_usd!)))
                    }
                }
                for i in self.neo{
                    if i.name == "NEO"{
                        
                        nCell = neoCell(t: self.keys["neo"]!, m: "2", a: i.total! , b: (String(i.price_usd!)), r: rCell, g: gCell)
                    }
                }
                
                self.cellArray.append(nCell!)
                self.cellArray.append(eCell!)
                self.table.reloadData()
            }
        }
    }
    
    
    func unfinished(){
        ani3.setValue(UIColor.red, forKeypath: "end.Ellipse 1.Stroke 1.Color", atFrame: 0)
        self.ani4.setValue(UIColor.red, forKeypath: "2.Group 1.Stroke 1.Color", atFrame: 0)
        self.impact.impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.impact.impactOccurred()
        }
    }
    func Construct(completion: @escaping ([CMC]?) -> ()){
        self.disGroup.enter()
        let start = DispatchTime.now()
        var done = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
            if !done{
                self.self.disGroup.leave()
                completion(nil)
            }
        }
        guard let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/?limit=0") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    
                    let coin = try JSONDecoder().decode([CMC].self, from: data)
                    let end = DispatchTime.now()
                    print("cmc")
                    print(end.uptimeNanoseconds - start.uptimeNanoseconds)
                    self.disGroup.leave()
                    done = true
                    completion(coin)
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
            }.resume()
    }
    
    func neoBalance(completion: @escaping ([NEO]) -> ()){
        self.disGroup.enter()
        var done = false
        let start = DispatchTime.now()
        let link = "https://otcgo.cn/api/v1/balances/" + self.keys["neo"]!
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
            if !done{
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
                        if (i.name == "RPX" || i.name == "NEO" || i.name == "GAS") {
                            output.append(i)
                        }
                    }
                    let end = DispatchTime.now()
                    print("neo")
                    print(end.uptimeNanoseconds - start.uptimeNanoseconds)
                    self.disGroup.leave()
                    done = true
                    completion(output)
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
            }.resume()
    }
    
    func neoTotal() -> Double?{
        if neo != nil && !neo.isEmpty  && !all.isEmpty && all != nil{
            for i in 0...neo.count-1{
                if let amount = Double(neo[i].total!){
                    if neo[i].name == "NEO"{
                        if let price = Double(self.getPrice(name: "NEO")){neo[i].price_usd = (amount * price)}}
                    else if neo[i].name == "GAS"{
                        if let price = Double(self.getPrice(name: "Gas")){neo[i].price_usd = (amount * price)}}
                    else if neo[i].name == "RPX"{
                        if let price = Double(self.getPrice(name: "Red Pulse")){neo[i].price_usd = (amount * price)}
                    }
                }
            }
            var output = 0.0
            for i in neo{
                output += i.price_usd ?? 0
            }
            return output
        }
        else{return nil}
    }
    
    func ethBalance(completion: @escaping (ETH) -> ()){
        let start = DispatchTime.now()
        self.disGroup.enter()
        var done = false
        let link = "https://api.etherscan.io/api?module=account&action=balance&address=" + self.keys["eth"]!
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
            if !done{
                self.disGroup.leave()
                completion(ETH(result: nil))
            }
        }
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    
                    let balance = try JSONDecoder().decode(ETH.self, from: data)
                    let end = DispatchTime.now()
                    print("eth")
                    print(end.uptimeNanoseconds - start.uptimeNanoseconds)
                    self.disGroup.leave()
                    done = true
                    
                    completion(balance)
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
            }.resume()
    }
    
    func ethTotal(trueValue: Bool = false) -> Double?{
        if eth != nil && all != nil && !all.isEmpty{
            let divisor = 1000000000000000000.0
            let realValue = Double(self.eth.result!)! / divisor
            if trueValue{
                return realValue
            }
            else{
                let output = realValue * Double(self.getPrice(name: "ethereum"))!
                return output
            }
        }
        else{return nil}
    }
    
    func getPrice(name: String) -> String{
        for j in self.all{
            let i = j.name?.lowercased()
            if i == name.lowercased(){
                return j.price_usd!
            }
        }
        return "Not Found"
    }
    
    
    
    
    
    let bg = UIImageView(image: UIImage(named:"refresh"))
    
    
    func setupRefresh() {
        bg.frame.origin = CGPoint(x: 18, y: 180)
        self.view.addSubview(bg)
        ani1.frame = CGRect(x: 11.5, y: 173.5, width: 45, height: 45)
        ani2.frame = CGRect(x: 11.5, y: 173.5, width: 45, height: 45)
        ani3.frame = CGRect(x: 11.5, y: 173.5, width: 45, height: 45)
        ani4.frame = CGRect(x: 11.5, y: 173.5, width: 45, height: 45)
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
    }
    func addAddGeus(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.toggleMenu(recognizer:)))
        tap.numberOfTapsRequired = 1
        add?.addGestureRecognizer(tap)
    }
    @IBAction func toggleMenu (recognizer:UITapGestureRecognizer) {
        if !addOn {
            self.showAdd()
            add?.play(completion: { (success:Bool) in
                self.addOn = true
                self.editing()
                self.addAddButton(on: self.addOn)
            })
        }else{
            self.hideAdd()
            add?.play(completion: { (success:Bool) in
                self.addOn = false
                self.addAddButton(on: self.addOn)
            })
        }
    }
    
    func editing(){
        edit = true
        
    }
    
    
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    func showAdd(){
        let superView = parent as! ViewController
        self.bannerHeight.constant = 100
        self.totalHeight.constant = 15
        superView.gradient.constant = 30
        UIView.animate(withDuration: 0.3, delay: 0.08, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            superView.view.layoutIfNeeded()
            superView.icon.frame.origin.y = -39
            superView.icon.alpha = 0
            superView.halo.frame.origin.y = -29
            superView.halo.alpha = 0
            superView.top?.frame.origin.y = -30
            superView.top?.alpha = 0
            self.add?.frame.origin.y = 60
            self.total.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.bg.frame.origin.y = 60
            self.ani1.frame.origin.y = 53.5
            self.ani2.frame.origin.y = 53.5
            self.ani3.frame.origin.y = 53.5
            self.ani4.frame.origin.y = 53.5
            self.addFrame.origin.y = 60
        }, completion: ({ (end) in
            self.add?.frame.origin.y = 60
            let add = addCoin()
            self.cellArray.append(add)
            self.table.beginUpdates()
            self.table.insertRows(at: [IndexPath(row: self.cellArray.count-1, section: 0)], with: .automatic)
            self.table.endUpdates()

        }))
        
        
    }
    @IBOutlet weak var totalHeight: NSLayoutConstraint!
    func hideAdd(){
        let superView = parent as! ViewController
        self.bannerHeight.constant = 223
        self.totalHeight.constant = 85
        superView.gradient.constant = 98
        UIView.animate(withDuration: 0.3, delay: 0.08, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            superView.view.layoutIfNeeded()
            superView.icon.frame.origin.y = 39
            superView.icon.alpha = 1
            superView.halo.frame.origin.y = 29
            superView.halo.alpha = 1
            superView.top?.frame.origin.y = 30
            superView.top?.alpha = 1
            self.total.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.bg.frame.origin.y = 180
            self.ani1.frame.origin.y = 173.5
            self.ani2.frame.origin.y = 173.5
            self.ani3.frame.origin.y = 173.5
            self.ani4.frame.origin.y = 173.5
            self.add?.frame.origin.y = 181
            self.addFrame.origin.y = 181
            self.cellArray.remove(at: self.cellArray.count-1)
            self.table.reloadData()
        }, completion: ({ (end) in }))
    }
    
    
}

extension Double{func truncate(places : Int)-> Double{return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))}}
