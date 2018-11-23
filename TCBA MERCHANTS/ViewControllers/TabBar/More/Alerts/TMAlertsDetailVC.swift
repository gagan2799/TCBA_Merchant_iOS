//
//  TMAlertsDetailVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 05/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMAlertsDetailVC: UIViewController {
    //MARK: Variables & Constants
    var objAlert: AlertNotificationsNotification!
    
    //MARK: Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var viewContainerTitle: UIView!
    @IBOutlet weak var viewContainerDes: UIView!
    
    @IBOutlet weak var imgV: UIImageView!
    
    //MARK: - View Life Cycle
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
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setViewProperties() {
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title   = "Alerts"
        
        viewContainerTitle.applyViewShadow(shadowOffset: CGSize(width: 0.5, height: 0.5), shadowColor: UIColor.lightGray, shadowOpacity: 50.0, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, backgroundColor: UIColor.white, backgroundOpacity: nil)
        viewContainerDes.applyViewShadow(shadowOffset: CGSize(width: 0.5, height: 0.5), shadowColor: UIColor.lightGray, shadowOpacity: 50.0, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, backgroundColor: UIColor.white, backgroundOpacity: nil)
        
        lblTitle.text                   = objAlert.title
        lblDate.text                    = Date().dateToDDMMYYYY(date: objAlert?.dateCreated ?? "")
        guard let htmlText              = objAlert.description  else { return }
        DispatchQueue.main.async {
            self.txtDescription.attributedText  = htmlText.html2AttributedStringWithCustomFont
            self.txtDescription.textAlignment   = .justified
        }
        
        if let url = URL(string:objAlert?.image ?? "") {
            imgV.setImageWithDownload(url, withIndicator: true)
            DispatchQueue.main.async {
                self.imgV.layoutIfNeeded()
                self.setNeedsFocusUpdate()
            }
        } else {
            imgV.image                  = UIImage.init(named: "cardPlaceholder")
        }
    }
}
