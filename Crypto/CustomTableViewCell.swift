//
//  CustomTableViewCell.swift
//  Crypto
//
//  Created by Robert Alexander on 12/28/17.
//  Copyright © 2017 Robert Alexander. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kk.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cc")
        cell.textLabel?.text = kk[indexPath.row]
        return cell
    }
    

    @IBOutlet weak var cellView: UIView?
    
    @IBOutlet weak var imagee: UIImageView?
    
    @IBOutlet weak var money: UILabel?
    
    @IBOutlet weak var name: UILabel?
    
    @IBOutlet weak var tagg: UILabel?

    @IBOutlet weak var content: UIView!
    
    @IBAction func touchAdd(_ sender: Any) {
        print("Sdfdsfdsf")
    }
    @IBOutlet weak var moreIcon: UIButton!
    
    @IBOutlet weak var moreLabel: UILabel!
    
    @IBOutlet weak var addCoin: UIButton!
    
    @IBAction func more(_ sender: Any) {
        
        extended = extended ? false : true
        
    }
    
    var kk = ["empty","-9","99","8","9"]
    
    @IBOutlet weak var subTable: UITableView!
    
    
    var extended = false
    override func awakeFromNib() {
        super.awakeFromNib()
        subTable.delegate = self
        subTable.dataSource = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
