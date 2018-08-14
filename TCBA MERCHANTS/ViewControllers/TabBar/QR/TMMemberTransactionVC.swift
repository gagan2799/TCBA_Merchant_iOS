//
//  TMTransactionPaymentVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 14/08/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMMemberTransactionVC: UIViewController {

    //MARK: Modal objects
    var memberTransactionData: MemberTransactionDetailsModel!
    
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
//        guard scrQR != nil else {return}
        if  UIDevice.current.orientation.isLandscape == true  {
//            scrQR.isScrollEnabled = true
        }else{
//            scrQR.isScrollEnabled = false
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
        self.navigationItem.title   = "Member Transaction"
        
//        guard scrQR != nil else {return}
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
//            scrQR.isScrollEnabled = true
        }else{
//            scrQR.isScrollEnabled = false
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
