//
//  CustomTableViewCell.swift
//  Crypto
//
//  Created by Robert Alexander on 12/28/17.
//  Copyright © 2017 Robert Alexander. All rights reserved.
//

import UIKit
protocol CustomTableViewCellDelegate {
    func tappedAddCoin(cell:CustomTableViewCell)
    func tappedMore(cell:CustomTableViewCell)
}

class CustomTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var bottomCons: NSLayoutConstraint!

    @IBOutlet var dropShadown: NSLayoutConstraint!
    
    @IBOutlet var subBottom: NSLayoutConstraint!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kk.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cc")
        cell.textLabel?.text = kk[indexPath.row]
        return cell
    }
    
    @IBOutlet weak var subHeight: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    @IBOutlet weak var cellView: UIView?
    
    @IBOutlet weak var imagee: UIImageView?
    
    @IBOutlet weak var money: UILabel?
    
    @IBOutlet weak var name: UILabel?
    
    @IBOutlet weak var tagg: UILabel?

    @IBOutlet weak var content: UIView!
    
    var addBool = true
    @IBAction func touchAdd(_ sender: Any) {
        let up = self.superview as! UITableView
        if addBool{
            self.height.constant = self.height.constant + 80
            up.beginUpdates()
            bottomCons.isActive = true
            subBottom.isActive = false
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.updateConstraints()
                self.layoutIfNeeded()
                self.addCoin.alpha = 0
            }) { (_) in
                up.endUpdates()

            }
        }
        else{
            self.height.constant = self.height.constant - 80
            up.beginUpdates()
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.updateConstraints()
                self.layoutIfNeeded()
                
                
            }) { (_) in
                up.endUpdates()
                self.bottomCons.isActive = false
                self.subBottom.isActive = true
                

            }
        }
        addBool = !addBool
    }
    
    
    @IBOutlet weak var moreIcon: UIButton!
    
    @IBOutlet weak var moreLabel: UILabel!
    
    @IBOutlet weak var addCoin: UIButton!
    
    var extended = true
    

    @IBAction func more(_ sender: Any) {
        let up = self.superview as! UITableView

        if extended{
            up.beginUpdates()
            subHeight.constant = subHeight.constant + CGFloat((kk.count - 1) * 45)
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: { (_) in
                up.endUpdates()
                self.dropShadown.constant = self.dropShadown.constant + 20
                UIView.animate(withDuration: 0.4, animations: {
                    self.layoutIfNeeded()
                })
            })
        }
        else{
            
            up.beginUpdates()
            subHeight.constant = subHeight.constant - CGFloat((kk.count - 1) * 45)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: { (_) in
                up.endUpdates()
                self.dropShadown.constant = self.dropShadown.constant - 20
                UIView.animate(withDuration: 0.4, animations: {
                    self.layoutIfNeeded()
                })
            })
        }
        
        extended = !extended
    }
    
    var kk = ["empty","-9","99","8","9"]
    
    @IBOutlet weak var subTable: UITableView!
    
    
    
    override func awakeFromNib() {
        

        super.awakeFromNib()
        subTable.delegate = self
        subTable.dataSource = self
//        self.subTable.alpha = 0
        
        self.layoutIfNeeded()
        
        bottomCons.isActive = false
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
