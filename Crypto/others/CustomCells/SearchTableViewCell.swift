//
//  SearchTableViewCell.swift
//  Crypto
//
//  Created by Robert Alexander on 1/24/18.
//  Copyright © 2018 Robert Alexander. All rights reserved.
//

import UIKit

protocol SearchCellDelegate {
    func addTouched(name: String)
}



class SearchTableViewCell: UITableViewCell {

    @IBOutlet var view: UIView!
    @IBOutlet var add: UIButton!
    @IBOutlet var rank: UILabel!
    @IBOutlet var lb: UILabel!

	var delegate: SearchCellDelegate?
    
    @IBAction func click(_ sender: Any) {
        delegate?.addTouched(name: lb.text!)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
//	let added = CCCoins.contains(cell.name.text!)

    
    

}
