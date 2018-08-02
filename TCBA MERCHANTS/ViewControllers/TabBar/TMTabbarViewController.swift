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
//                semiCircleView.layer.cornerRadius = semiCircleView.bounds.midX
//                semiCircleView.layer.masksToBounds = true
//                let iv = UIImageView.init(image: UIImage(named: "tab_qr"))
//                iv.center = semiCircleView.center
//                iv.center.y = 35
//                semiCircleView.addSubview(iv)
//                super.addSubview(semiCircleView)

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
