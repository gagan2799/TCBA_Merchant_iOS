//
//  TMVideoSubLisVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 04/10/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMVideoSubLisVC: UIViewController {
    //MARK: Variables & Constants
    var objVideo    : VideoCategoryVideo!
    var modelVidList: VideoSubCategoryModel!
    
    //MARK: Outlets
    //UILabel
    
    //UITableView
    @IBOutlet weak var tblVideoSub: UITableView!
    
    //MARK: View Life Cycle
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
    
    func setViewProperties() {
        // navigationBar customization
        self.navigationController?.customize()
        self.navigationItem.title   = objVideo?.title
        callGetVideoSubcategoriesApi()
    }
    
    //MARK: - Web Api's
    func callGetVideoSubcategoriesApi() {
        /*
         =====================API CALL=====================
         APIName    : GetVideoSubcategories
         Url        : "/Content/GetVideoSubcategoriesOrVideosList"
         Method     : GET
         Parameters : {"categoryId" : "" }
         ===================================================
         */
        let request         = RequestModal.mUserData()
        request.categoryId  = "\(String(describing: objVideo?.categoryID ?? 0))"
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetVideoSubcategories, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let dataVidSubCat    = data else { return }
                self.modelVidList        = try? VideoSubCategoryModel.decode(_data: dataVidSubCat)
                self.tblVideoSub.reloadData()
            }else{
                if let data = data {
                    guard let json  = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                        let str     = String.init(data: data, encoding: .utf8) ?? GConstant.Message.kSomthingWrongMessage
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

extension TMVideoSubLisVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView Delegates & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelVidList?.videos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * GConstant.Screen.HeightAspectRatio
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TMVideoCell") as! TMVideoCell
        cell.lblName.font       = UIFont.applyOpenSansRegular(fontSize: 16.0)
        cell.lblName.text       = modelVidList?.videos?[indexPath.row].videoTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objSubLis           = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.VideoDetails) as! TMVideoDetailsVC
        objSubLis.objVideoSub   = modelVidList?.videos?[indexPath.row]
        self.navigationController?.pushViewController(objSubLis, animated: true)
    }
}
