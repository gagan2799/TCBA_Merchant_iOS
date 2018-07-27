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
    
    var containerView = UIView()
    var progressView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    
    public class var shared: LoaderWithLabel {
        struct Static {
            static let instance: LoaderWithLabel = LoaderWithLabel()
        }
        return Static.instance
    }
    
    var pinchImageView = UIImageView()
    var lblMessage = UILabel()
    
    public func showProgressView(anyView: AnyObject, message: String = "Loading data") {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        containerView.frame = CGRect(x: 0, y: 0, width: anyView.frame.width, height: anyView.frame.height)
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        let imageData = try! Data(contentsOf: Bundle.main.url(forResource: "LoaderAnim", withExtension: "gif")!)
        let animatedImage = UIImage.gif(data: imageData)
        
        pinchImageView = UIImageView(image: animatedImage)
        pinchImageView.frame = CGRect(x: 0.0, y: 0.0, width: 80*GConstant.Screen.HeightAspectRatio, height: 80*GConstant.Screen.HeightAspectRatio)
        pinchImageView.backgroundColor = .clear
        
        progressView.frame = CGRect(x: 0.0, y: 0.0, width: pinchImageView.bounds.width, height: pinchImageView.bounds.height)
        progressView.backgroundColor = .clear
        progressView.layer.cornerRadius = 3*GConstant.Screen.HeightAspectRatio
        progressView.layer.masksToBounds = true
        progressView.center = anyView.center
        progressView.addSubview(pinchImageView)
        
        lblMessage = UILabel.init(frame: CGRect(x: anyView.center.x - (pinchImageView.bounds.width)/2 , y: anyView.center.y + (pinchImageView.bounds.height)/1.8, width: pinchImageView.bounds.width, height: message.height(withConstrainedWidth: pinchImageView.bounds.width, font: UIFont.applyOpenSansRegular(fontSize: 13.0*GConstant.Screen.HeightAspectRatio))))
        lblMessage.textAlignment = .center
        
        lblMessage.numberOfLines = 0
        lblMessage.applyStyle(labelFont: UIFont.applyOpenSansRegular(fontSize: 13.0*GConstant.Screen.HeightAspectRatio), labelColor: .white)
        lblMessage.text = message
        
        containerView.addSubview(lblMessage)
        containerView.addSubview(progressView)
        anyView.addSubview(containerView)
    }
    
    public func hideProgressView() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        activityIndicator.stopAnimating()
        pinchImageView.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        progressView.removeFromSuperview()
        containerView.removeFromSuperview()
        lblMessage.removeFromSuperview()
    }
}
