//
//  TMMoreViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 31/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMMoreViewController: UIViewController {
    //MARK: Variables & Constants
    let arrCellNames    = ["My Business", "My Staff Accounts", "Videos", "Alerts", "Calculator", "About Us", "Rate this App", "Contact Us"]
    let arrICellIcons   = ["more_business", "more_staff", "videos_Icon", "alerts_Icon", "calculator_Icon", "about_Icon", "feedback_Icon", "contact_us"]
    
    //MARK: Outlets
    //UILabel
    @IBOutlet weak var lblVersion: UILabel!
    //UITableView
    @IBOutlet weak var tblMore: UITableView!
    
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
        self.navigationItem.title   = "More"
        lblVersion.font             = UIFont.applyOpenSansSemiBold(fontSize: 14.0)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            lblVersion.text         = "Version \(version)"
        }
    }
    
    //MARK: - UIButton Action methods
    @IBAction func btnLogoutAction(_ sender: UIButton) {
        AlertManager.shared.showAlertTitle(title: "Logout", message: "Are you sure you want to logout?", buttonsArray: ["Cancel","Logout"]) { (buttonIndex : Int) in
            switch buttonIndex {
            case 0 :
                //No clicked
                break
            case 1:
                GFunction.shared.userLogOut()
                break
            default:
                break
            }
        }
    }
}

extension TMMoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView Delegates & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCellNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TMMoreTableCell") as! TMMoreTableCell
        cell.lblName.font   = UIFont.applyOpenSansRegular(fontSize: 16.0)
        cell.lblName.text   = arrCellNames[indexPath.row]
        cell.imgIcon.image  = UIImage(named: arrICellIcons[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //MyBussiness
            let obj = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.MyBusiness) as! TMMyBusinessVC
            self.navigationController?.pushViewController(obj, animated: true)
        } else if indexPath.row == 1 {
            
        } else if indexPath.row == 2 {
            
        } else if indexPath.row == 3 {
            
        } else if indexPath.row == 4 {
            
        } else if indexPath.row == 5 {
            
        } else if indexPath.row == 6 {
            
        } else if indexPath.row == 7 {
            
        }
    }
}
