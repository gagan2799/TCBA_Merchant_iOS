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
    struct MatrixData: Codable {
        let headerTitle     :String
        var averageSpend    :String
        var totalPeople     :String
        var totalIncWeek    :String
        var totalIncYear    :String
        var UserMatrixData  :[SectionData]
    }
    
    struct SectionData: Codable {
        var totalUsers: Int
        var totalMatrixCash,percentage: Double
        var level,totalMatrixCashPending: Int
        var incWeek, incYear: String
    }
    
    //MARK: - Variables & Constants
    var arrMatrixData       = [MatrixData]()
    var modelUserMatrix     : GetUserMatrixModel!
    var totalSpend          : String!
    var header              : TMMatrixHeaderCell!
    var footer              : TMMatrixFooterCell!
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
    }
    //MARK: - Tupples
    func matrixCalculator(_ avrageSpend: Double, _ people: Int, _ percentage: Double) -> (incWeek: String, incYear: String) {
        let InWeek  = String.init(format: "%.2f", (Double(people) * percentage * avrageSpend)/100)
        let InYear  = String.init(format: "%.2f", ((Double(people) * percentage * avrageSpend)/100)*52)
        return (incWeek:InWeek, incYear:InYear)
    }
    
    func totalMatrix(matrixData: [SectionData]) -> (totalPeople: String, totalIncWeek: String, totalIncYear: String) {
        var people  : Double    = 0
        var incWeek : Double    = 0
        var incYear : Double    = 0
        for total in matrixData {
            //Adding values of totalpeople
            people += Double(total.totalUsers)
            //Adding values of incWeek
            if let doubleVal = NumberFormatter().number(from: total.incWeek)?.doubleValue {
                incWeek += doubleVal
            }
            //Adding values of totalSaveInYear
            if let doubleVal = NumberFormatter().number(from: total.incYear)?.doubleValue {
                incYear += doubleVal
            }
        }
        let totalPeople     = String.init(format: "%.0f", people)
        let totalIncWeek    = String.init(format: "%.2f", incWeek)
        let totalIncYear    = String.init(format: "%.2f", incYear)
        
        return (totalPeople,totalIncWeek,totalIncYear)
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
                
                var section1            = [SectionData]()
                var section2            = [SectionData]()
                for (indexArr , UserMatrix) in self.modelUserMatrix.userMatrix.enumerated() {
                    if indexArr > 0 && indexArr < 6 {
                        let total       = self.matrixCalculator(Double(self.totalSpend) ?? 0.00 , UserMatrix.totalUsers, indexArr == 1 ? 0.5 : 0.25)
                        section1.append(SectionData.init(totalUsers: UserMatrix.totalUsers, totalMatrixCash: UserMatrix.totalMatrixCash, percentage: indexArr == 1 ? 0.5 : 0.25, level: UserMatrix.level, totalMatrixCashPending: UserMatrix.totalMatrixCashPending, incWeek: total.incWeek, incYear: total.incYear))
                        section2.append(SectionData.init(totalUsers: 0, totalMatrixCash: UserMatrix.totalMatrixCash, percentage: indexArr == 1 ? 0.5 : 0.25, level: UserMatrix.level, totalMatrixCashPending: UserMatrix.totalMatrixCashPending, incWeek: "", incYear: ""))
                    }
                }
                let totalMatrix         = self.totalMatrix(matrixData: section1)
                self.arrMatrixData      = [MatrixData.init(headerTitle: "Weekly spend based on your average", averageSpend: self.totalSpend, totalPeople: totalMatrix.totalPeople, totalIncWeek: totalMatrix.totalIncWeek, totalIncYear: totalMatrix.totalIncYear, UserMatrixData: section1),
                                           MatrixData.init(headerTitle: "Example Shopping Community Income", averageSpend: "", totalPeople: "", totalIncWeek: "", totalIncYear: "", UserMatrixData: section2)]
                
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
        header = tableView.dequeueReusableCell(withIdentifier: "MatrixHeaderCell") as? TMMatrixHeaderCell
        header.txtAverageSpend.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        header.txtAverageSpend.setRightPaddingPoints(5.0)
        header.txtAverageSpend.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        
        header.lblTitle.text        = arrMatrixData[section].headerTitle
        header.txtAverageSpend.text = arrMatrixData[section].averageSpend
        header.txtAverageSpend.tag  = section
        header.txtAverageSpend.isUserInteractionEnabled = section == 0 ? false : true
        
        return header.contentView
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
        cell.txtPeople.tag          =  indexPath.section == 0 ? 1 : 10001;
        cell.txtPeople.isUserInteractionEnabled = indexPath.section == 0 ? false : true
        
        
        cell.lblLevel.text          = "Level \(String(describing: arrMatrixData[indexPath.section].UserMatrixData[indexPath.row].level))"
        cell.lblPercentage.text     = "\(arrMatrixData[indexPath.section].UserMatrixData[indexPath.row].percentage)"
        cell.txtPeople.text         = "\(String(describing: arrMatrixData[indexPath.section].UserMatrixData[indexPath.row].totalUsers))"
        cell.txtIncWeek.text        = arrMatrixData[indexPath.section].UserMatrixData[indexPath.row].incWeek
        cell.txtIncYear.text        = arrMatrixData[indexPath.section].UserMatrixData[indexPath.row].incYear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 45*GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footer = tableView.dequeueReusableCell(withIdentifier: "TMMatrixFooterCell") as? TMMatrixFooterCell
        footer.txtTotalPeople.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        footer.txtTotalIncWeek.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        footer.txtTotalIncYear.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 5.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        
        footer.txtTotalPeople.setRightPaddingPoints(5.0)
        footer.txtTotalIncWeek.setRightPaddingPoints(5.0)
        footer.txtTotalIncYear.setRightPaddingPoints(5.0)
        
        footer.txtTotalPeople.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        footer.txtTotalIncWeek.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        footer.txtTotalIncYear.setLeftPaddingPoints(10.0*GConstant.Screen.HeightAspectRatio)
        
        footer.txtTotalPeople.text  = arrMatrixData[section].totalPeople
        footer.txtTotalIncWeek.text = arrMatrixData[section].totalIncWeek
        footer.txtTotalIncYear.text = arrMatrixData[section].totalIncYear
        
        footer.txtTotalPeople.tag  = 100 + section
        footer.txtTotalIncWeek.tag = 200 + section
        footer.txtTotalIncYear.tag = 300 + section
        
        return footer.contentView
    }
    //MARK: - Textfield Delegates
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 10001 {
            guard let cell = textField.superview?.superview?.superview?.superview?.superview as? TMMatrixCell else { return true }
            guard let indexPath = tblMatrixCal.indexPath(for: cell) else { return true }
            if let peopleVal = NumberFormatter().number(from: cell.txtPeople?.text ?? "")?.intValue {
                // ====getting Header cell for AverageSpend value & set value to array====
                guard let txtAverage = header.contentView.viewWithTag(indexPath.section) as? UITextField else { return true }
                self.arrMatrixData[indexPath.section].averageSpend = txtAverage.text ?? ""
                guard let avarageSpendVal = NumberFormatter().number(from: txtAverage.text ?? "")?.doubleValue else { return true }
                
                // ====Getting values for incWeek & incYear====
                let values  = matrixCalculator(avarageSpendVal, peopleVal, arrMatrixData[indexPath.section].UserMatrixData[indexPath.row].percentage)
                
                let data    = SectionData.init(totalUsers: peopleVal, totalMatrixCash: self.arrMatrixData[indexPath.section].UserMatrixData[indexPath.row].totalMatrixCash, percentage: self.arrMatrixData[indexPath.section].UserMatrixData[indexPath.row].percentage, level: self.arrMatrixData[indexPath.section].UserMatrixData[indexPath.row].level, totalMatrixCashPending: self.arrMatrixData[indexPath.section].UserMatrixData[indexPath.row].totalMatrixCashPending, incWeek: values.incWeek, incYear: values.incYear)
                self.arrMatrixData[indexPath.section].UserMatrixData[indexPath.row] = data
                
                DispatchQueue.main.async {
                    cell.txtIncWeek.text   = self.arrMatrixData[indexPath.section].UserMatrixData[indexPath.row].incWeek
                    cell.txtIncYear.text   = self.arrMatrixData[indexPath.section].UserMatrixData[indexPath.row].incYear
                }
                
                //Getting Footer cell for Setting total values
                let totalVals   = self.totalMatrix(matrixData: arrMatrixData[indexPath.section].UserMatrixData)
                self.arrMatrixData[indexPath.section].totalPeople = totalVals.totalPeople
                self.arrMatrixData[indexPath.section].totalIncWeek = totalVals.totalIncWeek
                self.arrMatrixData[indexPath.section].totalIncYear = totalVals.totalIncYear
                
                DispatchQueue.main.async {
                    self.footer.txtTotalPeople.text  = totalVals.totalPeople
                    self.footer.txtTotalIncWeek.text = totalVals.totalIncWeek
                    self.footer.txtTotalIncYear.text = totalVals.totalIncYear
                }
            }
            return true
        }else{
            return true
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str             = textField.text as NSString? ?? ""
        let editedString    = str.replacingCharacters(in: range, with: string)
        let regex           = "\\d{0,4}(\\d{0,0})?"
        let predicate       = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: editedString)
    }
}
