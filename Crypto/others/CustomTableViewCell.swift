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
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let supper = FirstViewController()
        let cell = subTable.dequeueReusableCell(withIdentifier: "subCell") as! SubTableViewCell
        let cur = cells[indexPath.row]
        
        
//        cell.price.text = "$" + supper.getPrice(name: cur.name)
//        cell.price.text =
//
//        cell.amount.text = String(describing: supper.cleanUp(Double(cur.amount) ?? 0.0))
        
        
        var cash = Double(cur.balance!) ?? 0.0
        cash = supper.cleanUp(cash)
        let format = supper.nF.string(from: NSNumber(value: cash))
        cell.total?.text = "$" + format!
        
        
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
                UIView.animate(withDuration: 0.3, animations: {
                    self.newAddress.alpha = 1
                })

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
                self.addCoin.alpha = 1
                self.bottomCons.isActive = false
                self.subBottom.isActive = true
            }
        }
        addBool = !addBool
    }
    
    
    @IBOutlet weak var moreIcon: UIButton!
    
    @IBOutlet weak var moreLabel: UILabel!
    
    @IBOutlet weak var addCoin: UIButton!
    
    @IBOutlet var newAddress: UILabel!
    var extended = true
    

    @IBAction func more(_ sender: Any) {
        let up = self.superview as! UITableView
        print(num)
        if extended{
            up.beginUpdates()
            subHeight.constant = subHeight.constant + CGFloat((cells.count - 2) * 43 + 45)
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
            subHeight.constant = subHeight.constant - CGFloat((cells.count - 2) * 43 + 45)
            
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
    
    var cells = [Cell]()
    
    @IBOutlet weak var subTable: UITableView!
    
    
    var num = 0
    override func awakeFromNib() {
        

        super.awakeFromNib()
        subTable.delegate = self
        subTable.dataSource = self
//        self.subTable.alpha = 0
//        var end:String.Index!
//
//        if let str = moreLabel.text{
//            if str.count > 0{
//                end = str.index(str.startIndex, offsetBy: 1)
//                self.num = Int(str[str.startIndex..<end])!
//            }
//
//        }
//        for _ in 0...num{
//            kk.append("placeholder")
//        }
        
        self.layoutIfNeeded()
        
        bottomCons.isActive = false
        
            self.newAddress.font = UIFont(name: "STHeitiSC-Medium", size: 22.0)
        newAddress.font = newAddress.font.withSize(22)
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
