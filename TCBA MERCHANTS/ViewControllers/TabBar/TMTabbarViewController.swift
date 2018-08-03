//
//  TMTabbarViewController.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 23/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//

import Foundation
import ESTabBarController_swift

enum Tabbar {
    static func coustomTabBar() -> ESTabBarController {
        let tabBarController = ESTabBarController()
        if let tabBar = tabBarController.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        let v1 = GConstant.MainStoryBoard.instantiateViewController(withIdentifier: GConstant.VCIdentifier.Home) as! TMHomeViewController
        let v2 = GConstant.MainStoryBoard.instantiateViewController(withIdentifier: GConstant.VCIdentifier.History) as! TMHistoryViewController
        let v3 = GConstant.MainStoryBoard.instantiateViewController(withIdentifier: GConstant.VCIdentifier.Transection) as! TMTransactionViewController
        let v4 = GConstant.MainStoryBoard.instantiateViewController(withIdentifier: GConstant.VCIdentifier.Share) as! TMShareViewController
        let v5 = GConstant.MainStoryBoard.instantiateViewController(withIdentifier: GConstant.VCIdentifier.More) as! TMMoreViewController
        
        v1.tabBarItem = ESTabBarItem.init(ExampleBackgroundContentView(),title: "Home", image: UIImage(named: "home_on"), selectedImage: UIImage(named: "home_on"))
        
        v2.tabBarItem = ESTabBarItem.init(ExampleBackgroundContentView(),title: "History", image: UIImage(named: "tab_history"), selectedImage: UIImage(named: "tab_history"))
        
        v3.tabBarItem = ESTabBarItem.init(ExampleBackgroundContentView.init(specialWithAutoImplies: true), title: "QR", image: UIImage(named: "qr_on"), selectedImage: UIImage(named: "qr_on"))
        
        v4.tabBarItem = ESTabBarItem.init(ExampleBackgroundContentView(),title: "Share", image: UIImage(named: "share_on"), selectedImage: UIImage(named: "share_on"))
        
        v5.tabBarItem = ESTabBarItem.init(ExampleBackgroundContentView(),title: "More", image: UIImage(named: "more_on"), selectedImage: UIImage(named: "more_on"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5].map({UINavigationController(rootViewController: $0)})
        return tabBarController
    }
}

class ExampleBackgroundContentView: ExampleBasicContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor               = .white
        highlightTextColor      = .white
        iconColor               = .white
        highlightIconColor      = .white
        backdropColor           = GConstant.AppColor.orange
        highlightBackdropColor  = GConstant.AppColor.blue
    }
    
    lazy var semiCircleView = UIView(frame: CGRect(x: 0, y: -12, width: GConstant.Screen.Width/5 , height: 60))
    public convenience init(specialWithAutoImplies implies: Bool) {
        self.init(frame: CGRect.zero)
        textColor               = .white
        highlightTextColor      = .white
        iconColor               = .white
        highlightIconColor      = .white
        backdropColor           = GConstant.AppColor.orange
        highlightBackdropColor  = GConstant.AppColor.blue
        
        if implies {
            let circlePath = UIBezierPath.init(arcCenter: CGPoint(x: semiCircleView.bounds.width / 2, y: semiCircleView.bounds.height / 2), radius: semiCircleView.bounds.height/2, startAngle: CGFloat.pi + (CGFloat.pi/5), endAngle: CGFloat.pi*2 - (CGFloat.pi/5), clockwise: true)
            let circleShape = CAShapeLayer()
            circleShape.path = circlePath.cgPath
            
            semiCircleView.layer.mask = circleShape
            super.addSubview(semiCircleView)
        }
    }
    
    override func updateDisplay() {
        imageView.image                 = (selected ? (selectedImage ?? image) : image)?.withRenderingMode(renderingMode)
        imageView.tintColor             = selected ? highlightIconColor : iconColor
        titleLabel.textColor            = selected ? highlightTextColor : textColor
        backgroundColor                 = selected ? highlightBackdropColor : backdropColor
        semiCircleView.backgroundColor  = selected ? highlightBackdropColor : backdropColor
    }
    override func updateLayout() {
        var isLandscap = false
        guard let keyWindow = UIApplication.shared.keyWindow else {return}
        isLandscap = keyWindow.bounds.width > keyWindow.bounds.height
        if isLandscap {
            semiCircleView.frame = CGRect(x: 0, y: -12, width: keyWindow.bounds.width/5 , height: 60)
        }else{
            semiCircleView.frame = CGRect(x: 0, y: -12, width: GConstant.Screen.Width/5 , height: 60)
        }
        let circlePath = UIBezierPath.init(arcCenter: CGPoint(x: semiCircleView.bounds.width / 2, y: semiCircleView.bounds.height / 2), radius: semiCircleView.bounds.height/2, startAngle: CGFloat.pi + (CGFloat.pi/5), endAngle: CGFloat.pi*2 - (CGFloat.pi/5), clockwise: true)
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        
        semiCircleView.layer.mask = circleShape
        
        
        let w = self.bounds.size.width
        let h = self.bounds.size.height
        
        imageView.isHidden = (imageView.image == nil)
        titleLabel.isHidden = (titleLabel.text == nil)
        
        if self.itemContentMode == .alwaysTemplate {
            var s: CGFloat = 0.0 // image size
            var f: CGFloat = 0.0 // font
            var isLandscape = false
            if let keyWindow = UIApplication.shared.keyWindow {
                isLandscape = keyWindow.bounds.width > keyWindow.bounds.height
            }
            let isWide = isLandscape || traitCollection.horizontalSizeClass == .regular // is landscape or regular
            if #available(iOS 11.0, *), isWide {
                s = UIScreen.main.scale == 3.0 ? 23.0 : 20.0
                f = UIScreen.main.scale == 3.0 ? 13.0 : 12.0
            } else {
                s = 23.0
                f = 10.0
            }
            
            if !imageView.isHidden && !titleLabel.isHidden {
                titleLabel.font = UIFont.systemFont(ofSize: f)
                titleLabel.sizeToFit()
                if #available(iOS 11.0, *), isWide {
                    titleLabel.frame = CGRect.init(x: (w - titleLabel.bounds.size.width) / 2.0 + (UIScreen.main.scale == 3.0 ? 14.25 : 12.25),
                                                   y: (h - titleLabel.bounds.size.height) / 2.0,
                                                   width: titleLabel.bounds.size.width,
                                                   height: titleLabel.bounds.size.height)
                    imageView.frame = CGRect.init(x: titleLabel.frame.origin.x - s - (UIScreen.main.scale == 3.0 ? 6.0 : 5.0),
                                                  y: (h - s) / 2.0,
                                                  width: s,
                                                  height: s)
                } else {
                    titleLabel.frame = CGRect.init(x: (w - titleLabel.bounds.size.width) / 2.0,
                                                   y: h - titleLabel.bounds.size.height - 1.0,
                                                   width: titleLabel.bounds.size.width,
                                                   height: titleLabel.bounds.size.height)
                    imageView.frame = CGRect.init(x: (w - s) / 2.0,
                                                  y: (h - s) / 2.0 - 6.0,
                                                  width: s,
                                                  height: s)
                }
            } else if !imageView.isHidden {
                imageView.frame = CGRect.init(x: (w - s) / 2.0,
                                              y: (h - s) / 2.0,
                                              width: s,
                                              height: s)
            } else if !titleLabel.isHidden {
                titleLabel.font = UIFont.systemFont(ofSize: f)
                titleLabel.sizeToFit()
                titleLabel.frame = CGRect.init(x: (w - titleLabel.bounds.size.width) / 2.0,
                                               y: (h - titleLabel.bounds.size.height) / 2.0,
                                               width: titleLabel.bounds.size.width,
                                               height: titleLabel.bounds.size.height)
            }
            
            if let _ = badgeView.superview {
                let size = badgeView.sizeThatFits(self.frame.size)
                if #available(iOS 11.0, *), isWide {
                    badgeView.frame = CGRect.init(origin: CGPoint.init(x: imageView.frame.midX - 3 + badgeOffset.horizontal, y: imageView.frame.midY + 3 + badgeOffset.vertical), size: size)
                } else {
                    badgeView.frame = CGRect.init(origin: CGPoint.init(x: w / 2.0 + badgeOffset.horizontal, y: h / 2.0 + badgeOffset.vertical), size: size)
                }
                badgeView.setNeedsLayout()
            }
            
        } else {
            if !imageView.isHidden && !titleLabel.isHidden {
                titleLabel.sizeToFit()
                imageView.sizeToFit()
                titleLabel.frame = CGRect.init(x: (w - titleLabel.bounds.size.width) / 2.0,
                                               y: h - titleLabel.bounds.size.height - 1.0,
                                               width: titleLabel.bounds.size.width,
                                               height: titleLabel.bounds.size.height)
                imageView.frame = CGRect.init(x: (w - imageView.bounds.size.width) / 2.0,
                                              y: (h - imageView.bounds.size.height) / 2.0 - 6.0,
                                              width: imageView.bounds.size.width,
                                              height: imageView.bounds.size.height)
            } else if !imageView.isHidden {
                imageView.sizeToFit()
                imageView.center = CGPoint.init(x: w / 2.0, y: h / 2.0)
            } else if !titleLabel.isHidden {
                titleLabel.sizeToFit()
                titleLabel.center = CGPoint.init(x: w / 2.0, y: h / 2.0)
            }
            
            if let _ = badgeView.superview {
                let size = badgeView.sizeThatFits(self.frame.size)
                badgeView.frame = CGRect.init(origin: CGPoint.init(x: w / 2.0 + badgeOffset.horizontal, y: h / 2.0 + badgeOffset.vertical), size: size)
                badgeView.setNeedsLayout()
            }
        }
        
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class ExampleBasicContentView: ESTabBarItemContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor          = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
        iconColor          = UIColor.init(white: 175.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor.init(red: 254/255.0, green: 73/255.0, blue: 42/255.0, alpha: 1.0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
