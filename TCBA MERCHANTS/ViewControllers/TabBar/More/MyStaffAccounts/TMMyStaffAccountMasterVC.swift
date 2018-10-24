//
//  TMMyStaffAccountMasterVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMMyStaffAccountMasterVC: UIViewController {

    //MARK: Variables & Constants
    var staffMembersData:GetStaffMemberModel!
    
    
    //MARK: Outlets
    //UITableView
    @IBOutlet weak var tblStaff: UITableView!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if staffMembersData == nil {
            GetStaffMembersApi()
        }
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
        self.navigationItem.title   = "My Staff Accounts"
        
        navigationItem.leftBarButtonItem    = UIBarButtonItem(image: UIImage(named: "back_button"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonAction))
        let addStaff                        = UIBarButtonItem(image: UIImage(named: "add_staff"), landscapeImagePhone: nil, style: UIBarButtonItem.Style.plain, target: self, action: #selector(addButtonAction))
        
        let staffLock = UISwitch(frame: .zero)
        staffLock.isOn = true // or false
        staffLock.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        let barSwitch = UIBarButtonItem(customView: staffLock)
        navigationItem.rightBarButtonItems  = [barSwitch,addStaff]
    }
    
    //MARK: - BarButton Action Methods
    @objc func backButtonAction(sender: UIBarButtonItem){
        backToMore()
    }
    
    @objc func addButtonAction(sender: UIBarButtonItem){
        staffDetailVC(typeS: .addStaff, data: nil)
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
            print( "The switch is now true!" )
        }
        else{
            print( "The switch is now false!" )
        }
    }
    
    //MARK: - UIButton Action methods
    
    //MARK: - Custom Methods
    func backToMore() {
        //This method will get back to you to MoreViewController
        let transition: CATransition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        rootWindow().layer.add(transition, forKey: nil)
        rootWindow().rootViewController = Tabbar.coustomTabBar(withIndex: 4)
    }
    // MARK: - Navigation
    func staffDetailVC(typeS: typeStaff? , data: StaffMember?) {
        self.splitViewController?.preferredDisplayMode = .allVisible
        guard let staffDetailVC = storyboard?.instantiateViewController(withIdentifier: "TMMyStaffAccountDetailsVC") as? TMMyStaffAccountDetailsVC else { return }
        staffDetailVC.typeStaffAcc  = typeS
        staffDetailVC.staffData     = typeS == .editStaff ? data : nil
        self.splitViewController?.showDetailViewController(staffDetailVC, sender: self)
    }
    //MARK: - Web Api's
    func GetStaffMembersApi() {
        
        /*
         =====================API CALL=====================
         APIName    : GetStaffMembers
         Url        : "/Staff/GetStaffMembers"
         Method     : GET
         Parameters : nil
         ===================================================
         */
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetStaffMembers, parameter: nil) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let mData         = data else{return}
                self.staffMembersData   = GetStaffMemberModel.decodeData(_data: mData).response
                self.tblStaff.reloadData()
            }else{
                if statusCode == 404{
                    AlertManager.shared.showAlertTitle(title: "Error" ,message:GConstant.Message.kSomthingWrongMessage)
                }else{
                    if let data = data {
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
extension TMMyStaffAccountMasterVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView Delegates & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staffMembersData != nil ? staffMembersData.staffMembers.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StaffMasterCell") as! TMStaffMasterCell
        cell.lblName.font       = UIFont.applyOpenSansRegular(fontSize: 15.0)
        cell.lblPin.font        = UIFont.applyOpenSansRegular(fontSize: 15.0)
        cell.lblPhone.font      = UIFont.applyOpenSansRegular(fontSize: 14.0)
        cell.lblActive.font     = UIFont.applyOpenSansRegular(fontSize: 15.0)
        
        cell.lblName.text       = staffMembersData.staffMembers[indexPath.row].firstName + " " + staffMembersData.staffMembers[indexPath.row].lastName
        cell.lblPin.text        = "PIN:\(staffMembersData.staffMembers[indexPath.row].pinCode)"
        cell.lblPhone.text      = "\(staffMembersData.staffMembers[indexPath.row].staffMemberID)"
        cell.lblActive.text     = staffMembersData.staffMembers[indexPath.row].active ? "Active" : "Inactive"
        
        cell.lblActive.textColor  = staffMembersData.staffMembers[indexPath.row].active ? GConstant.AppColor.orange : GConstant.AppColor.blue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        staffDetailVC(typeS: .editStaff, data: staffMembersData.staffMembers[indexPath.row])
    }
}
