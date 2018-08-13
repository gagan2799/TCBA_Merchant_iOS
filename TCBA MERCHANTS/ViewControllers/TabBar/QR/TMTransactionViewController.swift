//
//  TMTransactionViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMTransactionViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var vBGGradient: UIView!
    @IBOutlet weak var vBotmCont: UIView!
    @IBOutlet weak var vQR: UIView!
    @IBOutlet weak var vTxtF: UIView!
    
    @IBOutlet weak var lblStoreId: UILabel!
    @IBOutlet weak var lblCashBack: UILabel!
    @IBOutlet weak var lblOR: UILabel!
    @IBOutlet weak var lblScanCode: UILabel!
    @IBOutlet weak var vSemiCircle: UIView!
    @IBOutlet weak var vSemicircleL: UIView!
    
    @IBOutlet weak var txtId: UITextField!
    
    @IBOutlet weak var btnSubmitOutlet: UIButton!
    
    @IBOutlet weak var scrQR: UIScrollView!
    @IBOutlet weak var consHeightBotmV: NSLayoutConstraint!
    
    
    //MARK: View life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard scrQR != nil else {return}
        if  UIDevice.current.orientation.isLandscape == true  {
            scrQR.isScrollEnabled = true
        }else{
            scrQR.isScrollEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Set view properties
    func setViewProperties(){
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title   = "Customer Transaction"
        
        guard scrQR != nil else {return}
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            scrQR.isScrollEnabled = true
        }else{
            scrQR.isScrollEnabled = false
        }
        if  UIDevice.current.userInterfaceIdiom == .pad  {
            consHeightBotmV.constant    = GConstant.Screen.Height * 0.5
        }else{
            consHeightBotmV.constant    = GConstant.Screen.Height * 0.45
        }
        vBotmCont.layoutIfNeeded()
        
        vTxtF.applyStyle(cornerRadius: 3.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 1.0,backgroundColor: .white)
        vBotmCont.applyCornerRadius(cornerRadius: 3.0*GConstant.Screen.HeightAspectRatio)
        vSemiCircle.applyCornerRadius()
        vSemicircleL.applyCornerRadius()
        
        // Set lbl properties
        lblCashBack.font = UIFont.applyOpenSansSemiBold(fontSize: 18.0)
        lblStoreId.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0), labelColor: .white, cornerRadius: 2.0, borderColor: .white, borderWidth: 1.0, labelShadow: nil)
        lblStoreId.backgroundColor          = .clear
        lblStoreId.text                     = "Store Id: \(GConstant.UserData.stores ?? "")"
        lblOR.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 15.0, isAspectRasio: false), labelColor: GConstant.AppColor.textDark, cornerRadius: lblOR.bounds.midY, borderColor: GConstant.AppColor.textLight, backgroundColor: .white, borderWidth: 1.0)
        lblScanCode.font                    = UIFont.applyOpenSansBold(fontSize: 20.0)
        
        txtId.font                          = UIFont.applyOpenSansRegular(fontSize: 15.0)
        btnSubmitOutlet.titleLabel?.font    = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
    }
    
    //MARK: - UIButton Action methods
    @IBAction func btnSubmirAction(_ sender: UIButton) {
        
    }
    
    //MARK: - UIView Action methods
    @IBAction func vQRAction(_ sender: UIControl) {
        let obj = TMScannerVC()
        let navigationController = UINavigationController(rootViewController:obj)
        rootWindow().rootViewController?.present(navigationController, animated: true, completion: {
        })
    }
}
