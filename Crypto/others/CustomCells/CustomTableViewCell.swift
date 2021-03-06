//
//  CustomTableViewCell.swift
//  Crypto
//
//  Created by Robert Alexander on 12/28/17.
//  Copyright © 2017 Robert Alexander. All rights reserved.
//

import UIKit
protocol DoneDelagate : class {
    func pressdone(type: String, address: String, nick: String)
}
protocol CopiedDelagate: class {
	func showCopied()
}


class CustomTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

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
            if currNames.contains(cur.name!){
                cell.img.image = #imageLiteral(resourceName: "dollar")
            }
            else{
                cell.img.image = #imageLiteral(resourceName: "other")
            }
        }
        var num = Double(cur.amount!) ?? 0.0
        num = supper.cleanUp(num)
        let nFormat = supper.nF.string(from: NSNumber(value: num))
        cell.amount?.text =  nFormat! + " " + cur.name!
        
		cell.img.layer.minificationFilter = CALayerContentsFilter.trilinear
        cell.img.layer.minificationFilterBias = 0.03
        
        
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
    
    
    @IBOutlet var done: UIButton!
    
    
    @IBOutlet var neoButton: UIButton!
    @IBOutlet var xrpButton: UIButton!
    @IBOutlet var ltcButton: UIButton!
    @IBOutlet var ethButton: UIButton!
    @IBOutlet var btcButton: UIButton!
    @IBOutlet var eosButton: UIButton!
    var           buttons:[UIButton]!
   
    @IBOutlet var sub: UIView!
    
    @IBOutlet var imgg: UIImageView!
    
    
    @IBOutlet var lab: UILabel!
    
    
    @IBAction func neoPress(_ sender: Any) {
        imgg.image = #imageLiteral(resourceName: "NEO")
        lab.text = "NEO Public Key"
        extendAdd()
    }
    
    @IBAction func xrpPress(_ sender: Any) {
        imgg.image = #imageLiteral(resourceName: "XRP")
        lab.text = "XRP Public Key"
        extendAdd()
    }
    
    @IBAction func ltcPress(_ sender: Any) {
        imgg.image = #imageLiteral(resourceName: "LTC")
        lab.text = "LTC Public Key"
        extendAdd()
    }
    
    @IBAction func ethPress(_ sender: Any) {
        imgg.image = #imageLiteral(resourceName: "ETH")
        lab.text = "ETH Public Key"
        extendAdd()
    }
    
    @IBAction func btcPress(_ sender: Any) {
        imgg.image = #imageLiteral(resourceName: "BTC")
        lab.text = "BTC Public Key"
        extendAdd()
    }
    
    @IBAction func eosPress(_ sender: Any) {
        imgg.image = #imageLiteral(resourceName: "EOS")
        lab.text = "EOS Public Key"
        extendAdd()
    }
    
    @IBOutlet var address: UITextField!
    
    @IBOutlet var nickname: UITextField!
    
    func extendAdd(){
        let up = self.superview as! UITableView
        self.height.constant = self.height.constant + 45
        up.beginUpdates()
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.sub.alpha = 1
            if let loop = self.buttons{
                for i in loop{
                    i.alpha = 0
                }
            }
        })
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: { (_) in
            up.endUpdates()
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.imgg.alpha = 1
                self.lab.alpha = 1
                self.done.alpha = 1
                self.back.alpha = 1
                self.line.alpha = 1
                self.nickname.alpha = 1
                self.address.alpha = 1
                self.qr.alpha = 1
                
            })
        })
    }
    
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if (address.text?.isEmpty)!{
            UIView.animate(withDuration: 0.4, animations: {
                self.qr.alpha = 1
            })
        }
        else{
            UIView.animate(withDuration: 0.4, animations: {
                self.qr.alpha = 0
            })
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var bool = false
        if address.text != "" && nickname.text != ""{
            bool = true
        }


        if bool{
            done.isUserInteractionEnabled = true
            UIView.transition(with: done as UIView, duration: 0.24, options: .transitionCrossDissolve, animations: {
                self.done.setImage(UIImage(named: "done"), for:  .normal)
            })
        }
        else{
            done.isUserInteractionEnabled = false
            UIView.transition(with: done as UIView, duration: 0.1, options: .transitionCrossDissolve, animations: {
                self.done.setImage(UIImage(named: "undone"), for:  .normal)
            })
        }
    }

    
    
    
    @IBOutlet var back: UIButton!
    
    @IBAction func toBack(_ sender: Any) {
        let up = self.superview as! UITableView
        address.text = ""
        nickname.text = ""
        self.done.setImage(UIImage(named: "undone"), for: .normal)
        done.isUserInteractionEnabled = false
        address.resignFirstResponder()
        nickname.resignFirstResponder()
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
            self.imgg.alpha = 0
            self.lab.alpha = 0
            self.done.alpha = 0
            self.address.alpha = 0
            self.nickname.alpha = 0
            self.back.alpha = 0
            self.line.alpha = 0
            self.qr.alpha = 0
        }, completion: { (_) in
            up.beginUpdates()
            
            UIView.animate(withDuration: 0.1, delay: 0.3, options: .curveEaseOut, animations: {
                self.sub.alpha = 0
                if let loop = self.buttons{
                    for i in loop{
                        i.alpha = 1
                    }
                }
            })
            self.height.constant = self.height.constant - 45

            UIView.animate(withDuration: 0.3, delay: 0, options:  .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: { (_) in
                up.endUpdates()
                
            })
        })
    }
    
    weak var doneDelagate: DoneDelagate?
    @IBAction func toDone(_ sender: Any) {
        let txxt = lab.text!
        let id = txxt.index((txxt.startIndex), offsetBy: 3)
        let coinName = txxt.prefix(upTo: id)
        
        doneDelagate?.pressdone(type: String(coinName), address: address.text!, nick: nickname.text!)
    }
    
    
    @IBOutlet var line: UIView!
    @IBOutlet var qr: UIButton!
    
    @IBAction func qrTouch(_ sender: Any) {
        
        print("qr")
    }
	
	var addressText: String!
    var addBool = true
    @IBAction func touchAdd(_ sender: Any) {
        let up = self.superview as! UITableView
        if addBool{
            self.height.constant = self.height.constant + 80
            up.beginUpdates()
            bottomCons.isActive = true
            subBottom.isActive = false
            
            
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
                self.addCoin.alpha = 0
                
                
            }) { (_) in
                up.endUpdates()
                UIView.animate(withDuration: 0.3, animations: {
                    self.newAddress.alpha = 1
                    if let loop = self.buttons{
                        for i in loop{
                            i.alpha = 1
                        }
                    }
                })

            }
        }
        else{
            
            self.height.constant = self.ogheight
            up.beginUpdates()
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }) { (_) in
                self.imgg.alpha = 0
                self.lab.alpha = 0
                self.sub.alpha = 0
                self.line.alpha = 0
                self.back.alpha = 0
                self.done.alpha = 0
                self.qr.alpha = 0
                up.endUpdates()
                
                self.newAddress.alpha = 0
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
	
	func moreError(){
		moreIcon.setImage(UIImage(named: "moreError"), for: .normal)

	}

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
            
            UIView.transition(with: sender as UIView, duration: 0.4, options:  .transitionCrossDissolve, animations: {
                sender.setImage(UIImage(named: "moreI"), for:  .normal)
            }, completion: nil)
            
            subHeight.constant = subHeight.constant + CGFloat((cells.count - 1) * 44)
            UIView.animate(withDuration: 0.6, delay: 0, options:  .curveEaseOut, animations: {
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
            sub.removeFromSuperview()
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
	
	weak var copiedDelagate: CopiedDelagate?
	@objc func longTap(_ sender: UIGestureRecognizer){
		let up = self.superview as! UITableView
		if(sender.state == UIGestureRecognizer.State.began){
			if let tag = sender.view?.tag{
				let cell = up.cellForRow(at: IndexPath(row: tag, section: 0)) as! CustomTableViewCell
				
				UIPasteboard.general.string = cell.addressText!
				copiedDelagate?.showCopied()
			}
		}
	}
    
    var cells = [Cell]()
    
    @IBOutlet weak var subTable: UITableView!
    
    @IBOutlet var toMore: NSLayoutConstraint!
    
    @IBOutlet var toView: NSLayoutConstraint!
    
    var ogheight: CGFloat!
    override func awakeFromNib() {
        address.delegate = self
        nickname.delegate = self
        

        super.awakeFromNib()
        subTable.delegate = self
        subTable.dataSource = self
        self.layoutIfNeeded()
        bottomCons.isActive = false
        self.newAddress.font = UIFont(name: "STHeitiSC-Medium", size: 22.0)
        newAddress.font = newAddress.font.withSize(22)
        self.lab.font = UIFont(name: "STHeitiSC-Medium", size: 18.0)
        lab.font = lab.font.withSize(18)
        ogheight = 75
        sub.layer.cornerRadius = 10
        address.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
		
        buttons = [neoButton,eosButton, ltcButton, btcButton, ethButton, xrpButton]
	
		let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
		moreIcon.addGestureRecognizer(longGesture)
		cellView?.addGestureRecognizer(longGesture)
		cellView?.isUserInteractionEnabled = true

    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

