//
//  FirstViewController.swift
//  Crypto
//
//  Created by Robert Alexander on 12/27/17.
//  Copyright © 2017 Robert Alexander. All rights reserved.
//

import Foundation
import UIKit
import Lottie


class FirstViewController: UIViewController{
    
    
    @IBOutlet weak var spacing: UIView!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var total: UILabel!
    var keys = [String: String]()
    var all:[CMC]!
    var impact = UIImpactFeedbackGenerator(style: .heavy)
    let disGroup = DispatchGroup()
    let disGroup2 = DispatchGroup()
    var loading = false
    var cellArray = [Cell]()
    
    let ani1 = LOTAnimationView(name: "1")
    let ani2 = LOTAnimationView(name: "2")
    let ani3 = LOTAnimationView(name: "3")
    let ani4 = LOTAnimationView(name: "4")
    
    
    let nF:NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter
    }()
    
    override func viewDidLoad() {
        self.loadCells()

        table.estimatedRowHeight = 130
        table.rowHeight = UITableViewAutomaticDimension
        self.total.font = UIFont(name: "STHeitiSC-Light", size: 50.0)
        total.font = total.font.withSize(50)
        let format = nF.string(from: NSNumber(value: cleanUp(totalPrice())))
        total.text = "$" + format!
        
        spacing.backgroundColor = UIColor(named: "bg")
        view.backgroundColor = UIColor(named: "bg")
        table.backgroundColor = UIColor(named: "bg")
        table.backgroundView?.backgroundColor = UIColor(named: "bg")
        
        addAddButton(on: addOn)
        setupRefresh()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.reload(self)
        }
        
        
    }
    
    func totalPrice() -> Double{
        var out: Double = 0.0
        for i in cellArray.indices{
            if cellArray[i].subCells != nil && !(cellArray[i].subCells?.isEmpty)!{
                for j in cellArray[i].subCells!.indices{
                    out += Double(cellArray[i].subCells![j].balance) ?? 0.0
                }
            }
            if let ss:Double = Double(cellArray[i].balance!){
                out += ss
            }
        }
        return out
    }
    
    
    func saveCells(){
        UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: cellArray), forKey: "cellArray")
        UserDefaults.standard.synchronize()
    }
    func loadCells(){
        if let key:NSData = (UserDefaults.standard.object(forKey: "cellArray") as? NSData) {
            cellArray = NSKeyedUnarchiver.unarchiveObject(with: (key as Data)) as! [Cell]
            
            for i in cellArray{
                if i.name == ""{
                    if let index = cellArray.index(of: i) {
                        cellArray.remove(at: index)
                    }
                }
            }
        }

    }
    
    var succeed = true
    
    @IBAction func reload(_ sender: Any) {
        if !Reachability.isConnectedToNetwork(){
            let alert = UIAlertController(title: "No Connection", message: "Please connect to the internet and refresh again", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in }))
            self.present(alert, animated: true, completion: nil)

        }
        else{
            if !loading{
                disGroup2.enter()
                loading = true
                self.ani3.setValue(UIColor.white, forKeypath: "end.Ellipse 1.Stroke 1.Color", atFrame: 0)
                self.ani4.setValue(UIColor.white, forKeypath: "2.Group 1.Stroke 1.Color", atFrame: 0)
                
                for i in cellArray.indices{
                    cellArray[i] = updateCell(cellArray[i])
                }
                
                Construct{(completion) in self.all = completion}
                self.ani3.removeFromSuperview()
                self.ani4.removeFromSuperview()
                self.ani2.loopAnimation = true
                self.view.addSubview(self.ani1)
                self.ani1.play{ (finished) in
                    self.ani1.removeFromSuperview()
                    self.view.addSubview(self.ani2)
                    self.ani2.play{ (finished) in
                        self.ani2.removeFromSuperview()
                        self.view.addSubview(self.ani3)
                        self.ani3.play{ (finished) in
                            self.view.addSubview(self.ani4)
                            self.ani4.play{ (finished) in
                                if !self.succeed{
                                    self.unfinished()
                                }
                                self.impact.impactOccurred()
                                self.loading = false
                                self.disGroup2.leave()
                            }
                        }
                    }
                }
                
                disGroup.notify(queue: .main){
                    self.ani2.loopAnimation = false
                }
                
                disGroup2.notify(queue: .main){
                    self.table.reloadData()
                    self.reloadSubTable()

                    self.saveCells()
                    let format = self.nF.string(from: NSNumber(value: self.cleanUp(self.totalPrice())))
                    self.total.text = "$" + format!
                    print(self.cellArray)
                }
            }
        }
    }
    
    
    
    func updateCell(_ c: Cell) -> Cell{
        succeed = true
        if c.name.lowercased() == "neo"{
            var neo:[NEO]!
            neoBalance(c){(completion) in neo = completion}
            disGroup.notify(queue: .main){
                
                
                if neo != nil && !neo.isEmpty{
                    
                    var tempArr = [String]()
                    if !c.subCells.isEmpty{
                        for j in c.subCells!{
                            tempArr.append(j.name.lowercased())
                        }
                    }
                    tempArr.append("neo")
                    
                    
                    
                    for i in neo.indices{
                        let namee = neo[i].name!
                        if let space = namee.index(of: " ") {
                            neo[i].name = String(namee[namee.startIndex..<space])
                        }
                    }
                    var newSubcells = [NEO]()
                    for i in neo{
                        if !tempArr.contains((i.name?.lowercased())!){
                            newSubcells.append(i)
                        }
                    }
                    
                    
                    for x in newSubcells{
                        let t = (Double(x.total!))
                        let p = Double(self.getPrice(name: x.name!.lowercased()))!
                        let new = Cell(name: x.name!, tag: x.name!, amount: x.total!, price: String(describing: p), balance: String(describing: (t! * p)), address: c.address!, subCells: [Cell]())
                        c.subCells!.append(new)
                        
                        
                    }
//                    c.subCells = c.subCells!
                    
                    for i in neo{
                        if c.subCells.isEmpty{
                            for j in c.subCells!{
                                if i.name?.lowercased() == j.name.lowercased() {
                                    c.amount = i.total
                                    if let t = (Double(i.total!)), let p = Double(self.getPrice(name: j.name.lowercased())){
                                        c.balance = String(describing: (t * p))
                                        c.price = String(describing: p)
                                        c.amount = String(describing: t)
                                    }
                                }
                            }
                        }
                        
                        if i.name?.lowercased() == "neo"{
                            c.amount = i.total
                            if let t = (Double(i.total!)), let p = Double(self.getPrice(name: c.name.lowercased())){
                                c.balance = String(describing: (t * p))
                                c.price = String(describing: p)
                                c.amount = String(describing: t)
                            }
                        }
                    }
                    
                    
                    c.updateMore()
                }
                else{
                    print("fail")
                    self.succeed = false
                }
            }
        }
            
            
            
        else if c.name.lowercased() == "eth"{
            var eth:ETH!
            ethBalance(c){(completion) in eth = completion}
            disGroup.notify(queue: .main){
                
                if eth.ETH?.balance != nil{
                    c.amount = String(describing: eth.ETH!.balance!)
                    c.balance = String(describing: (eth.ETH?.balance)! * Double(self.getPrice(name: "ethereum"))!)
                    c.price = self.getPrice(name: "ethereum")
                    
                    
                    
                    
                    var tempArr = [String]()
                    if !c.subCells.isEmpty{
                        for j in c.subCells!{
                            tempArr.append(j.tag.lowercased())
                        }
                    }
                    tempArr.append("ethereum")
                    
                    var newSubcells = [ERC20]()
                    
                    for i in eth.tokens!{
                        if !tempArr.contains((i.tokenInfo?.name?.lowercased())!){
                            newSubcells.append(i)
                        }
                    }
                    print(newSubcells)
                    
                    for x in newSubcells{
                        let exp: Int
                        if x.tokenInfo?.decimals?.decInt == 0 {
                            exp = Int((x.tokenInfo?.decimals?.decString)!)!
                        }
                        else{
                            exp = (x.tokenInfo?.decimals?.decInt)!
                        }
                        let divisor = Double(10 ^ exp)
                        let t = Double(x.balance!) / divisor
                        
                        let p = Double(self.getPrice(name: (x.tokenInfo?.symbol!.lowercased())!))!
                        let new = Cell(name: x.tokenInfo!.symbol!, tag: x.tokenInfo!.name!, amount: String(describing: t), price: String(describing: p), balance: String(describing: (t * p)), address: c.address!, subCells: [Cell]())
                        c.subCells!.append(new)
                        
                        
                    }
                    
                    
                    
                    if eth.tokens != nil && !(eth.tokens?.isEmpty)!{
                        for i in eth.tokens!{
                                for j in c.subCells{
                                    if i.tokenInfo?.symbol?.lowercased() == j.name.lowercased() {
                                        if let p = Double(self.getPrice(name: j.name.lowercased())){
                                            let exp: Int
                                            if i.tokenInfo?.decimals?.decInt == 0 {
                                                exp = Int((i.tokenInfo?.decimals?.decString)!)!
                                            }
                                            else{
                                                exp = (i.tokenInfo?.decimals?.decInt)!
                                            }
                                            let divisor: Double = Double(truncating: pow(10, exp) as NSNumber)
                                            let t = Double(i.balance!) / divisor
                                            j.amount = String(describing: t)
                                            j.balance = String(describing: (t * p))
                                            j.price = String(describing: p)
                                            
                                        }
                                    }
                                
                            }
                        }
                    }
                    
                    
                    
                    
                    
                    
                c.updateMore()
                    
                }
                else{
                    self.succeed = false
                }
            }
        }
        else if c.name == "Bitcoin"{
            
        }
        
        return c
        
        
    }
    
    
    func unfinished(){
        ani3.setValue(UIColor(named: "failure")!, forKeypath: "end.Ellipse 1.Stroke 1.Color", atFrame: 0)
        self.ani4.setValue(UIColor(named: "failure")!, forKeypath: "2.Group 1.Stroke 1.Color", atFrame: 0)
        self.impact.impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.impact.impactOccurred()
        }
    }
    func Construct(completion: @escaping ([CMC]?) -> ()){
        self.disGroup.enter()
        
        var done = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
            if !done{
                self.disGroup.leave()
                completion(nil)
            }
        }
        guard let url = URL(string: "https://api.coinmarketcap.com/v1/ticker/?limit=0") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    
                    let coin = try JSONDecoder().decode([CMC].self, from: data)
                    
                    print("cmc")
                    self.disGroup.leave()
                    done = true
                    completion(coin)
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
            }.resume()
    }
    

    func neoBalance(_ c: Cell, completion: @escaping ([NEO]) -> ()){
        self.disGroup.enter()
        var done = false
        
        let link = "https://otcgo.cn/api/v1/balances/" + c.address
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
            if !done{
                self.disGroup.leave()
                completion([NEO]())
            }
        }
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let neo = try JSONDecoder().decode(NEON.self, from: data)
                    var output = [NEO]()
                    for i in neo.balances{
                        if (i.name == "NEO" || i.total != "0") {
                            output.append(i)
                        }
                    }
                    print("neo")
                    done = true
                    self.disGroup.leave()
                    completion(output)
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
            }.resume()
    }
    

    
    func ethBalance(_ c:Cell, completion: @escaping (ETH) -> ()){
        self.disGroup.enter()
        var done = false
        let link = "https://api.ethplorer.io/getAddressInfo/" + c.address + "?apiKey=freekey"
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 15) {
            if !done{
                self.disGroup.leave()
                let e = ETH(ETH: ether(balance: nil), tokens: nil)
                completion(e)
            }
        }
        
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let balance = try JSONDecoder().decode(ETH.self, from: data)
                    
                    print("eth")
                    self.disGroup.leave()
                    done = true
                    completion(balance)
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
            }
            }.resume()
    }
    

    
    func getPrice(name: String) -> String{
        for j in self.all{
            let i = j.name?.lowercased()
            let k = j.symbol?.lowercased()
            if i == name.lowercased() || k == name.lowercased(){
                return j.price_usd!
            }
        }
        return "Not Found"
    }
    
    func cleanUp(_ cash:Double) -> Double{
        var out = cash
        if out < 0.00001 && out >= 0.0{
            out = out.truncate(places: 5)
        }
        if out > 0.00001 && out < 1.0{
            out = out.truncate(places: 5)
        }
        else if out > 1.0 && out < 10.0{
            out = out.truncate(places: 4)
        }
        else if out > 10.0 && out < 100.0{
            out = out.truncate(places: 3)
        }
        else if out > 100.0 && out < 1000000{
            out = out.truncate(places: 2)
        }
        else if out > 1000000{
            out = out.truncate(places: 0)
        }
        return out
    }
    
    
    
    let bg = UIImageView(image: UIImage(named:"refresh"))
    
    
    func setupRefresh() {
        bg.frame.origin = CGPoint(x: 18, y: 180)
        self.view.addSubview(bg)
        ani1.frame = CGRect(x: 11.5, y: 173.5, width: 45, height: 45)
        ani2.frame = CGRect(x: 11.5, y: 173.5, width: 45, height: 45)
        ani3.frame = CGRect(x: 11.5, y: 173.5, width: 45, height: 45)
        ani4.frame = CGRect(x: 11.5, y: 173.5, width: 45, height: 45)
        let tap = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.reload))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.reload))
        tap2.numberOfTapsRequired = 1
        tap2.numberOfTouchesRequired = 1
        ani1.addGestureRecognizer(tap)
        ani1.isUserInteractionEnabled = true
        ani4.addGestureRecognizer(tap2)
        ani4.isUserInteractionEnabled = true
        ani1.setValue(UIColor.white, forKeypath: "start.Ellipse 1.Stroke 1.Color", atFrame: 0)
        ani1.setValue(UIColor.white, forKeypath: "static 3.Ellipse 1.Stroke 1.Color", atFrame: 0)
        ani1.setValue(UIColor.white, forKeypath: "static4.Group 1.Stroke 1.Color", atFrame: 0)
        
        ani1.setValue(UIColor.white, forKeypath: "1.Group 1.Stroke 1.Color", atFrame: 0)
        ani2.setValue(UIColor.white, forKeypath: "middle.Ellipse 1.Stroke 1.Color", atFrame: 0)
        ani3.setValue(UIColor.white, forKeypath: "end.Ellipse 1.Stroke 1.Color", atFrame: 0)
        ani4.setValue(UIColor.white, forKeypath: "2.Group 1.Stroke 1.Color", atFrame: 0)
        self.view.addSubview(self.ani1)
    }
    
    
    
    
    
    var addOn = false
    var add:LOTAnimationView?
    var addFrame = CGRect(x: 326, y: 181, width: 30, height: 30)
    func addAddButton(on: Bool){
        
        if add != nil {
            add?.removeFromSuperview()
            add = nil
        }
        let animation = on ? "add2" : "add1"
        add = LOTAnimationView(name: animation)
        add?.isUserInteractionEnabled = true
        add?.frame = addFrame
        
        add?.contentMode = .scaleAspectFill
        addAddGeus()
        self.view.addSubview(add!)
        
        
        add?.translatesAutoresizingMaskIntoConstraints = false
        add?.contentMode = .scaleToFill
        
        let trainlingAdd = add?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        trainlingAdd?.constant = -18
        let bottomAdd = add?.bottomAnchor.constraint(equalTo: self.banner.bottomAnchor)
        bottomAdd?.constant = -10
        let h = add?.heightAnchor.constraint(equalToConstant: 30)
        let w = add?.widthAnchor.constraint(equalToConstant: 30)
        let cons:[NSLayoutConstraint] = [trainlingAdd!, bottomAdd!, h!, w!]
        NSLayoutConstraint.activate(cons)
        
    }
    func addAddGeus(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.toggleMenu(recognizer:)))
        tap.numberOfTapsRequired = 1
        add?.addGestureRecognizer(tap)
    }
    @IBAction func toggleMenu (recognizer:UITapGestureRecognizer) {
        if !addOn {
            self.showAdd()
            add?.play(completion: { (success:Bool) in
                self.addOn = true
                self.addAddButton(on: self.addOn)
            })
        }else{
            self.hideAdd()
            add?.play(completion: { (success:Bool) in
                self.addOn = false
                self.addAddButton(on: self.addOn)
            })
        }
    }
    
    
    func fadeMore(){
        let cells = self.table.visibleCells as! Array<CustomTableViewCell>
        for i in cells {
            i.moreLabel.alpha = 0
            i.moreIcon.alpha = 0
            i.toMore.isActive = false
            i.toView.isActive = true
        }
    }
    
    func defadeMore(){
        let cells = self.table.visibleCells as! Array<CustomTableViewCell>
        for i in cells {
            i.moreLabel.alpha = 1
            i.moreIcon.alpha = 1
            i.toMore.isActive = true
            i.toView.isActive = false
        }
    }
    
    func reloadSubTable() {
        let cells = self.table.visibleCells as! Array<CustomTableViewCell>
        for i in cells {
            i.subTable.reloadData()
        }
    }
    
    func reloadSubMore() {
        let cells = self.table.visibleCells as! Array<CustomTableViewCell>
        for i in cells {
            if !i.extended{
                i.more(i.moreIcon)
            }
        }
    }
    
    
    
    @IBOutlet var totalHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    func showAdd(){
        let superView = parent as! ViewController
        self.bannerHeight.constant = 100
        self.totalHeight.constant = 10
        superView.gradient.constant = 30
        
        table.reloadData()
        
        UIView.animate(withDuration: 0.3, delay: 0.08, options: .curveEaseOut, animations: {
            let head = self.table.tableHeaderView
            head?.frame = CGRect(x: (head?.frame.origin.x)!, y: (head?.frame.origin.y)!, width: (head?.frame.width)!, height: (head?.frame.height)! - 5)
            self.view.layoutIfNeeded()
            superView.view.layoutIfNeeded()
            superView.icon.frame.origin.y = -39
            superView.icon.alpha = 0
            superView.halo.frame.origin.y = -29
            superView.halo.alpha = 0
            superView.top?.frame.origin.y = -30
            
            superView.top?.alpha = 0
            self.add?.frame.origin.y = 60
            self.total.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            self.bg.frame.origin.y = 60
            self.ani1.frame.origin.y = 53.5
            self.ani2.frame.origin.y = 53.5
            self.ani3.frame.origin.y = 53.5
            self.ani4.frame.origin.y = 53.5
            self.addFrame.origin.y = 60
            self.fadeMore()
        }, completion: ({ (end) in
            self.add?.frame.origin.y = 60
            let add = Cell(name: "", tag: "", amount: "", price: "", balance: "", address: "", subCells: [Cell]())
            self.cellArray.append(add)
            self.table.performBatchUpdates({
                self.reloadSubMore()
                self.reloadSubTable()
                self.table.isEditing = true
                self.table.insertRows(at: [IndexPath(row: self.cellArray.count-1, section: 0)], with: .fade)
            }) { (_) in self.table.reloadData()}
        }))
        
        
    }
    func hideAdd(){
        let superView = parent as! ViewController


        
        self.cellArray.remove(at: self.cellArray.count-1)
        let indx = IndexPath(row: self.cellArray.count, section: 0)
        let x = self.table.cellForRow(at: indx) as! CustomTableViewCell

        self.table.performBatchUpdates({
            table.isEditing = false
            self.table.deleteRows(at: [indx], with: .fade)
        }) { (_) in
            UIView.animate(withDuration: 0.24, delay: 0, options: .curveEaseOut, animations: {
                let head = self.table.tableHeaderView
                head?.frame = CGRect(x: (head?.frame.origin.x)!, y: (head?.frame.origin.y)!, width: (head?.frame.width)!, height: (head?.frame.height)! + 5)
                self.bannerHeight.constant = 223
                self.totalHeight.constant = 28.5
                superView.gradient.constant = 98
                self.view.layoutIfNeeded()
                superView.icon.frame.origin.y = 39
                superView.icon.alpha = 1
                superView.halo.frame.origin.y = 29
                superView.halo.alpha = 1
                superView.top?.frame.origin.y = 30
                superView.top?.alpha = 1
                self.total.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.bg.frame.origin.y = 180
                self.ani1.frame.origin.y = 173.5
                self.ani2.frame.origin.y = 173.5
                self.ani3.frame.origin.y = 173.5
                self.ani4.frame.origin.y = 173.5
                self.add?.frame.origin.y = 181
                self.addFrame.origin.y = 181
                self.defadeMore()
                
                
                
            }, completion: ({ (end) in
                self.table.reloadData()
                
                if end{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                        
                        if !x.addBool{
                            x.height.constant = x.height.constant - 80
                            x.updateConstraints()
                            x.layoutIfNeeded()
                            x.newAddress.alpha = 0
                            x.ltcButton.alpha = 0
                            x.btcButton.alpha = 0
                            x.neoButton.alpha = 0
                            x.xrpButton.alpha = 0
                            x.ethButton.alpha = 0
                            x.addCoin.alpha = 1
                            x.bottomCons.isActive = false
                            x.subBottom.isActive = true
                            x.addBool = !x.addBool
                        }
                        
                    }
                }
            }))
        }

        
    
        

    }
    
    
}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.backgroundColor = UIColor(named: "bg")
        cell.contentView.backgroundColor = UIColor(named: "bg")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell2") as! CustomTableViewCell
        let cur = self.cellArray[indexPath.row]
        cell.cellView?.layer.cornerRadius = 10
        cell.name?.text = cur.tag
        cell.tagg?.text = cur.name + ": " + cur.address
        if cur.name == ""{
            cell.money?.text = ""
            cell.moreLabel.text = ""
            cell.addCoin.setImage(#imageLiteral(resourceName: "addCoin"), for: .normal)
            cell.addCoin.isUserInteractionEnabled = true
            cell.moreIcon.isUserInteractionEnabled = false
            cell.moreIcon.isHidden = true
        }
        else{
            var cash = Double(cur.balance!) ?? 0.0
            cell.imagee?.image = UIImage(named: cur.name!)
            let more = cur.more!
            cell.addCoin.setImage(UIImage(), for: .normal)
            cell.moreIcon.isUserInteractionEnabled = true
            cell.addCoin.isUserInteractionEnabled = false
            cell.moreLabel?.text = ""
            if Int(more) != nil && Int(more)! > 0{
                cell.moreLabel?.text = more + " more"
                for i in cur.subCells!{
                    cash += Double(i.balance!) ?? 0.0
                }
            }

            cash = cleanUp(cash)
            let format = nF.string(from: NSNumber(value: cash))
            cell.money?.text = "$" + format!
            let placeholder = Cell(name: "", tag: " ", amount: " ", price: "", balance: " ", address: " ", subCells: [Cell]())
            cell.cells = [placeholder]
            if cur.more.count > 0{
            cell.cells.append(cur)
            for i in 0..<Int(cur.more)!{
                cell.cells.append(cur.subCells![i])
            }
            }
            cell.subTable.separatorColor = UIColor(named: "bg")

        }
        cell.subTable.layer.cornerRadius = 10
        if cell.extended{
            cell.subTable.frame = CGRect(x: cell.subTable.frame.origin.x, y: cell.subTable.frame.origin.y, width: cell.subTable.frame.width, height: cell.subTable.frame.width)
        }
        else{
            cell.subTable.frame = CGRect(x: cell.subTable.frame.origin.x, y: cell.subTable.frame.origin.y, width: cell.subTable.frame.width, height: 45)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == self.cellArray.count-1{
            return false
        }
        else{
            return true
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == self.cellArray.count-1{
            return false
        }
        else{
            return true
        }
        
        
    }

    

    //needs work
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.cellArray[sourceIndexPath.row]
        self.cellArray.remove(at: sourceIndexPath.row)
        self.cellArray.insert(movedObject, at: destinationIndexPath.row)
        NSLog("%@", "\(sourceIndexPath.row) => \(destinationIndexPath.row) \(cellArray)")
        // To check for correctness enable: self.tableView.reloadData()
    }
    

    
    
    
    }





class NeverClearView: UIView {
    override var backgroundColor: UIColor? {
        didSet {
            if backgroundColor?.cgColor.alpha == 0 {
                backgroundColor = oldValue
            }
        }
    }
}
















extension Double{func truncate(places : Int)-> Double{return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))}}
