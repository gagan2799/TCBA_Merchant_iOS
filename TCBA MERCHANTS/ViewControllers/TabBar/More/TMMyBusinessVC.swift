
//
//  TMMyBusinessVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 04/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMMyBusinessVC: UIViewController {

    //MARK: Variables & Constants
    let arrCellNames    = ["Store Featured Content", "Term and Conditions", "Store Detail Content", "Store About Us Content", "Trading Hours", "Contact Details", "Store images", "View Bank Details"]
    let arrICellIcons   = ["business_store", "business_conditions", "business_store-detail", "business_about-us", "business_hours", "business_contact", "business_image", "business_bank"]
    
    //MARK: Outlets
    //CollectionView
    @IBOutlet weak var cvBusiness: UICollectionView!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            DispatchQueue.main.async {
                for gradientLine in self.cvBusiness.subviews{
                    if gradientLine.bounds.width == 1 || gradientLine.bounds.height == 1 {
                        gradientLine.removeFromSuperview()
                    }
                }
            }
            self.cvBusiness.reloadData()
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            DispatchQueue.main.async {
                let y = self.cvBusiness.bounds.width/2
                var x = UIDevice.current.userInterfaceIdiom == .pad ? self.cvBusiness.bounds.height/4 : self.cvBusiness.bounds.height/3.8
                
                guard let verticalLine = GFunction.shared.getDoubleGradientView(CGRect(x: y, y: 0, width: 1, height: x*4), start: .clear, midColor: UIColor.init(red: 116.0/255.0, green: 162.0/255.0, blue: 178.0/255, alpha: 0.5), end: .clear, direction: .vertical) else { return }
                self.cvBusiness.addSubview(verticalLine)
                
                for _ in 0...2 {
                    guard let horizontalLine = GFunction.shared.getDoubleGradientView(CGRect(x: 10*GConstant.Screen.HeightAspectRatio, y: x, width: self.cvBusiness.bounds.width-20*GConstant.Screen.HeightAspectRatio, height: 1), start: .clear, midColor: UIColor.init(red: 116.0/255.0, green: 162.0/255.0, blue: 178.0/255, alpha: 0.5), end: .clear, direction: .horizontal) else { return }
                    self.cvBusiness.addSubview(horizontalLine)
                    
                    x = x + (UIDevice.current.userInterfaceIdiom == .pad ? self.cvBusiness.bounds.height/4 : self.cvBusiness.bounds.height/3.8)
                }
            }
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setViewProperties() {
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title   = "My Business"
        
        DispatchQueue.main.async {
            let y = self.cvBusiness.bounds.width/2
            var x = UIDevice.current.userInterfaceIdiom == .pad ? self.cvBusiness.bounds.height/4 : self.cvBusiness.bounds.height/3.8
            
            guard let verticalLine = GFunction.shared.getDoubleGradientView(CGRect(x: y, y: 0, width: 1, height: x*4), start: .clear, midColor: UIColor.init(red: 116.0/255.0, green: 162.0/255.0, blue: 178.0/255, alpha: 0.5), end: .clear, direction: .vertical) else { return }
            self.cvBusiness.addSubview(verticalLine)
            
            for _ in 0...2 {
                guard let horizontalLine = GFunction.shared.getDoubleGradientView(CGRect(x: 10*GConstant.Screen.HeightAspectRatio, y: x, width: self.cvBusiness.bounds.width-20*GConstant.Screen.HeightAspectRatio, height: 1), start: .clear, midColor: UIColor.init(red: 116.0/255.0, green: 162.0/255.0, blue: 178.0/255, alpha: 0.5), end: .clear, direction: .horizontal) else { return }
                self.cvBusiness.addSubview(horizontalLine)
                
                x = x + (UIDevice.current.userInterfaceIdiom == .pad ? self.cvBusiness.bounds.height/4 : self.cvBusiness.bounds.height/3.8)
            }
        }
    }
}
//MARK: - Coustom Methods

extension TMMyBusinessVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: CollectionView Delegates & DataSource
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cvWidth     = collectionView.bounds.width
        let cvHeight    = collectionView.bounds.height
        
        return CGSize(width: cvWidth/2, height: cvHeight/4.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCellNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TMMyBusinessCVCell", for: indexPath) as! TMMyBusinessCVCell
        
        cell.imgIcon.image     = UIImage(named: arrICellIcons[indexPath.item])
        cell.lblName.text      = arrCellNames[indexPath.item]
        cell.lblName.font      = UIFont.applyOpenSansRegular(fontSize: 12.0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
          
        } else if indexPath.row == 1 {
         
        } else if indexPath.row == 2 {
           
        } else if indexPath.row == 3 {
           
        } else if indexPath.row == 4 {
           
        } else if indexPath.row == 5 {
        
        } else if indexPath.row == 6 {
            
        } else if indexPath.row == 7 {
            
        } else {
            return
        }
    }
}
