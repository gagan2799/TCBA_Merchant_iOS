//
//  TMAboutUsVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 21/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMAboutUsVC: UIViewController {
    //MARK: Structure
    struct AboutUs: Codable {
        let image, title: String?
    }

    //MARK: Variables & Constants
    let arrAboutUs = [AboutUs.init(image: "corportae", title: "Corporate"),
                      AboutUs.init(image: "news", title: "News"),
                      AboutUs.init(image: "about_Icon", title: "App Introduction Video")]
    
    //MARK: Outlets
    //UILabel
    
    //UITableView
    @IBOutlet weak var tblAboutUs: UITableView!
    
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
        self.navigationController?.customize()
        self.navigationItem.title   = "About TCBA"
    }
}

extension TMAboutUsVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView Delegates & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAboutUs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TMMoreTableCell") as! TMMoreTableCell
        cell.lblName.font   = UIFont.applyOpenSansRegular(fontSize: 16.0)
        cell.lblName.text   = arrAboutUs[indexPath.row].title
        cell.imgIcon.image  = UIImage(named: arrAboutUs[indexPath.row].image!)
        
        return cell
    }
}
