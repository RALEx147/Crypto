//
//  FirstViewController.swift
//  Crypto
//
//  Created by Robert Alexander on 10/28/17.
//  Copyright © 2017 Robert Alexander. All rights reserved.
//

import UIKit
import Lottie
import JHTAlertController

/*
 !!!!!
 LOTTIE ANIMATIONS
 BETTER TABLE VIEW/SCROLL VIEW
 PRICE BREAKDOWN
 ERC-20 INTEGRATION
 SEPHAMORES/ASYNC SOLUTION
 !!!!!
 */

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var gradient: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var halo: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    
    
    @IBOutlet weak var v2: UIView!
    @IBOutlet weak var v1: UIView!
    
    
    
    
    var view1:FirstViewController!
    var view2:SecondViewController!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seg1"{
            view1 = segue.destination as? FirstViewController
        }
        else{
            view2 = segue.destination as? SecondViewController
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTopButton(on: topOn)
        
        v2.alpha = 0
        setupFrame()
        
    }
    
    
    
    
    
    
    
    
    
    
    var topOn = false
    var top:LOTAnimationView?
    let topFrame = CGRect(x: 18, y: 30, width: 84, height: 45)
    func addTopButton(on: Bool){
        if top != nil {
            top?.removeFromSuperview()
            top = nil
        }
        let animation = on ? "top2" : "top1"
        top = LOTAnimationView(name: animation)
        top?.isUserInteractionEnabled = true
        top?.frame = topFrame
        top?.contentMode = .scaleAspectFill
        addTopGeus()
        self.view.addSubview(top!)
    }
    func addTopGeus(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.toggleMenu(recognizer:)))
        tap.numberOfTapsRequired = 1
        top?.addGestureRecognizer(tap)
    }
    @IBAction func toggleMenu (recognizer:UITapGestureRecognizer) {
        if !topOn {
            self.toPriceAnimate()
            top?.play(completion: { (success:Bool) in
                self.toPrice()
                self.topOn = true
                self.addTopButton(on: self.topOn)
            })
        }else{
            self.toKeyAnimate()
            top?.play(completion: { (success:Bool) in
                self.toKey()
                self.topOn = false
                self.addTopButton(on: self.topOn)
            })
        }
    }
    
    
    
    
    
    func toKey(){
        self.v2.alpha = 0
    }
    
    func toKeyAnimate(){
        self.v1.alpha = 1
        UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseOut, animations: {
            self.view1?.table.alpha = 1
            self.view1?.table.alpha = 1
            self.view1?.total.alpha = 1
            self.view1?.ani1.alpha = 1
            self.view1?.ani2.alpha = 1
            self.view1?.ani3.alpha = 1
            self.view1?.ani4.alpha = 1
            self.view1?.add?.alpha = 1
            self.view1?.bg.alpha = 1
            self.view1?.add?.frame = self.addFrame
            self.view1?.bg.frame = self.aniBGFrame
            self.view1?.ani1.frame = self.ani1Frame
            self.view1?.ani2.frame = self.ani2Frame
            self.view1?.ani3.frame = self.ani3Frame
            self.view1?.ani4.frame = self.ani4Frame
            self.view1.banner.frame = self.bannerFrame
        }, completion: ({ (end) in }))
    }
    
    func toPrice(){
        self.v1.alpha = 0
        self.v2.alpha = 1
    }
    
    func toPriceAnimate(){
        UIView.animate(withDuration: 0.23, delay: 0, options: .curveEaseOut, animations: {
            self.view1?.table.alpha = 0
            self.view1?.total.alpha = 0
            self.view1?.add?.alpha = 0
            self.view1?.ani1.alpha = 0
            self.view1?.ani2.alpha = 0
            self.view1?.ani3.alpha = 0
            self.view1?.ani4.alpha = 0
            self.view1?.bg.alpha = 0
            self.view1?.add?.frame.origin.y = -20
            self.view1?.ani1.frame.origin.y = -20
            self.view1?.ani2.frame.origin.y = -20
            self.view1?.ani3.frame.origin.y = -20
            self.view1?.ani4.frame.origin.y = -20
            self.view1?.bg.frame.origin.y = -20
            self.view1.banner.frame.origin.y = -128
        }, completion: ({ (end) in}))
    }
    
    
    
    
    
    var addFrame:CGRect!
    var bannerFrame:CGRect!
    var ani1Frame:CGRect!
    var ani2Frame:CGRect!
    var ani3Frame:CGRect!
    var ani4Frame:CGRect!
    var aniBGFrame:CGRect!
    
    func setupFrame() {
        
        addFrame = CGRect(x: (self.view1?.add?.frame.origin.x)!, y: (self.view1?.add?.frame.origin.y)! , width: (self.view1?.add?.frame.width)!, height: (self.view1?.add?.frame.height)!)
        bannerFrame = CGRect(x: (self.view1?.banner.frame.origin.x)!, y: (self.view1?.banner.frame.origin.y)! , width: (self.view.frame.width), height: (self.view1?.banner.frame.height)!)
        ani1Frame = CGRect(x: (self.view1?.ani1.frame.origin.x)!, y: (self.view1?.ani1.frame.origin.y)! , width: (self.view1?.ani1.frame.width)!, height: (self.view1?.ani1.frame.height)!)
        ani2Frame = CGRect(x: (self.view1?.ani2.frame.origin.x)!, y: (self.view1?.ani2.frame.origin.y)! , width: (self.view1?.ani2.frame.width)!, height: (self.view1?.ani1.frame.height)!)
        ani3Frame = CGRect(x: (self.view1?.ani3.frame.origin.x)!, y: (self.view1?.ani3.frame.origin.y)! , width: (self.view1?.ani3.frame.width)!, height: (self.view1?.ani3.frame.height)!)
        ani4Frame = CGRect(x: (self.view1?.ani4.frame.origin.x)!, y: (self.view1?.ani4.frame.origin.y)! , width: (self.view1?.ani4.frame.width)!, height: (self.view1?.ani4.frame.height)!)
        aniBGFrame = CGRect(x: (self.view1?.bg.frame.origin.x)!, y: (self.view1?.bg.frame.origin.y)! , width: (self.view1?.bg.frame.width)!, height: (self.view1?.bg.frame.height)!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


