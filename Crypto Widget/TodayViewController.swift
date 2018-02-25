//
//  TodayViewController.swift
//  Crypto Widget
//
//  Created by Robert Alexander on 11/24/17.
//  Copyright © 2017 Robert Alexander. All rights reserved.
//

import UIKit
import NotificationCenter

struct CMC: Decodable{
    let name: String?
    let rank: String?
    let price_usd: String?
    let price_btc: String?
    let percent_change_24h: String?
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var user: [String?]!
    var coins: [CMC]!
    var prevPrice = [String?](repeatElement(nil, count: 10))
    var prevChange = [String?](repeatElement(nil, count: 10))
    var prices = [UILabel]()
    var names = [UILabel]()
    var changes = [UILabel]()
    var imgs = [UIView]()
    let disGroup = DispatchGroup()
    
    //this is the most disgusting this i have done in my life
    @IBOutlet weak var name0: UILabel!
    @IBOutlet weak var price0: UILabel!
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var price1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var price2: UILabel!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var price3: UILabel!
    @IBOutlet weak var name4: UILabel!
    @IBOutlet weak var price4: UILabel!
    @IBOutlet weak var name5: UILabel!
    @IBOutlet weak var price5: UILabel!
    @IBOutlet weak var name6: UILabel!
    @IBOutlet weak var price6: UILabel!
    @IBOutlet weak var name7: UILabel!
    @IBOutlet weak var price7: UILabel!
    @IBOutlet weak var name8: UILabel!
    @IBOutlet weak var price8: UILabel!
    @IBOutlet weak var name9: UILabel!
    @IBOutlet weak var price9: UILabel!
    @IBOutlet weak var change0: UILabel!
    @IBOutlet weak var change1: UILabel!
    @IBOutlet weak var change2: UILabel!
    @IBOutlet weak var change3: UILabel!
    @IBOutlet weak var change4: UILabel!
    @IBOutlet weak var change5: UILabel!
    @IBOutlet weak var change6: UILabel!
    @IBOutlet weak var change7: UILabel!
    @IBOutlet weak var change8: UILabel!
    @IBOutlet weak var change9: UILabel!
    
    @IBOutlet weak var img0: UIView!
    @IBOutlet weak var img1: UIView!
    @IBOutlet weak var img2: UIView!
    @IBOutlet weak var img3: UIView!
    @IBOutlet weak var img4: UIView!
    @IBOutlet weak var img5: UIView!
    @IBOutlet weak var img6: UIView!
    @IBOutlet weak var img7: UIView!
    @IBOutlet weak var img8: UIView!
    @IBOutlet weak var img9: UIView!
    
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var labl: UIButton!
    
    
    
    @IBAction func touch(_ sender: Any) {
        let myAppUrl = NSURL(string: "crypto://")!
        extensionContext?.open(myAppUrl as URL, completionHandler: { (success) in
            if (!success){print("ERROR")}
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if you look at this there is a reason
        //i started out a rough project hard code
        //but turned into real app and too lazy to change
        
        prices.append(price0);prices.append(price1);prices.append(price2);prices.append(price3);prices.append(price4)
        prices.append(price5);prices.append(price6);prices.append(price7);prices.append(price8);prices.append(price9)
        names.append(name0);names.append(name1);names.append(name2);names.append(name3);names.append(name4);
        names.append(name5);names.append(name6);names.append(name7);names.append(name8);names.append(name9);
        imgs.append(img0);imgs.append(img1);imgs.append(img2);imgs.append(img3);imgs.append(img4);
        imgs.append(img5);imgs.append(img6);imgs.append(img7);imgs.append(img8);imgs.append(img9);
        changes.append(change0);changes.append(change1);changes.append(change2);changes.append(change3);changes.append(change4);
        changes.append(change5);changes.append(change6);changes.append(change7);changes.append(change8);changes.append(change9);
        
        user = UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.array(forKey: "CCCoins") as? [String]
        if user == nil{
            for i in 0...9{
                changes[i].isHidden = true
                imgs[i].isHidden = true
                names[i].isHidden = true
                prices[i].isHidden = true
            }
            table.isHidden = true
        }
        else{

            self.labl.setTitle(" ", for: .application)
            self.labl.setTitle(" ", for: .disabled)
            self.labl.setTitle(" ", for: .focused)
            self.labl.setTitle(" ", for: .highlighted)
            self.labl.setTitle(" ", for: .normal)
            self.labl.setTitle(" ", for: .reserved)
            self.labl.setTitle(" ", for: .selected)
            
            prevPrice = UserDefaults().array(forKey: "prevPrice") as? [String] ?? prevPrice
            prevChange = UserDefaults().array(forKey: "prevChange") as? [String] ?? prevChange
            
            while prevPrice.count < 10{prevPrice.append(nil)}
            while prevChange.count < 10{prevChange.append(nil)}
            while user.count < 10{user.append(nil)}

            for i in 0...prices.count-1{
                if names[i].text != "--"{prices[i].text = self.prevPrice[i] ?? "--"}
                else{prices[i].text = "--"}
            }
            
            for i in 0...changes.count-1{
                imgs[i].layer.cornerRadius = 5
                names[i].text = self.user[i] ?? "--"
                if names[i].text != "--"{
                    changes[i].text = self.prevChange[i] ?? "0.0"
                    let d = changes[i].text!.startIndex
                    changes[i].text?.append("%")
                    
                    if changes[i].text![d] == "-"{imgs[i].backgroundColor = UIColor(named: "myRed")}
                    else if changes[i].text! == "0.0%"{}
                    else{
                        imgs[i].backgroundColor = UIColor(named: "myGreen");
                        changes[i].text!.insert("+", at: String.Index.init(encodedOffset: 0))
                    }
                    self.view.sendSubview(toBack: imgs[i])
                }
                else{changes[i].text = "--"}
            }
            while user[user.count-1] == nil{_ = user.popLast()}
            if user.count >= 4{extensionContext?.widgetLargestAvailableDisplayMode = .expanded}
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getCMC{(completion: [CMC]) in
            self.coins = completion
        }
        disGroup.notify(queue: .main){
            if self.user != nil{
                var price = [String?](repeatElement(nil, count: 10))
                var changes = [String?](repeatElement(nil, count: 10))
                for u in 0...self.user.count-1{
                    price[u] = (self.getPrice(name: self.user[u]!))
                    changes[u] = (self.getChange(name: self.user[u]!))
                }
                for i in 0...self.names.count-1{self.prices[i].text = price[i] ?? self.prices[i].text}
                for i in 0...self.user.count-1{
                    let checker:Double!
                    checker = (changes[i] == nil) ? ((self.prevChange[i] == nil) ? 0 : Double(self.prevChange[i]!)!) : Double(changes[i]!)!
                    var out = String(checker)
                    if checker > 0.0{
                        out.append("%")
                        out.insert("+", at: String.Index.init(encodedOffset: 0))
                        self.imgs[i].backgroundColor = UIColor(named: "myGreen")
                        self.changes[i].text = out
                    }
                    else if checker < 0.0{
                        out.append("%")
                        self.imgs[i].backgroundColor = UIColor(named: "myRed")
                        self.changes[i].text = out
                    }
                    else{
                        out.append("%")
                        self.changes[i].text = out
                    }
                }
                if !(self.allNil(array: changes)){
                    while changes[changes.count-1] == nil{_ = changes.popLast()}
                    UserDefaults.standard.set(changes, forKey: "prevChange")
                }
                if !(self.allNil(array: price)){
                    while price[price.count-1] == nil{_ = price.popLast()}
                    UserDefaults.standard.set(price, forKey: "prevPrice")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        getCMC{(completion: [CMC]) in
            self.coins = completion
        }
        disGroup.notify(queue: .main){
            if self.user != nil{
                var price = [String?](repeatElement(nil, count: 10))
                var changes = [String?](repeatElement(nil, count: 10))
                for u in 0...self.user.count-1{
                    price[u] = (self.getPrice(name: self.user[u]!))
                    changes[u] = (self.getChange(name: self.user[u]!))
                }
                for i in 0...self.names.count-1{self.prices[i].text = price[i] ?? self.prices[i].text}
                for i in 0...self.user.count-1{
                    let checker:Double!
                    checker = (changes[i] == nil) ? ((self.prevChange[i] == nil) ? 0 : Double(self.prevChange[i]!)!) : Double(changes[i]!)!
                    var out = String(checker)
                    if checker > 0.0{
                        out.append("%")
                        out.insert("+", at: String.Index.init(encodedOffset: 0))
                        self.imgs[i].backgroundColor = UIColor(named: "myGreen")
                        self.changes[i].text = out
                    }
                    else if checker < 0.0{
                        out.append("%")
                        self.imgs[i].backgroundColor = UIColor(named: "myRed")
                        self.changes[i].text = out
                    }
                    else{
                        out.append("%")
                        self.changes[i].text = out
                    }
                }
                if !(self.allNil(array: changes)){
                    while changes[changes.count-1] == nil{_ = changes.popLast()}
                    UserDefaults.standard.set(changes, forKey: "prevChange")
                }
                if !(self.allNil(array: price)){
                    while price[price.count-1] == nil{_ = price.popLast()}
                    UserDefaults.standard.set(price, forKey: "prevPrice")
                }
            }
        }
        completionHandler(NCUpdateResult.newData)
    }
    
    func allNil(array: [Any?]) -> Bool{
        var flag = true
        for i in array{
            if i != nil{flag = flag && false}
        }
        return flag
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        if let numCoins = user?.count{
            let h:CGFloat = CGFloat(27.2 * Float(numCoins))
            preferredContentSize = expanded ? CGSize(width: maxSize.width, height: h) : maxSize
        }
        else{preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 100) : maxSize}
    }
    
    func getCMC(completion: @escaping ([CMC]) -> ()){
        
        disGroup.enter()
        guard let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/?limit=0") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let coin = try JSONDecoder().decode([CMC].self, from: data)
                    
                    self.disGroup.leave()
                    completion(coin)
                } catch let jsonErr {print("Error serializing json:", jsonErr)}
            }
            }.resume()
    }
    
    func getPrice(name: String) -> String?{
        if self.coins != nil{
            for j in self.coins{
                if let i = j.name?.lowercased(){
                    if i == name.lowercased(){return j.price_usd!}
                }
            }
        }
        return nil
    }
    
    func getChange(name: String) -> String?{
        if self.coins != nil{
            for j in self.coins{
                if let i = j.name?.lowercased(){
                    if i == name.lowercased(){return j.percent_change_24h!}
                }
            }
        }
        return nil
    }
}
