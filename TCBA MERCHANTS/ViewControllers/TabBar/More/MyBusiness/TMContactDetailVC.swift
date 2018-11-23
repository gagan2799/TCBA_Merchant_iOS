//
//  TMContactDetailVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 06/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit
import PickerView

class TMContactDetailVC: UIViewController {
    
    struct storeDetailsElements: Codable {
        let title, placeholder, titleValue: String?
    }
    
    enum Places {
        case Country
        case State
    }
    
    //MARK: - Outlets
    //PickerView
    @IBOutlet weak var pickerV: PickerView!
    //UITableView
    @IBOutlet weak var tblContactDetails: UITableView!
    //UIButton
    @IBOutlet weak var btnSave          : UIButton!
    //Variables
    var isShowAddress                   = false
    var storeDetailsData                : StoreDetailsModel!
    var countries                       : CountriesModel!
    var states                          : StatesModel!
    var typesPlaces                     : Places = .Country
    var countryID                       = 0
    var stateID                         = 0
    
    
    
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if storeDetailsData == nil {
            callGetMerchantStoreDetailsApi()
        }
        
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
        self.navigationItem.title   = "Contact Details"
        
        pickerV.delegate            = self
        pickerV.dataSource          = self
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnSaveAct(_ sender: UIButton) {
        for item in contactDetailsData {
            if item.titleValue == "" && item.title != "" {
                if item.title != "ABN (Optional)" || item.title != "Business Name (Optional)" {
                    AlertManager.shared.showAlertTitle(title: "Incomplete Form", message: "\(item.title ?? "") field can't be empty")
                    return
                }
            }
            
            if item.title == "Store Email" && !item.titleValue!.isValidEmail() {
                AlertManager.shared.showAlertTitle(title: "Incomplete Form", message: GConstant.Message.kEmailTxtFieldMessage)
                return
            }
        }
        callPutUpdateStoreApi()
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
                if self.countries == nil {
                    self.callGetCountriesAndStatesApi(placeType: .Country)
                }
                guard let data = data else{return}
                self.storeDetailsData   = try? StoreDetailsModel.decode(_data: data)
                guard let bool          = self.storeDetailsData.showAddress else { return }
                self.isShowAddress      = bool
                guard let storedata     = self.storeDetailsData.storeAddress else { return }
                let arrContactDetails   = [
                    storeDetailsElements.init(title: "Store Title", placeholder: "Enter Store Title", titleValue: self.storeDetailsData.storeTitle),
                    storeDetailsElements.init(title: "Store Email", placeholder: "Enter Store Email", titleValue: self.storeDetailsData.storeEmail),
                    storeDetailsElements.init(title: "Street Address", placeholder: "Enter Street Address", titleValue: storedata.address),
                    storeDetailsElements.init(title: "", placeholder: "", titleValue: ""),
                    storeDetailsElements.init(title: "Suburb / City", placeholder: "Enter Suburb / City", titleValue: storedata.city),
                    storeDetailsElements.init(title: "Country", placeholder: "Choose Country", titleValue: storedata.countryName),
                    storeDetailsElements.init(title: "State", placeholder: "Choose State", titleValue: storedata.stateName),
                    storeDetailsElements.init(title: "Postcode", placeholder: "Enter Postcode", titleValue: storedata.postcode),
                    storeDetailsElements.init(title: "Store Phone Number", placeholder: "Enter Phone Number", titleValue: self.storeDetailsData.phoneNumber),
                    storeDetailsElements.init(title: "ABN (Optional)", placeholder: "Enter ABN", titleValue: self.storeDetailsData.abn),
                    storeDetailsElements.init(title: "Business Name (Optional)", placeholder: "Enter Business Name", titleValue: self.storeDetailsData.businessName)]
                
                self.contactDetailsData = arrContactDetails
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
    
    func callGetCountriesAndStatesApi(placeType type: Places, CountryId Id: String = "") {
        /*
         =====================API CALL=====================
         APIName    : GetCountriesAndStates
         Url        : "/Stores/GetMerchantStoreDetails"
         Method     : GET
         Parameters : { storeID : "" }
         ===================================================
         */
        let request             = RequestModal.mUserData()
        var url                 = ""
        if type == .Country {
            url                 = GAPIConstant.Url.GetCountries
        } else {
            url                 = GAPIConstant.Url.GetStates
            request.countryId   = Id
        }
        
        ApiManager.shared.GETWithBearerAuth(strURL: url, parameter: type == .Country ? nil: request.toDictionary(), withLoader : false) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else{return}
                self.typesPlaces = type
                switch type {
                case .Country:
                    self.countries  = try? CountriesModel.decode(_data: data)
                    if self.states == nil {
                        self.callGetCountriesAndStatesApi(placeType: .State, CountryId:"\(self.countries.countries?.first?.countryID ?? 284)")
                    }
                    break
                case .State:
                    self.states     = try? StatesModel.decode(_data: data)
                    if self.countries == nil {
                        self.callGetCountriesAndStatesApi(placeType: .Country)
                    }
                    break
                }
                self.pickerV.reloadPickerView()
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
         Parameters : { days  : [String : Any] }
         ===================================================
         */
        self.view.endEditing(true)
        
        if let allStates = states.states {
            for state in allStates {
                if state.stateName == contactDetailsData[6].titleValue {
                    stateID = state.stateID ?? 0
                }
            }
        }
        
        
        if let allCountry = countries.countries {
            for country in allCountry {
                if country.countryName == contactDetailsData[5].titleValue {
                    countryID = country.countryID ?? 0
                }
            }
        }
        
        let requestAddress          = RequestModal.mUpdateStoreAddress()
        requestAddress.address      = contactDetailsData[2].titleValue
        requestAddress.postcode     = Int(contactDetailsData[7].titleValue!)
        requestAddress.countryId    = countryID
        requestAddress.stateId      = stateID
        requestAddress.city         = contactDetailsData[4].titleValue
        
        let request                 = RequestModal.mUpdateStoreContent()
        guard let storeId           = GConstant.UserData.stores else{ return }
        request.storeAddress        = requestAddress.toDictionary()
        request.storeId             = storeId
        request.storeTitle          = contactDetailsData[0].titleValue
        request.storeEmail          = contactDetailsData[1].titleValue
        request.showAddress         = NSNumber.init(value: isShowAddress) as? Int
        request.phoneNumber         = contactDetailsData[8].titleValue
        request.abn                 = contactDetailsData[9].titleValue
        request.businessName        = contactDetailsData[10].titleValue
        
        ApiManager.shared.PUTWithBearerAuth(strURL: GAPIConstant.Url.PutUpdateStore, parameter:request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                AlertManager.shared.showAlertTitle(title: "Success", message: GConstant.Message.kUpdatesSaveMessage, buttonsArray: ["OK"]) { (buttonIndex : Int) in
                    switch buttonIndex {
                    case 0 :
                        //OK clicked
                        self.navigationController?.popViewController(animated: true)
                        break
                    default:
                        break
                    }
                }
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

extension TMContactDetailVC: UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PickerViewDelegate,PickerViewDataSource{
    
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
            return contactRadioCell(tableView: tableView, cellForRowAt: indexPath)
        } else {
            return contactDetailsCell(tableView: tableView, cellForRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - Table cells
    func contactDetailsCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailsCell") as! TMContactDetailsCell
        //Setting fonts
        cell.lblTitle.font              = UIFont.applyOpenSansRegular(fontSize: 12.0)
        cell.txtTitleVal.font           = UIFont.applyOpenSansRegular(fontSize: 14.0)
        
        //Setting textfiels placeholder
        cell.txtTitleVal.placeholder    = contactDetailsData[indexPath.row].placeholder
        
        //Setting tag
        cell.txtTitleVal.tag            = indexPath.row
        
        //Setting values
        cell.lblTitle.text              = contactDetailsData[indexPath.row].title
        cell.txtTitleVal.text           = contactDetailsData[indexPath.row].titleValue
        
        if indexPath.row == 1 {
            cell.txtTitleVal.keyboardType  = .emailAddress
        } else if indexPath.row == 5 || indexPath.row == 6{
            cell.txtTitleVal.inputView = self.pickerV
        } else if indexPath.row == 7 || indexPath.row == 9 {
            cell.txtTitleVal.keyboardType   = UIDevice.current.userInterfaceIdiom == .pad ? .numbersAndPunctuation: .numberPad
        } else if indexPath.row == 8 {
            cell.txtTitleVal.keyboardType   = UIDevice.current.userInterfaceIdiom == .pad ? .numbersAndPunctuation: .phonePad
        } else {
            cell.txtTitleVal.keyboardType  = .default
        }
        return cell
    }
    
    func contactRadioCell(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactRadioCell") as! TMContactRadioCell
        //Setting fonts
        
        DispatchQueue.main.async {
            cell.lblInfo.font               = UIFont.applyOpenSansRegular(fontSize: 15.0)
            cell.btnNo.titleLabel?.font     = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
            cell.btnYes.titleLabel?.font    = UIFont.applyOpenSansSemiBold(fontSize: 15.0)
            //Setting buttons tag
            cell.btnNo.tag                  = indexPath.row
            cell.btnYes.tag                 = indexPath.row
            if self.isShowAddress {
                cell.btnNo.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
                cell.btnYes.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
            } else {
                cell.btnNo.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
                cell.btnYes.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
            }
            cell.btnNo.addTarget(self, action: #selector(self.btnNoAct), for: .touchUpInside)
            cell.btnYes.addTarget(self, action: #selector(self.btnYesAct), for: .touchUpInside)
        }
        
        return cell
    }
    
    //MARK: - UITextfield delegates
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
        textField.inputView = nil
        if textField.tag == 5 || textField.tag == 6{
            textField.inputView = self.pickerV
        }
        if textField.tag == 5 {
            self.typesPlaces = .Country
            if self.countries == nil {
                self.callGetCountriesAndStatesApi(placeType: .Country)
            }
            self.pickerV.reloadPickerView()
        } else if textField.tag == 6 {
            self.typesPlaces = .State
            if self.states == nil {
                self.callGetCountriesAndStatesApi(placeType: .State, CountryId:"\(String(describing: self.countries.countries?.first?.countryID))")
            }
            self.pickerV.reloadPickerView()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        contactDetailsData[textField.tag] = storeDetailsElements.init(title: contactDetailsData[textField.tag].title, placeholder: contactDetailsData[textField.tag].placeholder, titleValue: textField.text)
        tblContactDetails.reloadRows(at: [IndexPath(row: textField.tag, section: 0)], with: .none)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 7 || textField.tag == 8 || textField.tag == 9 {
            let newLength = (textField.text?.count)! + string.count - range.length
            if newLength > 11 { return false }
            
            let compSepByCharInSet  = string.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted)
            
            let strFiltered         = compSepByCharInSet.joined(separator: "")
            
            if string == strFiltered {
                let nsStr           = textField.text as NSString? ?? ""
                let str             = nsStr.replacingCharacters(in: range, with: string).replacingOccurrences(of: ".", with: "")
                let range: NSRange  = (str as NSString).range(of: "^0*", options: .regularExpression)
                textField.text      = (str as NSString).replacingCharacters(in: range, with: "")
            }
            return false
        } else {
            contactDetailsData[textField.tag] = storeDetailsElements.init(title: contactDetailsData[textField.tag].title, placeholder: contactDetailsData[textField.tag].placeholder, titleValue: textField.text)
            print(textField.text as Any)
            return true
        }
    }
    
    //MARK: - PickerView Datasource and Delegates
    func pickerViewHeightForRows(_ pickerView: PickerView) -> CGFloat {
        return 50*GConstant.Screen.HeightAspectRatio
    }
    
    func pickerViewNumberOfRows(_ pickerView: PickerView) -> Int {
        guard countries != nil, states != nil else {return 0}
        if typesPlaces == .Country {
            guard let count = countries.countries?.count else { return 0 }
            return count
        } else {
            guard let count = states.states?.count else { return 0 }
            return count
        }
    }
    
    func pickerView(_ pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        if typesPlaces == .Country {
            guard let countriesData = countries.countries else { return "" }
            guard let name          = countriesData[index].countryName else { return "" }
            return name
        } else {
            guard let statesData    = states.states else { return "" }
            guard let name          = statesData[index].stateName else { return "" }
            return name
        }
    }
    
    func pickerView(_ pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        label.textAlignment = .center
        if (!highlighted) {
            label.textColor = GConstant.AppColor.textLight
            label.font = UIFont.applyOpenSansRegular(fontSize: 16.0)
        } else {
            label.textColor = GConstant.AppColor.blue
            label.font = UIFont.applyOpenSansRegular(fontSize: 24.0)
        }
    }
    
    func pickerView(_ pickerView: PickerView, didSelectRow row: Int, index: Int) {
        if typesPlaces == .Country {
            let cell = tblContactDetails.cellForRow(at: IndexPath(row: 5, section: 0)) as! TMContactDetailsCell
            guard let countriesData = countries.countries else { return }
            guard let name          = countriesData[index].countryName else { return }
            guard let countryId     = countriesData[index].countryID else { return }
            self.countryID          = countryId
            cell.txtTitleVal.text   = name
        } else {
            let cell = tblContactDetails.cellForRow(at: IndexPath(row: 6, section: 0)) as! TMContactDetailsCell
            guard let statesData    = states.states else { return }
            guard let name          = statesData[index].stateName else { return }
            guard let stateId       = statesData[index].stateID else { return }
            self.stateID            = stateId
            cell.txtTitleVal.text   = name
        }
    }
}
