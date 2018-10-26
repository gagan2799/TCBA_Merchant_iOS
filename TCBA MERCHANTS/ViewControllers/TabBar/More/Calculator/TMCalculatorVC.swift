//
//  TMCalculatorVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 05/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMCalculatorVC: UIViewController {
    
    struct CalculatorSection: Codable {
        let section: String?
        var sectionData: [SectionData]?
    }
    
    struct SectionData: Codable {
        var company, data : String?
        var percentage: Double?
        var txt1, txt2, txt3: String?
    }
    
    //MARK: Variables & Constants
    var arrCalculator = [CalculatorSection]()
    
    //MARK: Outlets
    //Constraints
    @IBOutlet weak var consHeightBotmView: NSLayoutConstraint!
    //UITextfield
    @IBOutlet weak var txtTotalSpndWeek: UITextField!
    
    @IBOutlet weak var txtTotalSaveWeek: UITextField!
    
    @IBOutlet weak var txtTotalSaveYear: UITextField!
    //UIBUTTON
    @IBOutlet weak var btnCalculate: UIButton!
    
    //UITableView
    @IBOutlet weak var tblCalculator: UITableView!
    @IBOutlet weak var btnShoppingComu: UIButton!
    
    //MARK: - View Life Cycle
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
    //MARK:- Set View Properties
    func setViewProperties() {
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title   = "Cash Back Calculator"
        arrInit()
        
        txtTotalSpndWeek.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 12.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        txtTotalSaveWeek.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 12.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        txtTotalSaveYear.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 12.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        
        txtTotalSpndWeek.setRightPaddingPoints(5.0)
        txtTotalSaveWeek.setRightPaddingPoints(5.0)
        txtTotalSaveYear.setRightPaddingPoints(5.0)
        
        txtTotalSpndWeek.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        txtTotalSaveWeek.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        txtTotalSaveYear.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        
        btnCalculate.applyStyle(titleLabelFont: UIFont.applyOpenSansSemiBold(fontSize: 12.0), titleLabelColor: UIColor.white, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.white, borderWidth: 0.5, state: .normal, backgroundColor: UIColor.black, backgroundOpacity: nil)
        
        btnShoppingComu.applyStyle(titleLabelFont: UIFont.applyOpenSansSemiBold(fontSize: 12.0), titleLabelColor: UIColor.white, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: nil, borderWidth: nil, state: .normal, backgroundColor: GConstant.AppColor.orange, backgroundOpacity: nil)
        
        consHeightBotmView.constant = 0.24*GConstant.Screen.Height
        self.view.layoutIfNeeded()
    }
    //MARK: - Coustom Methods
    func arrInit() {
        let section1 = CalculatorSection.init(section: "National Brand Discounts with Gift Cards", sectionData: [
            SectionData.init(company: "Woolworths", data: "Groceries", percentage: 3, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "CALTEX", data: "Petrol", percentage: 3, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "Dan Murphy's", data: "Liquor", percentage: 3, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "Big W", data: "Homewares", percentage: 5, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "Masters", data: "Furniture", percentage: 5, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "BCF", data: "Recreation", percentage: 4, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "Ray's", data: "Outdoors", percentage: 4, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "Super Cheap", data: "Automotive", percentage: 4, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "Amart & Rebel", data: "Sports", percentage: 4, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "JB HiFi", data: "Electronics", percentage: 3, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "_", data: "Leisure", percentage: 5, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "_", data: "Health & Beauty", percentage: 4, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "_", data: "Clothing", percentage: 5, txt1: "", txt2: "", txt3: "")]
        )
        
        let section2 = CalculatorSection.init(section: "Services & Utilities", sectionData: [
            SectionData.init(company: "", data: "Telephone Internet", percentage: 1, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "", data: "Insurance", percentage: 1, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "", data: "Mortgage", percentage: 1, txt1: "", txt2: "", txt3: "")])
        
        let section3 = CalculatorSection.init(section: "Local Retail Cash Back & Loyalty", sectionData: [
            SectionData.init(company: "", data: "Dining Out", percentage: 7, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "", data: "Beauty", percentage: 7, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "", data: "Clothing", percentage: 7, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "", data: "Homewares", percentage: 7, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "", data: "Groceries", percentage: 7, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "", data: "Dry Cleaning", percentage: 7, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "", data: "Trade Services", percentage: 7, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "", data: "Recreation", percentage: 7, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "", data: "Pet Care", percentage: 7, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "", data: "Fitness", percentage: 7, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "", data: "Auto Services", percentage: 7, txt1: "", txt2: "", txt3: ""),
            SectionData.init(company: "", data: "Other", percentage: 7, txt1: "", txt2: "", txt3: "")])
        
        arrCalculator.insert(section1, at: 0)
        arrCalculator.insert(section2, at: 1)
        arrCalculator.insert(section3, at: 2)
    }
    
    //MARK: - Tupples
    func savingCalculator(_ spendInWeek: Double, _ percentage:Double) -> (savingInWeek: String, savingInYear: String) {
        let saveInWeek  = String.init(format: "%.2f", (spendInWeek / 100)*percentage)
        let saveInYear  = String.init(format: "%.2f", ((spendInWeek / 100)*percentage)*52)
        return (savingInWeek:saveInWeek, savingInYear:saveInYear)
    }
    
    func totalSpendAndSaving() -> (totalSpend: String, totalSaveInWeek: String, totalSaveInYear: String) {
        var totalSpendVal   : Double    = 0
        var totalSaveInWeek : Double    = 0
        var totalSaveInYear : Double    = 0
        for section in arrCalculator {
            guard let sec = section.sectionData else {return ("","","")}
            for totalSpend in sec {
                //Adding values of totalSpendVal
                if let doubleVal = NumberFormatter().number(from: totalSpend.txt1 ?? "")?.doubleValue {
                    totalSpendVal += doubleVal
                }
                //Adding values of totalSaveInWeek
                if let doubleVal = NumberFormatter().number(from: totalSpend.txt2 ?? "")?.doubleValue {
                    totalSaveInWeek += doubleVal
                }
                //Adding values of totalSaveInYear
                if let doubleVal = NumberFormatter().number(from: totalSpend.txt3 ?? "")?.doubleValue {
                    totalSaveInYear += doubleVal
                }
            }
        }
        
        let totalSpend  = String.init(format: "%.2f", totalSpendVal)
        let saveInWeek  = String.init(format: "%.2f", totalSaveInWeek)
        let saveInYear  = String.init(format: "%.2f", totalSaveInYear)
        
        return (totalSpend,saveInWeek,saveInYear)
    }
    
    //MARK: - UIButton Action Methods
    @IBAction func btnCalculatorAction(_ sender: UIButton) {
        view.endEditing(true)
        let total               = totalSpendAndSaving()
        txtTotalSpndWeek.text   = total.totalSpend
        txtTotalSaveWeek.text   = total.totalSaveInWeek
        txtTotalSaveYear.text   = total.totalSaveInYear
    }
    
    @IBAction func btnShoppingCalAction(_ sender: UIButton) {
        if txtTotalSpndWeek.text == "" || txtTotalSpndWeek.text == "0.00" {
            AlertManager.shared.showAlertTitle(title: "", message: "You must put values into the yellow boxes and tap the 'Calculate' before you can go to Matrix Calculator.")
        }else{
            let obj = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.MatrixCalculator) as! TMMatrixCalculatorVC
            obj.totalSpend = txtTotalSpndWeek.text
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
    
    //MARK: - Web Api's
    
}

extension TMCalculatorVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK: TableView Delegates & DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrCalculator.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalculatorHeader") as! TMCalculatorHeaderCell
        cell.lblTitle.text  = arrCalculator[section].section
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrCalculator[section].sectionData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalculatorCell") as! TMCalculatorCell
        cell.lblName.font       = UIFont.applyOpenSansRegular(fontSize: 14.0)
        cell.lblPercentage.font = UIFont.applyOpenSansRegular(fontSize: 14.0)
        cell.txtSpendWeek.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        cell.txtSaveWeek.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        cell.txtSaveYear.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        
        cell.txtSpendWeek.setRightPaddingPoints(5.0)
        cell.txtSaveWeek.setRightPaddingPoints(5.0)
        cell.txtSaveYear.setRightPaddingPoints(5.0)
        
        cell.txtSpendWeek.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        cell.txtSaveWeek.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        cell.txtSaveYear.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        
        cell.txtSpendWeek.keyboardType  = UIDevice.current.userInterfaceIdiom == .pad ? .numbersAndPunctuation: .numberPad
        cell.txtSpendWeek.tag   = 10001;
        cell.lblName.text       = arrCalculator[indexPath.section].sectionData?[indexPath.row].data
        cell.lblPercentage.text = "\(arrCalculator[indexPath.section].sectionData?[indexPath.row].percentage ?? 0)"
        cell.txtSpendWeek.text  = arrCalculator[indexPath.section].sectionData?[indexPath.row].txt1
        cell.txtSaveWeek.text   = arrCalculator[indexPath.section].sectionData?[indexPath.row].txt2
        cell.txtSaveYear.text   = arrCalculator[indexPath.section].sectionData?[indexPath.row].txt3
        return cell
    }
    
    //MARK: - Textfield Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 10001 {
            guard let cell = textField.superview?.superview?.superview?.superview?.superview as? TMCalculatorCell else { return false }
            guard let indexPath = tblCalculator.indexPath(for: cell) else { return false }
            if let doubleVal = NumberFormatter().number(from: cell.txtSpendWeek?.text ?? "")?.doubleValue {
                let values  = savingCalculator(doubleVal, arrCalculator[indexPath.section].sectionData?[indexPath.row].percentage ?? 0)
                let data    = SectionData.init(company: arrCalculator[indexPath.section].sectionData?[indexPath.row].company, data: arrCalculator[indexPath.section].sectionData?[indexPath.row].data, percentage: arrCalculator[indexPath.section].sectionData?[indexPath.row].percentage, txt1: textField.text, txt2: values.savingInWeek, txt3: values.savingInYear)
                self.arrCalculator[indexPath.section].sectionData?[indexPath.row] = data
                DispatchQueue.main.async {
                    cell.txtSaveWeek.text   = self.arrCalculator[indexPath.section].sectionData?[indexPath.row].txt2
                    cell.txtSaveYear.text   = self.arrCalculator[indexPath.section].sectionData?[indexPath.row].txt3
                }
            }else{
                let data    = SectionData.init(company: arrCalculator[indexPath.section].sectionData?[indexPath.row].company, data: arrCalculator[indexPath.section].sectionData?[indexPath.row].data, percentage: arrCalculator[indexPath.section].sectionData?[indexPath.row].percentage, txt1: "", txt2: "", txt3: "")
                self.arrCalculator[indexPath.section].sectionData?[indexPath.row] = data
                DispatchQueue.main.async {
                    cell.txtSaveWeek.text   = self.arrCalculator[indexPath.section].sectionData?[indexPath.row].txt2
                    cell.txtSaveYear.text   = self.arrCalculator[indexPath.section].sectionData?[indexPath.row].txt3
                }
            }
            return true
        }else{
            return false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str             = textField.text as NSString? ?? ""
        let editedString    = str.replacingCharacters(in: range, with: string)
        let regex           = "\\d{0,4}(\\d{0,0})?"
        let predicate       = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: editedString)
    }
}
