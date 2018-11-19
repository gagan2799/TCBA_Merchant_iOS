//
//  TMAppOverViewVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 19/11/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMAppOverViewVC: UIViewController {

    //MARK: Variables & Constants
    let arrImages   = ["onboading_aa_main.png","onboarding_a_around.jpg","onboarding_b_major_brands.png","onboarding_c_cashback_qr.png","onboarding_d_gift_cards_in_store.png","onboarding_e_share.png","onboarding_f_score.png","onboarding_g_started.png"]
    //MARK: Outlets
    @IBOutlet weak var scrollV: UIScrollView!
    //UILabel
    
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
            
        }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setViewProperties() {
        // navigationBar customization
//        self.navigationController?.customize()
//        self.navigationItem.title   = "App Overview"
        
        self.navigationController?.isNavigationBarHidden    = true

        for (indexValue , image) in arrImages.enumerated() {
            let imgV = UIImageView.init(frame: CGRect(x: scrollV.bounds.width * CGFloat(indexValue) , y: 0, width: scrollV.bounds.width, height: scrollV.bounds.height))
            imgV.image  = UIImage.init(named: image)
            scrollV.addSubview(imgV)
        }
       //CGSizeMake(scrollV.frame.size.width * CGFloat(arrImages.count), scrollV.bounds.height);
    }
}
