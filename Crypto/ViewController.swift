//
//  FirstViewController.swift
//  Crypto
//
//  Created by Robert Alexander on 10/28/17.
//  Copyright © 2017 Robert Alexander. All rights reserved.
//

import UIKit
import Lottie


class ViewController: UIViewController {
	
	@IBOutlet weak var gradient: NSLayoutConstraint!
	@IBOutlet weak var halo: UIImageView!
	@IBOutlet weak var v2: UIView!
	@IBOutlet weak var v1: UIView!
	@IBOutlet var icon: UIButton!
	

	override func viewDidLoad() {
		super.viewDidLoad()
		
		addTopButton(on: topOn)
		v2.alpha = 0
		setupFrame()
		setupProfile()
		imagePicker.delegate = self
	}
	
	
	var view1:FirstViewController!
	var view2:SecondViewController!
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "seg1"{
			view1 = segue.destination as? FirstViewController
		}
		else if segue.identifier == "seg2"{
			view2 = segue.destination as? SecondViewController
		}
	}
	
	
	@IBOutlet weak var profileImage: UIButton!
	let imagePicker = UIImagePickerController()
	@IBAction func profile(_ sender: Any) {
		imagePicker.allowsEditing = false
		imagePicker.sourceType = .photoLibrary
		present(imagePicker, animated: true, completion: nil)
	}
	
	func setupProfile(){
		profileImage.layer.masksToBounds = true
		profileImage.layer.cornerRadius = profileImage.frame.width / 2
		loadProfileImage()
	}
	
	func saveProfileImage(){
		let image: UIImage? = profileImage.imageView?.image
		let data: Data = image!.jpegData(compressionQuality: 0.2)!
		UserDefaults.standard.set(data, forKey: "ProfileImage")
		UserDefaults.standard.synchronize()
	}
	func loadProfileImage(){
		if let imgData = UserDefaults.standard.object(forKey: "ProfileImage")as? NSData{
			profileImage.setImage(UIImage(data: imgData as Data), for: .normal)
		}
		else{
			profileImage.setImage(UIImage(named: "defaultProfile"), for: .normal)
		}
	}
	
	
	
	
	var topOn = false
	var top:LOTAnimationView?
	let topFrame = CGRect(x: 0, y: 0, width: 84, height: 45)
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
		top?.translatesAutoresizingMaskIntoConstraints = false
		top?.contentMode = .scaleToFill
		
		let leadingTop = top?.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor)
		leadingTop?.constant = 20
		let topTop = top?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
		topTop?.constant = 10
		let h = top?.heightAnchor.constraint(equalToConstant: 45)
		let w = top?.widthAnchor.constraint(equalToConstant: 84)
		let cons:[NSLayoutConstraint] = [leadingTop!, topTop!, h!, w!]
		NSLayoutConstraint.activate(cons)
		self.view.layoutIfNeeded()
	}
	func addTopGeus(){
		let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.toggleMenu(recognizer:)))
		tap.numberOfTapsRequired = 1
		top?.addGestureRecognizer(tap)
	}
	@IBAction func toggleMenu (recognizer:UITapGestureRecognizer? = nil) {
		if !topOn {
			self.toPriceAnimate()
			top?.play(completion: { (success:Bool) in
				
				self.topOn = true
				self.addTopButton(on: self.topOn)
			})
		}else{
			self.toKey()
			top?.play(completion: { (success:Bool) in
				
				self.topOn = false
				self.addTopButton(on: self.topOn)
			})
		}
	}
	
	
	
	@IBOutlet var debug: UIButton!
	
	@IBAction func debug(_ sender: Any) {
		
		let version: AnyObject = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject
		
		let alert = UIAlertController(title: "Crypto Keychain", message: "CryptoKeychain Version " + (version as! String) + "\nNava Dräg Limited", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in }))
		self.present(alert, animated: true, completion: nil)
		
		
	}
	
	func toKey(){
		
		
		self.view2?.bannerHeight.constant = v1BH!
		UIView.animate(withDuration: 0.48, delay: 0, options: .curveEaseOut, animations: {
			self.view2.table.alpha = 0
			self.view2.lbl.alpha = 0
			//            self.view2.search.alpha = 0
			//            self.view2.blurView.alpha = 0
			self.view2.delaget()
			self.view2.v.search.text = ""
			self.view2.add.alpha = 0
			self.view2.view.layoutIfNeeded()
			self.view.layoutIfNeeded()
		}, completion: ({ (end) in
			self.toKeyAnimate()
		}))
		
		self.view1.reload(self)
	}
	
	func toKeyAnimate(){
		self.v1.alpha = 1
		self.v2.alpha = 0
		self.icon.alpha = 1
		
		UIView.animate(withDuration: 0.33, delay: 0.1, options: .curveEaseOut, animations: {
			let cells = self.view1?.table.visibleCells as! Array<CustomTableViewCell>
			for i in cells {
				i.alpha = 1
			}
			self.view1?.total.alpha = 1
			self.view1?.ani1.alpha = 1
			self.view1?.ani2.alpha = 1
			self.view1?.ani3.alpha = 1
			self.view1?.ani4.alpha = 1
			self.view1?.add?.alpha = 1
			self.view1?.bg.alpha = 1
			
			
		}, completion: ({ (end) in
			self.view2?.bannerHeight.constant = self.v2BH! - 2
			self.view2.view.layoutIfNeeded()
		}))
	}
	
	func toPrice(){
		self.v1.alpha = 0
		self.v2.alpha = 1
		self.view2.table.reloadData()
		self.view2.refresh()
		UIView.animate(withDuration: 0.23, delay: 0.2, options: .curveEaseOut, animations: {
			self.view2.table.alpha = 1
			self.view2.lbl.alpha = 1
			self.view2.add.alpha = 1
		}, completion: { (_) in
			self.view1?.bannerHeight.constant = self.v1BH! + 2
			self.view1.view.layoutIfNeeded()
		})
	}
	
	func toPriceAnimate(){
		self.view1?.bannerHeight.constant = view2.banner.frame.size.height
		
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
			self.view1.view.layoutIfNeeded()
			self.view1?.total.alpha = 0
			self.view1?.add?.alpha = 0
			self.view1?.ani1.alpha = 0
			self.view1?.ani2.alpha = 0
			self.view1?.ani3.alpha = 0
			self.view1?.ani4.alpha = 0
			self.view1?.bg.alpha = 0
			
			
			self.view.layoutIfNeeded()
		}) { (_) in}
		UIView.animate(withDuration: 0.22, delay: 0.26, options: .curveEaseOut, animations: {
			
			let cells = self.view1?.table.visibleCells as! Array<CustomTableViewCell>
			if cells.count > 0{
				for i in cells {
					i.alpha = 0.01
				}
			}
			else{
				self.icon.alpha = 0.99
			}
			
			
			
			
		}, completion: ({ (end) in
			self.toPrice()
			
		}))
	}
	
	
	
	
	var addFrame:CGRect!
	var bannerFrame:CGRect!
	var ani1Frame:CGRect!
	var ani2Frame:CGRect!
	var ani3Frame:CGRect!
	var ani4Frame:CGRect!
	var aniBGFrame:CGRect!
	var bannerFrame2:CGRect!
	var v2BH:CGFloat!
	var v1BH:CGFloat!
	
	func setupFrame() {
		
		addFrame = CGRect(x: (self.view1?.add?.frame.origin.x)!, y: (self.view1?.add?.frame.origin.y)! , width: (self.view1?.add?.frame.width)!, height: (self.view1?.add?.frame.height)!)
		bannerFrame = CGRect(x: (self.view1?.banner.frame.origin.x)!, y: (self.view1?.banner.frame.origin.y)! , width: (self.view.frame.width), height: (self.view1?.banner.frame.height)!)
		ani1Frame = CGRect(x: (self.view1?.ani1.frame.origin.x)!, y: (self.view1?.ani1.frame.origin.y)! , width: (self.view1?.ani1.frame.width)!, height: (self.view1?.ani1.frame.height)!)
		ani2Frame = CGRect(x: (self.view1?.ani2.frame.origin.x)!, y: (self.view1?.ani2.frame.origin.y)! , width: (self.view1?.ani2.frame.width)!, height: (self.view1?.ani1.frame.height)!)
		ani3Frame = CGRect(x: (self.view1?.ani3.frame.origin.x)!, y: (self.view1?.ani3.frame.origin.y)! , width: (self.view1?.ani3.frame.width)!, height: (self.view1?.ani3.frame.height)!)
		ani4Frame = CGRect(x: (self.view1?.ani4.frame.origin.x)!, y: (self.view1?.ani4.frame.origin.y)! , width: (self.view1?.ani4.frame.width)!, height: (self.view1?.ani4.frame.height)!)
		aniBGFrame = CGRect(x: (self.view1?.bg.frame.origin.x)!, y: (self.view1?.bg.frame.origin.y)! , width: (self.view1?.bg.frame.width)!, height: (self.view1?.bg.frame.height)!)
		bannerFrame2 = CGRect(x: (self.view2?.banner.frame.origin.x)!, y: (self.view2?.banner.frame.origin.y)! , width: (self.view.frame.width), height: (self.view2?.banner.frame.height)!)
		
		//        v2BH = (view2?.bannerHeight.constant)! + 2
		
		self.view2.view.layoutIfNeeded()
		
		v2BH = (view2.banner.frame.size.height) + 2
		
		//        v2BH = view2.banner.image?.size.height
		
		v1BH = (view1?.bannerHeight.constant)! - 2
		
	}
	
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
	@objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			let finalImage = resizeImage(image: pickedImage, targetSize: CGSize(width: 400, height: 400))
			profileImage.contentMode = .scaleAspectFit
			profileImage.setImage(finalImage, for: .normal)
			saveProfileImage()
			
			dismiss(animated: true, completion: nil)
		}
		func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
			dismiss(animated: true, completion: nil)
		}
		
	}
	func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
		let size = image.size
		
		let widthRatio  = targetSize.width  / size.width
		let heightRatio = targetSize.height / size.height
		
		// Figure out what our orientation is, and use that to form the rectangle
		var newSize: CGSize
		if(widthRatio > heightRatio) {
			newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
		} else {
			newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
		}
		
		// This is the rect that we've calculated out and this is what is actually used below
		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		
		// Actually do the resizing to the rect using the ImageContext stuff
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		image.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
	}
}

