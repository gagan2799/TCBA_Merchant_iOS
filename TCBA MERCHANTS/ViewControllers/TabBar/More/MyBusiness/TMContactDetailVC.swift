//
//  TMContactDetailVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 06/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMContactDetailVC: UIViewController {

    struct storeDetailsElements: Codable {
        let title, placeholder, titleValue: String?
    }
    
    //MARK: - Outlets
    //UITableView
    @IBOutlet weak var tblContactDetails: UITableView!
    //UIButton
    @IBOutlet weak var btnSave          : UIButton!
    //Variables
    var isShowAddress                   = false
    var storeDetailsData                : StoreDetailsModel!
    var contactDetailsData              =
        [storeDetailsElements.init(title: "Store Title", placeholder: "Enter Store Title", titleValue: ""),
         storeDetailsElements.init(title: "Store Email", placeholder: "Enter Store Email", titleValue: ""),
         storeDetailsElements.init(title: "Street Address", placeholder: "Enter Street Address", titleValue: ""),
         storeDetailsElements.init(title: "", placeholder: "", titleValue: ""),
         storeDetailsElements.init(title: "Suburb / City", placeholder: "Enter Suburb / City", titleValue: ""),
         storeDetailsElements.init(title: "Country", placeholder: "Choose Country", titleValue: ""),
         storeDetailsElements.init(title: "State", placeholder: "Choose State", titleValue: ""),
         storeDetailsElements.init(title: "Postcode", placeholder: "Enter Postcode", titleValue: ""),
         storeDetailsElements.init(title: "Store Phone Number", placeholder: "Enter Phone Number", titleValue: ""),
         storeDetailsElements.init(title: "ABN (Optional)", placeholder: "Enter ABN", titleValue: ""),
         storeDetailsElements.init(title: "Business Name (Optional)", placeholder: "Enter Business Name", titleValue: "")]
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
        callGetMerchantStoreDetailsApi()
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
        self.navigationItem.title = "Contact Details"
    }

    //MARK: - UIButton Action Methods
    @IBAction func btnSaveAct(_ sender: UIButton) {
        
    }
    
    @objc func btnNoAct(sender: UIButton){
        isShowAddress = false
        tblContactDetails.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
    }
    
    @objc func btnYesAct(sender: UIButton){
        isShowAddress = true
        tblContactDetails.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
    }

    //MARK: - Web Api's
    func callGetMerchantStoreDetailsApi() {
        /*
         =====================API CALL=====================
         APIName    : GetMerchantStoreDetails
         Url        : "/Stores/GetMerchantStoreDetails"
         Method     : GET
         Parameters : { storeID : "" }
         ===================================================
         */
        let request         = RequestModal.mUserData()
        guard let storeId   = GConstant.UserData.stores else{return}
        request.storeID     = storeId
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetMerchantStoreDetails, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else{return}
                self.storeDetailsData   = try? StoreDetailsModel.decode(_data: data)
                guard let bool          = self.storeDetailsData.showAddress else { return }
                self.isShowAddress      = bool
                self.tblContactDetails.reloadData()
            }else{
                if let data = data{
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        let str = String.init(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
                        AlertManager.shared.showAlertTitle(title: "Error" ,message:str)
                        return
                    }
                    print(json as Any)
                    AlertManager.shared.showAlertTitle(title: "Error" ,message: json?["message"] as? String ?? GConstant.Message.kSomthingWrongMessage)
                }else{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
            }
        }
    }
    
    func callPutUpdateStoreApi() {
        /*
         =====================API CALL=====================
         APIName    : PutUpdateStore
         Url        : "/Stores/PutUpdateStore"
         Method     : PUT
         Parameters : { days  : [[:]] }
         ===================================================
         */
//        let daysData = try! tradingData.days.encode()
//        let request = RequestModal.mUpdateStoreContent()
//        guard let storeId   = GConstant.UserData.stores else{return}
//        request.days        = daysData
        
        ApiManager.shared.PUTWithBearerAuth(strURL: GAPIConstant.Url.PutUpdateStore, parameter:nil) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                AlertManager.shared.showAlertTitle(title: "Success", message: "Your updates have been saved.")
            }else{
                if let data = data{
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        let str = String.init(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
                        AlertManager.shared.showAlertTitle(title: "Error" ,message:str)
                        return
                    }
                    print(json as Any)
                    AlertManager.shared.showAlertTitle(title: "Error" ,message: json?["message"] as? String ?? GConstant.Message.kSomthingWrongMessage)
                }else{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }
            }
        }
    }
}

extension TMContactDetailVC: UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{
    // MARK: - UITableView Delegates & Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDetailsData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 80 * GConstant.Screen.HeightAspectRatio
        } else {
            return 60 * GConstant.Screen.HeightAspectRatio
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactRadioCell") as! TMContactRadioCell
            //Setting fonts
            cell.lblInfo.font               = UIFont.applyOpenSansRegular(fontSize: 15.0)
            cell.btnNo.titleLabel?.font     = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
            cell.btnYes.titleLabel?.font    = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
        
            //Setting buttons tag
            cell.btnNo.tag                  = indexPath.row
            cell.btnYes.tag                 = indexPath.row
            
            if isShowAddress {
                cell.btnNo.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
                cell.btnYes.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
            } else {
                cell.btnNo.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
                cell.btnYes.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
            }
            
            cell.btnNo.addTarget(self, action: #selector(btnNoAct), for: .touchUpInside)
            cell.btnYes.addTarget(self, action: #selector(btnYesAct), for: .touchUpInside)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailsCell") as! TMContactDetailsCell
            //Setting fonts
            cell.lblTitle.font              = UIFont.applyOpenSansRegular(fontSize: 14.0)
            cell.txtTitleVal.font           = UIFont.applyOpenSansRegular(fontSize: 15.0)
            
            //Setting textfiels placeholder
            cell.txtTitleVal.placeholder    = contactDetailsData[indexPath.row].placeholder
            
            //Setting tag
            cell.txtTitleVal.tag            = indexPath.row
            
            //Setting values
            cell.lblTitle.text              = contactDetailsData[indexPath.row].title
            cell.txtTitleVal.text           = contactDetailsData[indexPath.row].titleValue
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK:UITextfield delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            
        } else if textField.tag == 1 {
            
        } else if textField.tag == 2 {
            
        } else if textField.tag == 3 {
            
        } else if textField.tag == 4 {
            
        } else if textField.tag == 5 {
            
        } else if textField.tag == 6 {
            
        } else if textField.tag == 7 {
            
        } else if textField.tag == 8 {
            
        } else if textField.tag == 9 {
            
        } else if textField.tag == 10 {
            
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            textField.keyboardType  = .emailAddress
        }  else if textField.tag == 7 || textField.tag == 9 {
            textField.keyboardType  = .numberPad
        } else if textField.tag == 8 {
            textField.keyboardType  = .phonePad
        } else {
            textField.keyboardType  = .default
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        contactDetailsData[textField.tag] = storeDetailsElements.init(title: contactDetailsData[textField.tag].title, placeholder: contactDetailsData[textField.tag].placeholder, titleValue: textField.text)
        tblContactDetails.reloadRows(at: [IndexPath(row: textField.tag, section: 0)], with: .none)
    }
}
