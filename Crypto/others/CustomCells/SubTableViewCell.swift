//
//  SubTableViewCell.swift
//  Crypto
//
//  Created by Robert Alexander on 1/5/18.
//  Copyright © 2018 Robert Alexander. All rights reserved.
//

import UIKit

class SubTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        

        
        
    }
    @IBOutlet var amount: UILabel!
    
    @IBOutlet var img: UIImageView!
    @IBOutlet var total: UILabel!
    @IBOutlet var price: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
