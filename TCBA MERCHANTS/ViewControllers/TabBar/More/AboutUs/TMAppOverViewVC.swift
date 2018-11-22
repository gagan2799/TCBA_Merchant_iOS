//
//  TMAppOverViewVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 19/11/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMAppOverViewVC: UIViewController, UIScrollViewDelegate {
    
    //MARK: Variables & Constants
    let arrImages   = ["onboading_aa_main.png","onboarding_a_around.jpg","onboarding_b_major_brands.png","onboarding_c_cashback_qr.png","onboarding_d_gift_cards_in_store.png","onboarding_e_share.png","onboarding_f_score.png","onboarding_g_started.png"]
    //MARK: Outlets
    @IBOutlet weak var scrollV: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnGetStarted: UIButton!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewProperties()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        DispatchQueue.main.async {
            for (indexValue , image) in self.arrImages.enumerated() {
                let imgV                = UIImageView.init(frame: CGRect(x: GConstant.Screen.Width * CGFloat(indexValue) , y: 0, width: GConstant.Screen.Width, height: self.scrollV.bounds.height))
                imgV.contentMode        = .scaleToFill
                imgV.backgroundColor    = UIColor.purple
                imgV.image              = UIImage.init(named: image)
                self.scrollV.addSubview(imgV)
            }
            self.scrollV.contentSize = CGSize(width: GConstant.Screen.Width * CGFloat(self.arrImages.count), height: self.scrollV.bounds.height - 50)
        }
    }
    
    //MARK: UIButton Actions
    @IBAction func btnSkipAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnGetstartedAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: UIScrollView Delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat    = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat    = scrollView.contentOffset.x
        
        if(currentHorizontalOffset > 2497 && currentHorizontalOffset <= maximumHorizontalOffset) {
            UIView.animate(withDuration: 0.2) {
                if self.btnSkip.alpha == 1 && self.btnGetStarted.alpha == 0 {
                    self.btnSkip.alpha          = 0
                    self.btnGetStarted.alpha    = 1
                }
            }
        } else {
            if self.btnSkip.alpha == 0 && self.btnGetStarted.alpha == 1 {
                self.btnSkip.alpha          = 1
                self.btnGetStarted.alpha    = 0
            }
        }
    }
}

