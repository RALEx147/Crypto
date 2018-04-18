//
//  SearchViewController.swift
//  Crypto
//
//  Created by Robert Alexander on 2/13/18.
//  Copyright © 2018 Robert Alexander. All rights reserved.
//

import Foundation
import UIKit

protocol ContDelegate {
    func updateArray(name: String)
}





class SearchViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating, SearchCellDelegate{
    

    
    func updateSearchResults(for searchController: UISearchController) {
        searchTable.reloadData()
    }
    
    
    
    
    @IBOutlet var searchTable: UITableView!
    
    @IBOutlet var search: UISearchBar!
    var all = [CMC]()
    var showArray = [CMC]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        
        search.clipsToBounds = true
        search.layer.cornerRadius = 16
        searchTable.layer.cornerRadius = 10
        let head = self.searchTable.tableHeaderView
        head?.frame = CGRect(x: (head?.frame.origin.x)!, y: (head?.frame.origin.y)!, width: (head?.frame.width)!, height: (head?.frame.height)! + 28)
        

        
        search.backgroundImage = #imageLiteral(resourceName: "Background")
        self.view.bringSubview(toFront: searchTable)
        self.view.bringSubview(toFront: search)
         UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor(named: "pink")!], for: .normal)
        
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let superv = parent as! SecondViewController
        self.search.text = ""
        superv.delaget()//!!!WTF
    }

    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        search.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search.endEditing(true)
        searchTable.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let superv = parent as! SecondViewController
        
        showArray = all.filter { (cmc) -> Bool in
            return ((cmc.name?.lowercased().contains(searchText.lowercased()))! ||   (cmc.symbol?.lowercased().contains(searchText.lowercased()))! )
            
        }
        searchTable.reloadData()
    }
    
    var delag: ContDelegate?
    func addTouched(name: String) {
        delag?.updateArray(name: name)

    }
    
}




extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.search.text == "" ? all.count : showArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = searchTable.dequeueReusableCell(withIdentifier: "cell") as! SearchTableViewCell
        cell.lb.text = self.search.text == "" ? all[indexPath.row].name : showArray[indexPath.row].name
        cell.rank.text = self.search.text == "" ? all[indexPath.row].rank : showArray[indexPath.row].rank
        cell.rank.text?.insert("#", at: (cell.rank.text?.startIndex)!)
        cell.view.layer.cornerRadius = 7
        cell.delegate = self
        

        return cell
        
        
    }
    
}

