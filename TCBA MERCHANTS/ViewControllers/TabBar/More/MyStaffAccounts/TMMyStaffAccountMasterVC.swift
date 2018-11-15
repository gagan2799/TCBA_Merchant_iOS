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
    let staffLock = UISwitch(frame: .zero)
    
    //MARK: Outlets
    //UITableView
    @IBOutlet weak var tblStaff: UITableView!
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
        CompletionHandler.shared.litsenerEvent(.reloadStaffTable) { (member) in
            if let staffMember = member as? StaffMember {
                print(staffMember)
                self.staffMembersData.staffMembers.append(staffMember)
                self.tblStaff.beginUpdates()
                let indexPath = IndexPath(row: self.staffMembersData.staffMembers.count-1, section: 0)
                self.tblStaff.insertRows(at: [indexPath], with: .automatic)
                self.tblStaff.endUpdates()
            }else{
                self.GetStaffMembersApi()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if staffMembersData == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.GetStaffMembersApi()
            }
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
        
        staffLock.onTintColor               = GConstant.AppColor.orange
        staffLock.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        let barSwitch                       = UIBarButtonItem(customView: staffLock)
        navigationItem.rightBarButtonItems  = [barSwitch,addStaff]
        
        if UserDefaults.standard.bool(forKey: GConstant.UserDefaultKeys.EnableStaffMode) {
            staffLock.isOn = true
        }else{
            staffLock.isOn = false
        }
    }
    
    //MARK: - BarButton Action Methods
    @objc func backButtonAction(sender: UIBarButtonItem){
        backToTabBar(withIndex:4)
    }
    
    @objc func addButtonAction(sender: UIBarButtonItem){
        staffDetailVC(typeS: .addStaff, data: nil)
    }
    
    @IBAction func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
            print( "The switch is now true!" )
            AlertManager.shared.showAlertTitle(title: "Enable Staff Mode?", message: "Staff mode is security feature that locks the History, QR and Share Tab out and requires your staff to use their PIN to open.Transactions are then tracked to a staff ID", buttonsArray: ["Enable staff mode","Cancel"]) { (buttonIndex : Int) in
                switch buttonIndex {
                case 0 :
                    print( "Enable staff mode" )
                    UserDefaults.standard.set(true, forKey: GConstant.UserDefaultKeys.EnableStaffMode)
                    UserDefaults.standard.set(false, forKey: GConstant.UserDefaultKeys.isStaffLoggedIn)
                    UserDefaults.standard.synchronize()
                    self.backToTabBar(withIndex: 2)
                    break
                case 1 :
                    print( "Cancel" )
                    UserDefaults.standard.set(false, forKey: GConstant.UserDefaultKeys.EnableStaffMode)
                    UserDefaults.standard.set(false, forKey: GConstant.UserDefaultKeys.isStaffLoggedIn)
                    UserDefaults.standard.synchronize()
                    sender.setOn(false, animated: true)
                    break
                default:
                    break
                }
            }
        }
        else{
            print( "The switch is now false!" )
            UserDefaults.standard.set(false, forKey: GConstant.UserDefaultKeys.EnableStaffMode)
            UserDefaults.standard.set(false, forKey: GConstant.UserDefaultKeys.isStaffLoggedIn)
            UserDefaults.standard.synchronize()
        }
    }
    
    //MARK: - UIButton Action methods
    
    //MARK: - Custom Methods
    func backToTabBar(withIndex index : Int ) {
        //This method will get back to you to MoreViewController
        let tabIndex = index > 5 ? 4 : index
        let transition: CATransition = CATransition()
        transition.duration = 0.2
        transition.type = CATransitionType.fade
        rootWindow().layer.add(transition, forKey: nil)
        rootWindow().rootViewController = Tabbar.coustomTabBar(withIndex: tabIndex)
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
        cell.lblName.font       = UIFont.applyOpenSansRegular(fontSize: 14.0)
        cell.lblPin.font        = UIFont.applyOpenSansRegular(fontSize: 14.0)
        cell.lblPhone.font      = UIFont.applyOpenSansRegular(fontSize: 13.0)
        cell.lblActive.font     = UIFont.applyOpenSansRegular(fontSize: 14.0)
        
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
