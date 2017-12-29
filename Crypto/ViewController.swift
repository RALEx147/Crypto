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
        view2?.view.isHidden = true
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
        self.view1?.banner.frame = bannerFrame
        self.view1?.add.frame = addFrame
        self.view1?.total.alpha = 1
        self.view1?.banner.alpha = 1
        self.view1?.add.alpha = 1
        self.view1?.table.alpha = 1
        self.view1?.ani1.alpha = 1
        self.view1?.ani2.alpha = 1
        self.view1?.ani3.alpha = 1
        self.view1?.ani4.alpha = 1
        self.view1?.bg.alpha = 1
        self.view1?.bg.frame = aniBGFrame
        self.view1?.ani1.frame = ani1Frame
        
        self.view1?.view.isHidden = false
        self.view2?.view.isHidden = true
    }
    
    func toKeyAnimate(){
        UIView.animate(withDuration: 0.3) {
            self.view2?.banner.alpha = 0
        }
    }
    
    func toPrice(){
        self.view2?.banner.alpha = 1
        self.view1?.view.isHidden = true
        self.view2?.view.isHidden = false
    }
    
    func toPriceAnimate(){
        
        UIView.animate(withDuration: 0.23, delay: 0, options: .curveEaseOut, animations: {
            self.view1?.table.alpha = 0
            //            self.view1?.ani1.frame
            self.view1?.add.frame = CGRect(x: (self.view1?.add.frame.origin.x)!, y: -20, width: (self.view1?.add.frame.width)!, height: (self.view1?.add.frame.height)!)
            self.view1?.add.alpha = 0
            self.view1?.total.alpha = 0
            self.view1?.banner.frame = CGRect(x: (self.view1?.banner.frame.origin.x)!, y: -128, width: 375, height: 223)
            self.view1?.ani1.frame = CGRect(x: (self.view1?.ani1.frame.origin.x)!, y: -20, width: (self.view1?.ani1.frame.width)!, height: (self.view1?.ani1.frame.height)!)
            self.view1?.bg.frame = CGRect(x: (self.view1?.bg.frame.origin.x)!, y: -20, width: (self.view1?.bg.frame.width)!, height: (self.view1?.bg.frame.height)!)
            self.view1?.ani1.alpha = 0
            self.view1?.ani2.alpha = 0
            self.view1?.ani3.alpha = 0
            self.view1?.ani4.alpha = 0
            self.view1?.bg.alpha = 0
        }, completion: ({ (end) in print("done")}))
    }
    
    
    
    
    
    var addFrame:CGRect!
    var bannerFrame:CGRect!
    var ani1Frame:CGRect!
    var ani2Frame:CGRect!
    var ani3Frame:CGRect!
    var ani4Frame:CGRect!
    var aniBGFrame:CGRect!
    func setupFrame() {
        addFrame = CGRect(x: (self.view1?.add.frame.origin.x)!, y: (self.view1?.add.frame.origin.y)! , width: (self.view1?.add.frame.width)!, height: (self.view1?.add.frame.height)!)
        bannerFrame = CGRect(x: (self.view1?.banner.frame.origin.x)!, y: (self.view1?.banner.frame.origin.y)! , width: (self.view1?.banner.frame.width)!, height: (self.view1?.banner.frame.height)!)
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


