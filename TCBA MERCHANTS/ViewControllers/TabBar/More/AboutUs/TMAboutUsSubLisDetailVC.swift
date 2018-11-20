//
//  TMAboutUsSubLisDetailVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 01/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMAboutUsSubLisDetailVC: UIViewController {
    
    //MARK: - Outlets
    //UIImageView
    @IBOutlet weak var imgV: UIImageView!
    //UIView
    @IBOutlet weak var viewContainer: UIView!
    //UIlabel
    @IBOutlet weak var lblTitle: UILabel!
    //UITextView
    @IBOutlet weak var txtView: UITextView!
    //MARK: - Variables
    //Model
    var section: GetAboutUsSectionAbout!
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title = section.title
        if let img = section.image {
            imgV.setImageWithDownload(URL(string: img)!, withIndicator: true)
        } else {
            imgV.image            = UIImage.init(named: "cardPlaceholder")
        }
        DispatchQueue.main.async {
            self.imgV.layoutIfNeeded()
            self.setNeedsFocusUpdate()
        }
        viewContainer.applyViewShadow(shadowOffset: CGSize(width: 0.5, height: 0.5), shadowColor: UIColor.lightGray, shadowOpacity: 50.0, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, backgroundColor: UIColor.white, backgroundOpacity: nil)
        lblTitle.font       = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        lblTitle.text       = section.title
        guard let htmlText  = section.description  else { return }
        DispatchQueue.main.async {
            self.txtView.attributedText  = htmlText.html2AttributedStringWithCustomFont
        }
    }
}
