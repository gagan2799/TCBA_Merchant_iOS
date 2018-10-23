//
//  TMMatrixCalculatorVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMMatrixCalculatorVC: UIViewController {
    //MARK: - Structure
    struct MatrixData {
        let headerTitle     :String
        let averageSpend    :String
        let UserMatrixData  :[UserMatrix]
    }
    
    
    //MARK: - Variables & Constants
    var arrMatrixData       = [MatrixData]()
    var modelUserMatrix     : GetUserMatrixModel!
    var totalSpend          : String!
    
    //MARK: Outlets
    //UITableView
    @IBOutlet weak var tblMatrixCal: UITableView!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
        callGetUserMatrixApi()
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
        
        //        txtTotalSpndWeek.setRightPaddingPoints(5.0)
        //        txtTotalSaveWeek.setRightPaddingPoints(5.0)
        //        txtTotalSaveYear.setRightPaddingPoints(5.0)
        //
        //        txtTotalSpndWeek.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        //        txtTotalSaveWeek.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        //        txtTotalSaveYear.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
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
        //        for section in arrCalculator {
        //            guard let sec = section.sectionData else {return ("","","")}
        //            for totalSpend in sec {
        //                //Adding values of totalSpendVal
        //                if let doubleVal = NumberFormatter().number(from: totalSpend.txt1 ?? "")?.doubleValue {
        //                    totalSpendVal += doubleVal
        //                }
        //                //Adding values of totalSaveInWeek
        //                if let doubleVal = NumberFormatter().number(from: totalSpend.txt2 ?? "")?.doubleValue {
        //                    totalSaveInWeek += doubleVal
        //                }
        //                //Adding values of totalSaveInYear
        //                if let doubleVal = NumberFormatter().number(from: totalSpend.txt3 ?? "")?.doubleValue {
        //                    totalSaveInYear += doubleVal
        //                }
        //            }
        //        }
        
        let totalSpend  = String.init(format: "%.2f", totalSpendVal)
        let saveInWeek  = String.init(format: "%.2f", totalSaveInWeek)
        let saveInYear  = String.init(format: "%.2f", totalSaveInYear)
        
        return (totalSpend,saveInWeek,saveInYear)
    }
    
    //MARK: - Web Api's
    func callGetUserMatrixApi() {
        /*
         =====================API CALL=====================
         APIName    : GetUserMatrix
         Url        : "/UserMatrix/GetUserMatrix"
         Method     : GET
         Parameters : nil
         ===================================================
         */
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetUserMatrix, parameter: nil) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let mData         = data else{return}
                self.modelUserMatrix    = GetUserMatrixModel.decodeData(_data: mData).response
                self.arrMatrixData      = [MatrixData.init(headerTitle: "Weekly spend based on your average", averageSpend: "", UserMatrixData: self.modelUserMatrix.userMatrix)]
                self.tblMatrixCal.reloadData()
            }else{
                if statusCode == 404{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
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
}

extension TMMatrixCalculatorVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK: TableView Delegates & DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrMatrixData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "MatrixHeaderCell") as! TMMatrixHeaderCell
        header.txtAverageSpend.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        header.txtAverageSpend.setRightPaddingPoints(5.0)
        header.txtAverageSpend.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        
        header.lblTitle.text        = arrMatrixData[section].headerTitle
        header.txtAverageSpend.text = totalSpend
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 125 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrMatrixData[section].UserMatrixData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatrixCell") as! TMMatrixCell
        cell.lblLevel.font              = UIFont.applyOpenSansRegular(fontSize: 14.0)
        cell.lblPercentage.font         = UIFont.applyOpenSansRegular(fontSize: 14.0)
        cell.txtPeople.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        cell.txtIncWeek.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        cell.txtIncYear.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        
        cell.txtPeople.setRightPaddingPoints(5.0)
        cell.txtIncWeek.setRightPaddingPoints(5.0)
        cell.txtIncYear.setRightPaddingPoints(5.0)
        
        cell.txtPeople.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        cell.txtIncWeek.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        cell.txtIncYear.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        
        cell.txtPeople.keyboardType = UIDevice.current.userInterfaceIdiom == .pad ? .numbersAndPunctuation: .numberPad
        cell.txtPeople.tag          = 10001;
        cell.lblLevel.text          = "Level \(arrMatrixData[indexPath.section].UserMatrixData[indexPath.row].level)"
        cell.lblPercentage.text     = "0.20"
        cell.txtPeople.text         = "\(arrMatrixData[indexPath.section].UserMatrixData[indexPath.row].totalUsers)"
        cell.txtIncWeek.text        = ""
        cell.txtIncYear.text        = ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 45*GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.dequeueReusableCell(withIdentifier: "TMMatrixFooterCell") as! TMMatrixFooterCell
        
        footer.txtTotalPeople.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        footer.txtTotalIncWeek.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        footer.txtTotalIncYear.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        
        footer.txtTotalPeople.setRightPaddingPoints(5.0)
        footer.txtTotalIncWeek.setRightPaddingPoints(5.0)
        footer.txtTotalIncYear.setRightPaddingPoints(5.0)
        
        footer.txtTotalPeople.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        footer.txtTotalIncWeek.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        footer.txtTotalIncYear.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        
        return footer
    }
    //MARK: - Textfield Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //        if textField.tag == 10001 {
        //            guard let cell = textField.superview?.superview?.superview?.superview?.superview as? TMCalculatorCell else { return false }
        //            guard let indexPath = tblMatrixCal.indexPath(for: cell) else { return false }
        //            if let doubleVal = NumberFormatter().number(from: cell.txtSpendWeek?.text ?? "")?.doubleValue {
        //                let values  = savingCalculator(doubleVal, arrCalculator[indexPath.section].sectionData?[indexPath.row].percentage ?? 0)
        //                let data    = SectionData.init(company: arrCalculator[indexPath.section].sectionData?[indexPath.row].company, data: arrCalculator[indexPath.section].sectionData?[indexPath.row].data, percentage: arrCalculator[indexPath.section].sectionData?[indexPath.row].percentage, txt1: textField.text, txt2: values.savingInWeek, txt3: values.savingInYear)
        //                self.arrCalculator[indexPath.section].sectionData?[indexPath.row] = data
        //                DispatchQueue.main.async {
        //                    cell.txtSaveWeek.text   = self.arrCalculator[indexPath.section].sectionData?[indexPath.row].txt2
        //                    cell.txtSaveYear.text   = self.arrCalculator[indexPath.section].sectionData?[indexPath.row].txt3
        //                }
        //            }else{
        //                let data    = SectionData.init(company: arrCalculator[indexPath.section].sectionData?[indexPath.row].company, data: arrCalculator[indexPath.section].sectionData?[indexPath.row].data, percentage: arrCalculator[indexPath.section].sectionData?[indexPath.row].percentage, txt1: "", txt2: "", txt3: "")
        //                self.arrCalculator[indexPath.section].sectionData?[indexPath.row] = data
        //                DispatchQueue.main.async {
        //                    cell.txtSaveWeek.text   = self.arrCalculator[indexPath.section].sectionData?[indexPath.row].txt2
        //                    cell.txtSaveYear.text   = self.arrCalculator[indexPath.section].sectionData?[indexPath.row].txt3
        //                }
        //            }
        //            return true
        //        }else{
        return false
        //        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str             = textField.text as NSString? ?? ""
        let editedString    = str.replacingCharacters(in: range, with: string)
        let regex           = "\\d{0,4}(\\d{0,0})?"
        let predicate       = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: editedString)
    }
}
