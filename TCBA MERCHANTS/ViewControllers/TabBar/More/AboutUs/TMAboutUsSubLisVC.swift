//
//  TMAboutUsSubLisVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 21/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMAboutUsSubLisVC: UIViewController {
    
    enum typeSection:String {
        case Corporate  = "corporate"
        case News       = "news"
    }
    
    //MARK: - Outlets
    @IBOutlet weak var tblAboutUsSubList: UITableView!
    //enum
    var typeSec:typeSection!
    //Model
    var sectionData: GetAboutUsSectionModel!
    
    //MARK: - Variables
    var arrImages           = [[:]]
    var strTitle            : String!
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewProperties()
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
        self.navigationItem.title = strTitle
        callGetStoreDetailsApi()
    }
    
    //MARK: - Web Api's
    func callGetStoreDetailsApi() {
        /*
         =====================API CALL=====================
         APIName    : GetStoreContent
         Url        : "/Content/GetAboutUsSection"
         Method     : GET
         Parameters : { type : typeSec == .Corporate ? "corporate" : "news"}
         ===================================================
         */
        let request         = RequestModal.mUserData()
        request.type        = typeSec.rawValue
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetAboutUsSection, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data      = data else{ return }
                self.sectionData    = try? GetAboutUsSectionModel.decode(_data: data)
                self.tblAboutUsSubList.reloadData()
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

extension TMAboutUsSubLisVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - UITableView Delegates & Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = sectionData?.about?.count else { return 0 }
        return  count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreImagesCell") as! TMStoreImagesCell
        
        cell.lblName.font   = UIFont.applyOpenSansRegular(fontSize: 14.0)
        cell.lblName.text   = sectionData.about?[indexPath.row].title
        guard let imgURL    = sectionData.about?[indexPath.row].image else { return cell }
        cell.imgIcon.setImageWithDownload( URL(string: imgURL)!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objSecDetail = storyboard?.instantiateViewController(withIdentifier: "TMAboutUsSubLisDetailVC") as! TMAboutUsSubLisDetailVC
        objSecDetail.section  = sectionData?.about?[indexPath.row]
        self.navigationController?.pushViewController(objSecDetail, animated: true)
    }
}
