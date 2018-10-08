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
        let sectionData: [SectionData]?
    }
    
    struct SectionData: Codable {
        let company, data : String?
        let percentage: Double?
    }
    //MARK: Variables & Constants
    var arrCalculator = [CalculatorSection]()
    
    //MARK: Outlets
    
    //UITableView
    @IBOutlet weak var tblCalculator: UITableView!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
        
        let value = savingCalculator(85.2, 1)
        
        print(value.savingInWeek)
        print(value.savingInYear)
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
    }
    //MARK: - Coustom Methods
    func arrInit() {
        let section1 = CalculatorSection.init(section: "National Brand Discounts with Gift Cards", sectionData: [
            SectionData.init(company: "Woolworths", data: "Groceries", percentage: 2),
            SectionData.init(company: "CALTEX", data: "Petrol", percentage: 2),
            SectionData.init(company: "Dan Murphy's", data: "Liquor", percentage: 2),
            SectionData.init(company: "Big W", data: "Homewares", percentage: 2),
            SectionData.init(company: "Masters", data: "Home Imprv", percentage: 2),
            SectionData.init(company: "BCF", data: "Recreation", percentage: 2),
            SectionData.init(company: "Ray's", data: "Outdoors", percentage: 2),
            SectionData.init(company: "Super Cheap", data: "Automotive", percentage: 2),
            SectionData.init(company: "Amart & Rebel", data: "Sports", percentage: 2),
            SectionData.init(company: "JB HiFi", data: "Electronics", percentage: 2)]
        )
        
        let section2 = CalculatorSection.init(section: "Services & Utilities", sectionData: [
            SectionData.init(company: "", data: "Telephone Internet", percentage: 5),
            SectionData.init(company: "", data: "Insurance", percentage: 1),
            SectionData.init(company: "", data: "Mortgage", percentage: 1)])
        
        let section3 = CalculatorSection.init(section: "Local Retail Cash Back & Loyalty", sectionData: [
            SectionData.init(company: "", data: "Dining Out", percentage: 7),
            SectionData.init(company: "", data: "Beauty", percentage: 7),
            SectionData.init(company: "", data: "Clothing", percentage: 7),
            SectionData.init(company: "", data: "Homewares", percentage: 7),
            SectionData.init(company: "", data: "Groceries", percentage: 7),
            SectionData.init(company: "", data: "Dry Cleaning", percentage: 7),
            SectionData.init(company: "", data: "Trade Services", percentage: 7),
            SectionData.init(company: "", data: "Recreation", percentage: 7),
            SectionData.init(company: "", data: "Pet Care", percentage: 7),
            SectionData.init(company: "", data: "Fitness", percentage: 7),
            SectionData.init(company: "", data: "Auto Services", percentage: 7),
            SectionData.init(company: "", data: "Other", percentage: 7)])
        
        arrCalculator.insert(section1, at: 0)
        arrCalculator.insert(section2, at: 1)
        arrCalculator.insert(section3, at: 2)
    }
    
    func savingCalculator(_ spendInWeek: Double, _ percentage:Double) -> (savingInWeek: String, savingInYear: String) {
        let saveInWeek  = String.init(format: "%.2f", (spendInWeek / 100)*percentage)
        let saveInYear  = String.init(format: "%.2f", ((spendInWeek / 100)*percentage)*52)
        return (savingInWeek:saveInWeek, savingInYear:saveInYear)
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
        cell.lblName.font   = UIFont.applyOpenSansRegular(fontSize: 14.0)
        cell.lblPercentage.font = UIFont.applyOpenSansRegular(fontSize: 14.0)
        cell.txtSpendWeek.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 3.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        cell.txtSaveWeek.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 3.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        cell.txtSaveYear.applyStyle(textFont: UIFont.applyOpenSansRegular(fontSize: 14.0), textColor: GConstant.AppColor.textDark, cornerRadius: 3.0*GConstant.Screen.HeightAspectRatio, borderColor: GConstant.AppColor.textLight, borderWidth: 0.5)
        cell.txtSpendWeek.setRightPaddingPoints(5.0)
        cell.txtSaveWeek.setRightPaddingPoints(5.0)
        cell.txtSaveYear.setRightPaddingPoints(5.0)
        
        cell.txtSpendWeek.tag   = indexPath.row
        cell.lblName.text       = arrCalculator[indexPath.section].sectionData?[indexPath.row].data
        cell.lblPercentage.text = "\(arrCalculator[indexPath.section].sectionData?[indexPath.row].percentage ?? 0)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.tag)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let section = tblCalculator.indexPathsForVisibleRows?.first?.section {
           let indexPath   = IndexPath(row: textField.tag, section: section)
            let cell = tblCalculator.dequeueReusableCell(withIdentifier: "CalculatorCell", for: indexPath) as! TMCalculatorCell
            
            if let doubleVal = NumberFormatter().number(from: cell.txtSpendWeek?.text ?? "")?.doubleValue {
                let values = savingCalculator(doubleVal, arrCalculator[section].sectionData?[indexPath.row].percentage ?? 0)
                cell.txtSaveWeek.text   = values.savingInWeek
                cell.txtSaveYear.text   = values.savingInYear
            }
        }
        return true
    }
}
