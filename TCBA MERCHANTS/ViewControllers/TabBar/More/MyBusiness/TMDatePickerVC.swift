//
//  TMDatePickerVC.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 10/09/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import UIKit

class TMDatePickerVC: UIViewController {
    
    //MARK: Outlets & Variables
    var completionHandler: ((_ date : String) -> Void)!

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIbutton Methods
    @IBAction func btnYesKB(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        let strDate = dateFormatter.string(from: datePicker.date)
        completionHandler(strDate)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCloseKB(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: UIView Action Methods
    
    @IBAction func viewActBackground(_ sender: UIControl) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func vActSetClosed(_ sender: UIControl) {
        completionHandler("closed")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func vActByAppointment(_ sender: UIControl) {
        completionHandler("byAppointment")
        dismiss(animated: true, completion: nil)
    }
}
