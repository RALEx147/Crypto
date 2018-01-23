//
//  PriceTableViewCell.swift
//  Crypto
//
//  Created by Robert Alexander on 1/22/18.
//  Copyright © 2018 Robert Alexander. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var cellView: UIView!
    @IBOutlet var color: UIView!
    @IBOutlet var change: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.name.font = UIFont(name: "STHeitiSC-Light", size: 16.0)
        name.font = name.font.withSize(16)
        self.price.font = UIFont(name: "STHeitiSC-Light", size: 16.0)
        price.font = price.font.withSize(16)
        self.change.font = UIFont(name: "STHeitiSC-Light", size: 18.0)
        change.font = change.font.withSize(18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
