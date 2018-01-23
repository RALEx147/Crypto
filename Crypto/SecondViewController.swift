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
    
    
    func save(){UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.set(CCCoins, forKey: "CCCoins")}
    
    var CCCoins = [String]()
    var all = [CMC]()
    
    
    @IBOutlet var table: UITableView!
    @IBOutlet var add: UIButton!
    @IBOutlet weak var banner: UIImageView!
    let disGroup3 = DispatchGroup()
    private let refreshControl = UIRefreshControl()

    @IBAction func addCoin(_ sender: Any) {
        print(CCCoins.count)
        table.reloadData()
    }
    @IBOutlet var lbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg")

        
        self.lbl.font = UIFont(name: "STHeitiSC-Medium", size: 30.0)
        lbl.font = lbl.font.withSize(30)
        
        CCCoins = (UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.array(forKey: "CCCoins") as? [String] ?? [])!
        
        
        
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = UIColor(named: "loading")

        
        Construct {(completion) in self.all = completion!}
        disGroup3.notify(queue: .main){
            self.table.reloadData()
        }
        
 
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //let words = searchBar.text
        
    }
    @objc func refresh(){
        Construct {(completion) in self.all = completion!}
        

        disGroup3.notify(queue: .main){
            
            self.refreshControl.endRefreshing()
            self.table.reloadData()
        }
    }
    
    
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
    
    func color(_ name:String) -> Bool{
        let change = getChange(name)
        let letter = change[change.startIndex]
        let out = (letter == "-") ? false : true
        return out
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

        return cell
    }
    
}

func seconds(_ ns: UInt64){
    print(Double(ns)/Double(truncating: pow(10,9) as NSNumber))
}

