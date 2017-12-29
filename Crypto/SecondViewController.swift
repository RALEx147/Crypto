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
    
    @IBAction func button(_ sender: Any) {
        UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.set(CCCoins, forKey: "CCCoins")
        
    }
    var CCCoins = [String]()
    var all = [CMC]()
    
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var lab: UILabel!
    @IBOutlet weak var search: UISearchBar!
    var im: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "bg")

        
        CCCoins = (UserDefaults(suiteName: "group.com.NavaDrag.Crypto")?.array(forKey: "CCCoins") as? [String] ?? [""])!
        
        Construct {(completion) in self.all = completion}
 
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //let words = searchBar.text
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func Construct(completion: @escaping ([CMC]) -> ()){
        let start = DispatchTime.now()
        guard let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/?limit=0") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let coin = try JSONDecoder().decode([CMC].self, from: data)
                    let end = DispatchTime.now()
                    print(end.uptimeNanoseconds - start.uptimeNanoseconds)
                    completion(coin)
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
            }.resume()
    }
    
    
}



