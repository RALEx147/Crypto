//
//  SecondViewController.swift
//  Kucoin
//
//  Created by Robert Alexander on 10/28/17.
//  Copyright © 2017 Robert Alexander. v.all rights reserved.
//

import UIKit
import Lottie
import Alamofire


class SecondViewController: UIViewController, ContDelegate {
    func updateArray(name: String) {
        if !CCCoins.contains(name){
            CCCoins.append(name)
            CCPrice.append("0.0")
            CCChange.append("0.0%")
            CCColor.append("green")
            delaget()
            save()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
                self.v.search.text = ""
                self.v.search.resignFirstResponder()
                self.table.performBatchUpdates({
                    self.table.insertRows(at: [IndexPath(row: self.CCCoins.count-1, section: 0)], with: .fade)
                }) { (_) in self.table.reloadData()}
            }
            
        }
    }
    
    
    
    
    var CCCoins = [String]()
    var CCPrice = [String]()
    var CCChange = [String]()
    var CCColor = [String]()
    var blurView: UIVisualEffectView!
    let bgView = UIView()
    let constGroup = DispatchGroup()
    let refreshControl = UIRefreshControl()
    
    @IBOutlet var table: UITableView!
    @IBOutlet var add: UIButton!
    @IBOutlet var lbl: UILabel!
    @IBOutlet var ddd: NSLayoutConstraint!
    @IBOutlet weak var banner: UIImageView!
    
    
    @IBOutlet var textversion: UITextField!
    
    @IBOutlet var cont: UIView!
    
    
    
    
    fileprivate func setupLbl() {
        self.lbl.font = UIFont(name: "STHeitiSC-Medium", size: 30.0)
        lbl.font = lbl.font.withSize(30)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        ddd.constant -= 6
        
        setupSearch()
        setupConstr()
        setupRefresh()
        setupLbl()
        load()
        //        save()
        
        self.v.delag = self
        
        
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //let words = searchBar.text
        
    }
    
    func delaget(){
        UIView.animate(withDuration: 0.3, delay: 0.3, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.v.search.alpha = 0
            self.blurView.alpha = 0
            self.bgView.alpha = 0
            self.v.searchTable.alpha = 0
            self.textversion.alpha = 0
            self.cont.isUserInteractionEnabled = false
            
        })
    }
    
    
    
    
    @objc func refresh(){
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
        constGroup.notify(queue: .main){
            out.sort(by: { (lhs: CMC, rhs: CMC) -> Bool in
                
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
            self.v.all = out
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                self.refreshControl.endRefreshing()
                self.table.reloadData()
            }
        }
        
    }
    
    func save(){
        UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.set(CCCoins, forKey: "CCCoins")
        UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.set(CCPrice, forKey: "CCPrice")
        UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.set(CCChange, forKey: "CCChange")
        UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.set(CCColor, forKey: "CCColor")
        
        
    }
    func load() {
        CCCoins = (UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.array(forKey: "CCCoins") as? [String] ?? [])!
        CCPrice = (UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.array(forKey: "CCPrice") as? [String] ?? [])!
        CCChange = (UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.array(forKey: "CCChange") as? [String] ?? [])!
        CCColor = (UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.array(forKey: "CCColor") as? [String] ?? [])!
        
    }
    
    
    typealias CMCallBack = (_ result: [CMC]) -> Void
    func CMCc(_ num: Int, completion: @escaping CMCallBack){
        
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
    
    
    func getPrice(_ name: String) -> String{
        for j in self.v.all{
            let i = j.name?.lowercased()
            let k = j.symbol?.lowercased()
            if i == name.lowercased() || k == name.lowercased(){
                return j.price_usd!
            }
        }
        return "Error"
    }
    
    func getChange(_ name: String) -> String{
        for j in self.v.all{
            let i = j.name?.lowercased()
            let k = j.symbol?.lowercased()
            if i == name.lowercased() || k == name.lowercased(){
                return j.percent_change_24h!
            }
        }
        return "Error"
    }
    
    @IBOutlet var bannerHeight: NSLayoutConstraint!
    //true is green
    func color(_ name:String) -> Bool{
        let change = getChange(name)
        let letter = change[change.startIndex]
        
        return (letter == "-") ? false : true
    }
    
    
    var v:SearchViewController!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "vv"{
            v = segue.destination as? SearchViewController
        }
        
    }
    
    @IBAction func addCoin(_ sender: Any) {
        if !self.v.all.isEmpty{
            UIView.animate(withDuration: 0.3, animations: {
                
                self.v.search.alpha = 1
                self.blurView.alpha = 0.9
                self.bgView.alpha = 0.5
                self.v.searchTable.alpha = 1
                self.textversion.alpha = 1
                self.cont.isUserInteractionEnabled = true
                self.v.searchTable.reloadData()
            })
            
        }
    }
    func setupConstr() {
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.contentMode = .scaleToFill
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.contentMode = .scaleToFill
        
        let blurViewCenterX = blurView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let blurViewTrailing = blurView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        blurViewTrailing.constant = -10
        let blurViewLeading = blurView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        blurViewLeading.constant = 10
        let blurViewBottom = blurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        blurViewBottom.constant = -10
        let blurViewBanner = blurView.topAnchor.constraint(equalTo: self.banner.bottomAnchor)
        blurViewBanner.constant = 10
        
        let bgViewCenterX = bgView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let bgViewTrailing = bgView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        bgViewTrailing.constant = -10
        let bgViewLeading = bgView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        bgViewLeading.constant = 10
        let bgViewBottom = bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        bgViewBottom.constant = -10
        let bgViewBanner = bgView.topAnchor.constraint(equalTo: self.banner.bottomAnchor)
        bgViewBanner.constant = 10
        
        
        let cons:[NSLayoutConstraint] = [blurViewCenterX, blurViewTrailing, blurViewLeading, blurViewBottom, blurViewBanner, bgViewCenterX, bgViewTrailing, bgViewLeading, bgViewBottom, bgViewBanner]
        NSLayoutConstraint.activate(cons)
        
        
        self.view.layoutIfNeeded()
    }
    func setupSearch() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        blurView = UIVisualEffectView(effect: blurEffect)
        bgView.backgroundColor = .white
        bgView.alpha = 0
        blurView.alpha = 0
        
        blurView.clipsToBounds = true
        bgView.clipsToBounds = true
        blurView.layer.cornerRadius = 19
        bgView.layer.cornerRadius = 19
        view.backgroundColor = UIColor(named: "bg")
        
        
        
        
        self.view.addSubview(blurView)
        self.view.addSubview(bgView)
        self.view.bringSubviewToFront(self.cont)
        
    }
    
    func setupRefresh() {
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(named: "loading")
        
        
        
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
        constGroup.notify(queue: .main){
            
            out.sort(by: { (lhs: CMC, rhs: CMC) -> Bool in
                
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
            self.v.all = out
            
            self.table.reloadData()
            
        }
        
        
    }
    
    
    
    
    
}



extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CCCoins.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cellprice") as! PriceTableViewCell
        let name = self.CCCoins[indexPath.row]
        cell.cellView.layer.cornerRadius = 8
        cell.color.layer.cornerRadius = 7
        cell.name.text = name
        cell.price.text = getPrice(name)
        cell.change.text = getChange(name) + "%"
        let clr = color(name) ? UIColor(named: "myGreen") : UIColor(named: "myRed")
        cell.color.backgroundColor = clr
        
        if cell.price.text == "Error"{
            cell.price.text = self.CCPrice[indexPath.row]
            cell.change.text = self.CCChange[indexPath.row]
            cell.color.backgroundColor = (self.CCColor[indexPath.row] == "green") ? UIColor(named: "myGreen") : UIColor(named: "myRed")
        }
        else{
            CCPrice[indexPath.row] = getPrice(name)
            CCChange[indexPath.row] = getChange(name) + "%"
            CCColor[indexPath.row] = color(name) ? "green" : "red"
            save()
        }
        
        return cell
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            self.CCCoins.remove(at: indexPath.row)
            self.CCChange.remove(at: indexPath.row)
            self.CCColor.remove(at: indexPath.row)
            self.CCPrice.remove(at: indexPath.row)
            
            self.table.deleteRows(at: [indexPath], with: .automatic)
            self.save()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.table.dataSource?.tableView!(self.table, commit: .delete, forRowAt: indexPath)
            return
        })
        
        deleteButton.backgroundColor = UIColor(named: "pink")
        
        return [deleteButton]
    }
    
}

func seconds(_ ns: UInt64){
    print(Double(ns)/Double(truncating: pow(10,9) as NSNumber))
}

