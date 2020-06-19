//
//  LoaderWithLabel.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 25/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import Foundation
import UIKit
import SwiftGifOrigin

public class LoaderWithLabel {
    
    var containerView           = UIView()
    var progressView            = UIView()
    var activityIndicator       = UIActivityIndicatorView()
    
    
    public class var shared: LoaderWithLabel {
        struct Static {
            static let instance: LoaderWithLabel = LoaderWithLabel()
        }
        return Static.instance
    }
    
    var pinchImageView = UIImageView()
    var lblMessage = UILabel()
    
    public func showProgressView(anyView: AnyObject, message: String = "Loading data") {
        NotificationCenter.default.addObserver(self, selector: #selector(LoaderWithLabel.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIView.animate(withDuration: 0.2) {
            self.pinchImageView.alpha       =   1.0
            self.activityIndicator.alpha    =   1.0
            self.progressView.alpha         =   1.0
            self.containerView.alpha        =   1.0
            self.lblMessage.alpha           =   1.0
        }
        
        containerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        guard let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "LoaderAnim", withExtension: "gif")!) else { return }
        let animatedImage = UIImage.gif(data: imageData)
        
        pinchImageView                      = UIImageView(image: animatedImage)
        pinchImageView.frame                = CGRect(x: 0.0, y: 0.0, width: 80*GConstant.Screen.HeightAspectRatio, height: 80*GConstant.Screen.HeightAspectRatio)
        pinchImageView.backgroundColor      = .clear
        
        progressView.frame                  = CGRect(x: 0.0, y: 0.0, width: pinchImageView.bounds.width, height: pinchImageView.bounds.height)
        progressView.backgroundColor        = .clear
        progressView.layer.cornerRadius     = 3*GConstant.Screen.HeightAspectRatio
        progressView.layer.masksToBounds    = true
        progressView.center                 = anyView.center
        progressView.addSubview(pinchImageView)
        
        lblMessage                          = UILabel.init(frame: CGRect(x: anyView.center.x - (pinchImageView.bounds.width)/2 , y: anyView.center.y + (pinchImageView.bounds.height)/1.8, width: pinchImageView.bounds.width, height: message.height(withConstrainedWidth: pinchImageView.bounds.width, font: UIFont.applyOpenSansRegular(fontSize: 12.0))))
        lblMessage.textAlignment            = .center
        
        lblMessage.numberOfLines            = 0
        lblMessage.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 12.0), labelColor: .white)
        lblMessage.text                     = message
        
        containerView.addSubview(lblMessage)
        containerView.addSubview(progressView)
        anyView.addSubview(containerView)
    }
    
    public func hideProgressView() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        UIView.animate(withDuration: 0.2, animations: {
            self.pinchImageView.alpha       =   0.0
            self.activityIndicator.alpha    =   0.0
            self.progressView.alpha         =   0.0
            self.containerView.alpha        =   0.0
            self.lblMessage.alpha           =   0.0
        }) { _ in
            self.activityIndicator.stopAnimating()
            self.pinchImageView.removeFromSuperview()
            self.activityIndicator.removeFromSuperview()
            self.progressView.removeFromSuperview()
            self.containerView.removeFromSuperview()
            self.lblMessage.removeFromSuperview()
            NotificationCenter.default.removeObserver(UIDevice.orientationDidChangeNotification)
        }
    }
    
    @objc func rotated() {
        //This method will call if device will change orientation
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let message1 : String = "Loading data"
            self.containerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            self.progressView.center = self.containerView.center
            self.lblMessage.frame =  CGRect(x: self.containerView.center.x - (self.self.pinchImageView.bounds.width)/2 , y: self.containerView.center.y + (self.pinchImageView.bounds.height)/1.8, width: self.pinchImageView.bounds.width, height: message1.height(withConstrainedWidth: self.pinchImageView.bounds.width, font: UIFont.applyOpenSansRegular(fontSize: 13.0*GConstant.Screen.HeightAspectRatio)))
            
            print(self.containerView.frame)
        }
    }
}
