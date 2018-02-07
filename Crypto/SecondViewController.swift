//
//  SecondViewController.swift
//  Kucoin
//
//  Created by Robert Alexander on 10/28/17.
//  Copyright © 2017 Robert Alexander. All rights reserved.
//

import UIKit
import Lottie

class SecondViewController: UIViewController, UISearchBarDelegate {
    
    
    
    var CCCoins = [String]()
    var all = [CMC]()
    var blurView: UIVisualEffectView!
    var showArray = [CMC]()
    let bgView = UIView()
    let disGroup3 = DispatchGroup()
    let refreshControl = UIRefreshControl()

    @IBOutlet var search: UISearchBar!
    @IBOutlet var table: UITableView!
    @IBOutlet var add: UIButton!
    @IBOutlet var lbl: UILabel!
    @IBOutlet var ddd: NSLayoutConstraint!
    @IBOutlet weak var banner: UIImageView!

    @IBOutlet var searchTable: UITableView!
    
    
    
    
    
    
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
        
        
        
        

        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //let words = searchBar.text
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: {
            self.search.alpha = 0
            self.blurView.alpha = 0
            self.bgView.alpha = 0
            self.searchTable.alpha = 0
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showArray = all.filter { (cmc) -> Bool in
            return (cmc.name?.lowercased().contains(searchText.lowercased()))!
        }
    }
    
    
    
    @objc func refresh(){
        Construct {(completion) in self.all = completion ?? self.all}
        
        disGroup3.notify(queue: .main){
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                self.refreshControl.endRefreshing()
                self.table.reloadData()
            }
            
        }
    }
    
    func save(){UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.set(CCCoins, forKey: "CCCoins")}
    func load() {CCCoins = (UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.array(forKey: "CCCoins") as? [String] ?? [])!}

    
    func Construct(completion: @escaping ([CMC]?) -> ()){
        self.disGroup3.enter()
        
        var done = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
            if !done{
                self.disGroup3.leave()
                completion(nil)
            }
        }
        guard let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/?limit=0") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    
                    let coin = try JSONDecoder().decode([CMC].self, from: data)
                    
                    print("cmc")
                    self.disGroup3.leave()
                    done = true
                    completion(coin)
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
            }.resume()
    }
    
    func getPrice(_ name: String) -> String{
        for j in self.all{
            let i = j.name?.lowercased()
            let k = j.symbol?.lowercased()
            if i == name.lowercased() || k == name.lowercased(){
                return j.price_usd!
            }
        }
        return "Error"
    }
    
    func getChange(_ name: String) -> String{
        for j in self.all{
            let i = j.name?.lowercased()
            let k = j.symbol?.lowercased()
            if i == name.lowercased() || k == name.lowercased(){
                return j.percent_change_24h!
            }
        }
        return "Error"
    }
    
    @IBOutlet var bannerHeight: NSLayoutConstraint!
    func color(_ name:String) -> Bool{
        let change = getChange(name)
        let letter = change[change.startIndex]
        let out = (letter == "-") ? false : true
        return out
    }
    
    
    @IBAction func addCoin(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.search.alpha = 1
            self.blurView.alpha = 0.9
            self.bgView.alpha = 0.5
            self.searchTable.alpha = 1
        })
        
        showArray.append(all[1])
        showArray.append(all[12])
        showArray.append(all[5])

        
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
        search.clipsToBounds = true
        search.layer.cornerRadius = 16
        
        
        search.backgroundImage = #imageLiteral(resourceName: "Background")
        view.backgroundColor = UIColor(named: "bg")
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(named: "pink")!], for: .normal)
        
        
        
        self.view.addSubview(blurView)
        self.view.addSubview(bgView)
        self.view.bringSubview(toFront: searchTable)
        self.view.bringSubview(toFront: search)

    }
    
    func setupRefresh() {
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = UIColor(named: "loading")
        
        
        Construct {(completion) in self.all = completion ?? self.all}
        disGroup3.notify(queue: .main){
            self.table.reloadData()
        }
    }
    
    
    
    
    
}



extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.table{
            return CCCoins.count
        }
        else if tableView == self.searchTable{
            return showArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.table{
        let cell = table.dequeueReusableCell(withIdentifier: "cellprice") as! PriceTableViewCell
        let name = self.CCCoins[indexPath.row]
        cell.cellView.layer.cornerRadius = 8
        cell.color.layer.cornerRadius = 7
        cell.name.text = name
        cell.price.text = getPrice(name)
        cell.change.text = getChange(name) + "%"
        
        let clr = color(name) ? UIColor(named: "myGreen") : UIColor(named: "myRed")
        cell.color.backgroundColor = clr
            return cell

        }
        else if tableView == self.searchTable{
            let cell = searchTable.dequeueReusableCell(withIdentifier: "cell") as! SearchTableViewCell
            return cell

        }
        return UITableViewCell()

    }
    
}

func seconds(_ ns: UInt64){
    print(Double(ns)/Double(truncating: pow(10,9) as NSNumber))
}

