//
//  TMStoreImagesVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 06/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMStoreImagesVC: UIViewController {


    //MARK: - Outlets
    @IBOutlet weak var tblStore: UITableView!
    
    //MARK: - Variables
    var storeDetailsData    : StoreDetailsModel!
    var arrImages           = [[:]]
    
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
        self.navigationItem.title = "Store Images"
        callGetStoreDetailsApi()
    }

    //MARK: - Web Api's
    func callGetStoreDetailsApi() {
        /*
         =====================API CALL=====================
         APIName    : GetStoreContent
         Url        : "/Stores/GetStoreContent"
         Method     : GET
         Parameters : { storeID : "" }
         ===================================================
         */
        let request         = RequestModal.mUserData()
        guard let storeId   = GConstant.UserData.stores else{return}
        request.storeID     = storeId
        
        ApiManager.shared.GETWithBearerAuth(strURL: GAPIConstant.Url.GetStoreDetails, parameter: request.toDictionary()) { (data : Data?, statusCode : Int?, error: String) in
            if statusCode == 200 {
                guard let data = data else{return}
                self.storeDetailsData   = try? StoreDetailsModel.decode(_data: data)
                self.arrImages.removeAll()
                guard let imgURL        = self.storeDetailsData.storeIcon else { return }
                self.arrImages.append(["name" : "Main Image","imageUrl":imgURL])
                
                for i in 0 ..< self.storeDetailsData.storeImages!.count {
                    guard let imgURL1   = self.storeDetailsData.storeImages![i].imageURLOriginal else { return }
                    let obj = ["name" : String.localizedStringWithFormat("Featured Image %d", i + 1) ,"imageUrl":imgURL1]
                    self.arrImages.append(obj)
                }
                self.tblStore.reloadData()
            }else{
                if let data = data{
                    guard let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
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


extension TMStoreImagesVC: UITableViewDataSource,UITableViewDelegate{
    // MARK: - UITableView Delegates & Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrImages.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * GConstant.Screen.HeightAspectRatio
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreImagesCell") as! TMStoreImagesCell
        
        cell.lblName.font   = UIFont.applyOpenSansRegular(fontSize: 15.0)
        cell.lblName.text   = arrImages[indexPath.row]["name"] as? String
        guard let imgURL    = arrImages[indexPath.row]["imageUrl"] as? String else { return cell }
        cell.imgIcon.setImageWithDownload( URL(string: imgURL)!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = storyboard?.instantiateViewController(withIdentifier: GConstant.VCIdentifier.MainImage) as! TMMainImageVC
        guard storeDetailsData != nil else {
            return
        }
        obj.imgUrl = arrImages[indexPath.row]["imageUrl"] as? String
        obj.title  = arrImages[indexPath.row]["name"] as? String
        obj.storeTitle  = storeDetailsData.storeTitle
        self.navigationController?.pushViewController(obj, animated: true)
    }
}
