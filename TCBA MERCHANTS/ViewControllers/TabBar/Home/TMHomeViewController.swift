//
//  TMHomeViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 18/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMHomeViewController: UIViewController {
    
    
    var arryObjects = ["Groceries and Alcohol",
                       "Petrol, Tyres an service",
                       "Telephone, Internet,Power and Gas",
                       "Finance, Insurance, Travel and Accommodation",
                       "Dining and Entertainment",
                       "Hair and Beauty",
                       "General Merchandise",
                       "...and more!" ]
    //MARK: - Outlets
    @IBOutlet weak var lblStoreId: UILabel!
    @IBOutlet weak var consHeightHomeIV: NSLayoutConstraint!
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
        GConstant.NavigationController = self.navigationController
//        GFunction.shared.makeUserLoginAlert()
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func setViewProperties(){
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title           = "The Cash Back App"
        // hide the default back buttons
        self.navigationItem.hidesBackButton = true
        
        //dynamic height image
        if UIDevice.current.userInterfaceIdiom == .pad {
            consHeightHomeIV.constant = GConstant.Screen.Height * 0.35
        }else{
            consHeightHomeIV.constant = GConstant.Screen.Height * 0.3
        }
        self.view.layoutIfNeeded()
        // lbl properties set
        lblStoreId.applyStyle(labelFont: nil, labelColor: .white, cornerRadius: nil, borderColor: .white, borderWidth: 1.0, labelShadow: nil)
        lblStoreId.backgroundColor          = UIColor.black.withAlphaComponent(0.4)
        lblStoreId.text                     = "Store Id:\(GConstant.UserData.stores ?? "")"
    }
}

extension TMHomeViewController: UITableViewDataSource,UITableViewDelegate{
    // MARK: - UITableView Delegates & Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arryObjects.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! TMHomeTableViewCell
        
        if (arryObjects.count - 1 == indexPath.row) {
            cell.imgLogo.image = nil
            cell.lblText.text = arryObjects[indexPath.row]
            cell.lblText.applyStyle(labelFont:UIFont.applyOpenSansRegular(fontSize: 15.0) , labelColor: #colorLiteral(red: 0, green: 0.4509803922, blue: 0.7921568627, alpha: 1))
        }else{
            cell.imgLogo.image = #imageLiteral(resourceName: "logo-icon.png")
            cell.lblText.text = arryObjects[indexPath.row]
            cell.lblText.applyStyle(labelFont:UIFont.applyOpenSansRegular(fontSize: 15.0) , labelColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let lblTitle = UILabel.init(frame: CGRect(x: 0, y: 0, width:self.view.bounds.width, height: 50 * GConstant.Screen.HeightAspectRatio))
        lblTitle.applyStyle(labelFont:UIFont.applyBlocSSiBold(fontSize: 20) , labelColor: #colorLiteral(red: 0, green: 0.4509803922, blue: 0.7921568627, alpha: 1), cornerRadius: nil, borderColor: nil, borderWidth: nil, labelShadow: nil)
        lblTitle.text = " Get Cash Back on:"
        return lblTitle
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let lblTitle = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40 * GConstant.Screen.HeightAspectRatio))
        lblTitle.applyStyle(labelFont:UIFont.applyOpenSansBold(fontSize: 15) , labelColor: #colorLiteral(red: 0.2310000062, green: 0.2310000062, blue: 0.2310000062, alpha: 1) , cornerRadius: nil, borderColor: nil, borderWidth: nil, labelShadow: nil)
        lblTitle.textAlignment = .center
        lblTitle.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        lblTitle.text = "SHOP.SAVE.SIMPLE"
        return lblTitle
    }
}
