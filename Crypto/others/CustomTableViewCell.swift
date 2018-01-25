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
        
        
        var p =  Double(cur.price!) ?? 0.0
        p = supper.cleanUp(p)
        let pFormat = supper.nF.string(from: NSNumber(value: p))
        cell.price.text = "$" + pFormat!
        if let i = UIImage(named: cur.name!){
            cell.img.image = i
        }
        else{
            cell.img.image = #imageLiteral(resourceName: "other")
        }
        var num = Double(cur.amount!) ?? 0.0
        num = supper.cleanUp(num)
        let nFormat = supper.nF.string(from: NSNumber(value: num))
        cell.amount?.text =  nFormat! + " " + cur.name!
        
        
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
    
    
    
    
    @IBOutlet var neoButton: UIButton!
    @IBOutlet var xrpButton: UIButton!
    @IBOutlet var ltcButton: UIButton!
    @IBOutlet var ethButton: UIButton!
    @IBOutlet var btcButton: UIButton!
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
                    self.ltcButton.alpha = 1
                    self.btcButton.alpha = 1
                    self.ethButton.alpha = 1
                    self.neoButton.alpha = 1
                    self.xrpButton.alpha = 1
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
    

    @IBAction func more(_ sender: UIButton) {
        let up = self.superview as! UITableView
        
        if extended{
            for i in (up.visibleCells as! Array<CustomTableViewCell>){
                if !i.extended{
                    i.more(i.moreIcon)
                }
            }
            print()
            up.beginUpdates()
            
            UIView.transition(with: sender as UIView, duration: 0.4, options: .transitionCrossDissolve, animations: {
                sender.setImage(UIImage(named: "moreI"), for: .normal)
            }, completion: nil)
            
            subHeight.constant = subHeight.constant + CGFloat((cells.count - 1) * 44)
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: { (_) in
                up.endUpdates()
                self.dropShadown.constant = self.dropShadown.constant + 20
                UIView.animate(withDuration: 0.4, animations: {
                    self.layoutIfNeeded()
                }, completion: { (_) in
                    self.subTable.reloadData()
                })
            })
        }
        else{
            
            up.beginUpdates()
            subHeight.constant = subHeight.constant - CGFloat(Float(cells.count - 1) * 44)
            
            UIView.transition(with: sender as UIView, duration: 0.4, options: .transitionCrossDissolve, animations: {
                sender.setImage(UIImage(named: "more"), for: .normal)
            }, completion: nil)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: { (_) in
                up.endUpdates()
                self.dropShadown.constant = self.dropShadown.constant - 20
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.layoutIfNeeded()
                }, completion: { (_) in
                    self.subTable.reloadData()
                })
            })
            
            
        }
        
        extended = !extended
    }
    
    var cells = [Cell]()
    
    @IBOutlet weak var subTable: UITableView!
    
    @IBOutlet var toMore: NSLayoutConstraint!
    
    @IBOutlet var toView: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        

        super.awakeFromNib()
        subTable.delegate = self
        subTable.dataSource = self
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
