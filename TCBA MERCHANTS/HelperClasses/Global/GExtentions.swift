//
//  GExtentions.swift
//  TCBA MERCHANTS
//
//  Created by varun@gsbitlabs on 11/07/18.
//  Copyright © 2018 GS Bit Labs. All rights reserved.
//
import Foundation
import UIKit
import SDWebImage

//MARK:- Double
extension Double {
    /// Rounds the double to decimal places value
    // How to use
    //let x = Double(0.123456789).roundToDecimal(_ fractionDigits: 2)
    func roundToDecimal(_ fractionDigits: Int = 2) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
//MARK:- UIColor

extension UIColor {
    
    class func colorFromHex(hex: Int) -> UIColor {
        // How to use
        // kColorGray74:Int    = 0xBDBDBD
        // eg: UIColor.colorFromHex(hex: kColorGray74)
        return UIColor(red: (CGFloat((hex & 0xFF0000) >> 16)) / 255.0, green: (CGFloat((hex & 0xFF00) >> 8)) / 255.0, blue: (CGFloat(hex & 0xFF)) / 255.0, alpha: 1.0)
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        // How to use
        // eg: UIColor(hexString: "#0073CA")
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

//MARK:- Decodable Extension

extension Decodable {
    static func decode(_data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: _data)
    }
}

//MARK:- Encodable Extension

extension Encodable {
    func encode() throws -> Dictionary<String, Any> {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encodedData =  try encoder.encode(self)
        let json = try? JSONSerialization.jsonObject(with: encodedData, options: [])
        return json as! Dictionary<String, Any>
    }
}

//MARK:- UIFont

extension UIFont {
    
    class func applyRegular(fontSize : CGFloat ,isAspectRasio : Bool = true) -> UIFont {
        if isAspectRasio {
            return UIFont.init(name: "Helvetica" , size: fontSize * GConstant.Screen.HeightAspectRatio)!
        } else {
            return UIFont.init(name: "Helvetica" , size: fontSize)!
        }
    }
    
    class func applyBold(fontSize : CGFloat ,isAspectRasio : Bool = true) -> UIFont {
        if isAspectRasio {
            return UIFont.init(name: "Helvetica-Bold" , size: fontSize * GConstant.Screen.HeightAspectRatio)!
        }else {
            return UIFont.init(name: "Helvetica-Bold" , size: fontSize)!
        }
    }
    
    class func applyMedium(fontSize : CGFloat ,isAspectRasio : Bool = true) -> UIFont {
        if isAspectRasio {
            return UIFont.init(name: "HelveticaNeue-Medium" , size: fontSize * GConstant.Screen.HeightAspectRatio)!
        }else {
            return UIFont.init(name: "HelveticaNeue-Medium" , size: fontSize)!
        }
    }
    
    class func applyOpenSansRegular( fontSize : CGFloat ,isAspectRasio : Bool = true) -> UIFont {
        if isAspectRasio {
            return UIFont.init(name: "OpenSans" , size: fontSize * GConstant.Screen.HeightAspectRatio)!
        }else {
            return UIFont.init(name: "OpenSans" , size: fontSize)!
        }
    }
    
    class func applyOpenSansSemiBold(fontSize : CGFloat ,isAspectRasio : Bool = true) -> UIFont {
        if isAspectRasio {
            return UIFont.init(name: "OpenSans-Semibold" , size: fontSize * GConstant.Screen.HeightAspectRatio)!
        }else {
            return UIFont.init(name: "OpenSans-Semibold" , size: fontSize)!
        }
    }
    
    class func applyOpenSansBold(fontSize : CGFloat ,isAspectRasio : Bool = true) -> UIFont {
        if isAspectRasio {
            return UIFont.init(name: "OpenSans-Bold" , size: fontSize * GConstant.Screen.HeightAspectRatio)!
        }else {
            return UIFont.init(name: "OpenSans-Bold" , size: fontSize)!
        }
    }

    class func applyBlocSSiBold(fontSize : CGFloat ,isAspectRasio : Bool = true) -> UIFont {
        if isAspectRasio {
            return UIFont.init(name: "BlocSSiBold" , size: fontSize * GConstant.Screen.HeightAspectRatio)!
        }else {
            return UIFont.init(name: "BlocSSiBold" , size: fontSize)!
        }
    }
}

//MARK:- UIView

extension UIView {
    
    class func viewFromNibName(name: String) -> UIView? {
        let views = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        return views!.first as? UIView
    }
    func applyCornerRadius(cornerRadius : CGFloat? = nil) {
        
        if cornerRadius != nil {
            self.layer.cornerRadius = cornerRadius!
            self.clipsToBounds = true
        }
        else {
            self.layer.cornerRadius = 0
        }
    }
    
    func applyViewShadow(shadowOffset : CGSize? = nil
        , shadowColor : UIColor? = nil
        , shadowOpacity : Float? = nil
        , cornerRadius      : CGFloat? = nil
        , backgroundColor : UIColor? = nil
        , backgroundOpacity : Float? = nil)
    {
        
        if shadowOffset != nil {
            self.layer.shadowOffset = shadowOffset!
        }
        else {
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        
        if shadowColor != nil {
            self.layer.shadowColor = shadowColor?.cgColor
        } else {
            self.layer.shadowColor = UIColor.clear.cgColor
        }
        
        //For button border width
        if shadowOpacity != nil {
            self.layer.shadowOpacity = shadowOpacity!
        }
        else {
            self.layer.shadowOpacity = 0
        }
        
        if cornerRadius != nil {
            self.layer.cornerRadius = cornerRadius!
        }
        else {
            self.layer.cornerRadius = 0
        }
        
        if backgroundColor != nil {
            self.backgroundColor = backgroundColor!
        }
        else {
            self.backgroundColor = UIColor.clear
        }
        
        if backgroundOpacity != nil {
            self.alpha = CGFloat(backgroundOpacity!)
        }
        else {
            self.layer.opacity = 1
        }
        
        self.layer.masksToBounds = false
    }
    
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    
    func addBottomBorderWithColor(color: UIColor,origin : CGPoint, width : CGFloat , height : CGFloat) -> CALayer {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:origin.x, y:self.frame.size.height - height, width:width, height:height)
        self.layer.addSublayer(border)
        return border
    }
    
    //Shammering Methods
    func startShimmering() {
        let light = UIColor(white: CGFloat(0), alpha: CGFloat(0.1)).cgColor
        let dark = UIColor.black.cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [dark, light, dark]
        gradient.frame = CGRect(x: CGFloat(-bounds.size.width), y: CGFloat(0), width: CGFloat(3 * bounds.size.width), height: CGFloat(bounds.size.height))
        gradient.startPoint = CGPoint(x: CGFloat(0.0), y: CGFloat(0.5))
        gradient.endPoint = CGPoint(x: CGFloat(1.0), y: CGFloat(0.525))
        // slightly slanted forward
        gradient.locations = [0.4, 0.5, 0.6]
        layer.mask = gradient
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1.5
        animation.repeatCount = MAXFLOAT
        gradient.add(animation, forKey: "shimmer")
        
    }
    
    func stopShimmering() {
        layer.mask = nil
    }
    
    func scaleAnimation(_ duration : Double! , scale : CGFloat!) {
        
        UIView.animate(withDuration: duration, animations: {
            
            self.superview?.isUserInteractionEnabled = false
            self.transform = CGAffineTransform(scaleX: 1 + scale, y: 1 + scale)
            
        }) { (isComplete : Bool) in
            
            UIView.animate(withDuration: duration, animations: {
                self.transform = CGAffineTransform(scaleX: 1 - scale, y: 1 - scale)
                
            }, completion: { (isComplete : Bool) in
                self.superview?.isUserInteractionEnabled = true
            })
        }
    }
}

//MARK:- UIButton

extension UIButton {
    
    func applyStyle(
        titleLabelFont     : UIFont?  = nil
        , titleLabelColor   : UIColor? = nil
        , cornerRadius      : CGFloat? = nil
        , borderColor       : UIColor? = nil
        , borderWidth       : CGFloat? = 1.5
        , state             : UIControlState = UIControlState.normal
        , backgroundColor   : UIColor? = nil
        , backgroundOpacity : Float? = nil
        ) {
        
        if cornerRadius != nil {
            self.layer.cornerRadius = cornerRadius!
        }
        else {
            self.layer.cornerRadius = 0
        }
        
        if borderColor != nil {
            self.layer.borderColor = borderColor?.cgColor
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
        
        if borderWidth != nil {
            self.layer.borderWidth = borderWidth!
        }
        else {
            self.layer.borderWidth = 0
        }
        
        if titleLabelFont != nil {
            self.titleLabel?.font = titleLabelFont
        }else {
            self.titleLabel?.font = UIFont.applyRegular(fontSize: 13.0)
        }
        
        if titleLabelColor != nil {
            self.setTitleColor(titleLabelColor, for: state)
        } else {
            self.setTitleColor(UIColor.black, for: state)
        }
        
        if backgroundColor != nil {
            self.backgroundColor = backgroundColor!
        }
        else {
            self.backgroundColor = UIColor.clear
        }
        
        if backgroundOpacity != nil {
            self.layer.opacity = backgroundOpacity!
        }
        else {
            self.layer.opacity = 1
        }
        
    }
    
}

//MARK:- UILabel

extension UILabel {
    
    func applyStyle(
        labelFont      : UIFont?  = nil
        , labelColor     : UIColor? = nil
        , cornerRadius   : CGFloat? = nil
        , borderColor    : UIColor? = nil
        , backgroundColor: UIColor? = nil
        , borderWidth    : CGFloat? = nil
        , labelShadow    : CGSize? = nil
        ) {
        
        if cornerRadius != nil {
            self.layer.cornerRadius = cornerRadius!
        }
        else {
            self.layer.cornerRadius = 0
        }
        
        if borderColor != nil {
            self.layer.borderColor = borderColor?.cgColor
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
        
        if backgroundColor != nil {
            self.backgroundColor = backgroundColor
        }
        
        if borderWidth != nil {
            self.layer.borderWidth = borderWidth!
        }
        else {
            self.layer.borderWidth = 0
        }
        
        if labelFont != nil {
            self.font = labelFont
        }
        
        if labelColor != nil {
            self.textColor = labelColor
        }
    }
    
    func addCharacterSpacing(value: CGFloat) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: value, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
    
    ///Find the index of character (in the attributedText) at point
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
    
}

//MARK:- UITextField

extension UITextField {
    
    func applyStyle(
        textFont    : UIFont?  = nil
        , textColor   : UIColor? = nil
        , cornerRadius       : CGFloat? = nil
        , borderColor       : UIColor? = nil
        , borderWidth       : CGFloat? = nil
        ) {
        
        if cornerRadius != nil {
            self.layer.cornerRadius = cornerRadius!
        }
        else {
            self.layer.cornerRadius = 0
        }
        
        if borderColor != nil {
            self.layer.borderColor = borderColor?.cgColor
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
        
        if borderWidth != nil {
            self.layer.borderWidth = borderWidth!
        }
        else {
            self.layer.borderWidth = 0
        }
        
        if textFont != nil {
            self.font = textFont
        }
        
        if textColor != nil {
            self.textColor = textColor
        }
    }
    
    func setAttributedPlaceHolder(placeHolderText : String , color : UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [NSAttributedStringKey.foregroundColor : color])
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    
    
}
//MARK:- UITextView

extension UITextView {
    
    
    func applyStyle(
        textFont    : UIFont?  = nil
        , textColor   : UIColor? = nil
        , cornerRadius       : CGFloat? = nil
        , borderColor       : UIColor? = nil
        , borderWidth       : CGFloat? = nil
        ) {
        
        if cornerRadius != nil {
            self.layer.cornerRadius = cornerRadius!
        }
        else {
            self.layer.cornerRadius = 0
        }
        
        if borderColor != nil {
            self.layer.borderColor = borderColor?.cgColor
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
        
        if borderWidth != nil {
            self.layer.borderWidth = borderWidth!
        }
        else {
            self.layer.borderWidth = 0
        }
        
        if textFont != nil {
            self.font = textFont
        }else {
            self.font = UIFont.applyRegular(fontSize: 13.0)
        }
        
        if textColor != nil {
            self.textColor = textColor
        } else {
            self.textColor = UIColor.black
        }
        
    }
    
}

//MARK: - UIImageView Extension

extension UIImageView {
    
    func applyStyle(cornerRadius : CGFloat? = nil
        , borderColor : UIColor? = nil
        , borderWidth : CGFloat? = nil
        ) {
        
        if cornerRadius != nil {
            self.layer.cornerRadius = cornerRadius!
            self.clipsToBounds = true
        }
        else {
            self.layer.cornerRadius = 0
        }
        
        if borderColor != nil {
            self.layer.borderColor = borderColor?.cgColor
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
        }
        
        if borderWidth != nil {
            self.layer.borderWidth = borderWidth!
        }
        else {
            self.layer.borderWidth = 0
        }
    }
    
    func setImageWithDownload(_ url : URL, withIndicator isIndicator: Bool = true) {
        if isIndicator {
            self.sd_setShowActivityIndicatorView(true)
            self.sd_setIndicatorStyle(.gray)
        }
        
        self.sd_setImage(with: url, placeholderImage: UIImage(), completed: {(image, error, cacheType, imageURL) -> Void in
            // Perform operation.
            if error != nil {
                print(" ============= ERROR ===============\n\n\(error!.localizedDescription)\n\n\(imageURL!)")
            }
        })
        
    }
    
}

//MARK:- Image Extension
extension UIImage {
    
    func isEqualToImage(_ image: UIImage) -> Bool {
        
        guard UIImagePNGRepresentation(self) != nil else {
            return false
        }
        
        guard UIImagePNGRepresentation(image) != nil else {
            return false
        }
        
        let data1: NSData = UIImagePNGRepresentation(self)! as NSData
        let data2: NSData = UIImagePNGRepresentation(image)! as NSData
        return data1.isEqual(data2)
    }
    
    func imageScale(scaledToWidth i_width: CGFloat) -> UIImage {
        let oldWidth: CGFloat = CGFloat(self.size.width)
        let scaleFactor: CGFloat = i_width / oldWidth
        let newHeight: CGFloat = self.size.height * scaleFactor
        let newWidth: CGFloat = oldWidth * scaleFactor
        UIGraphicsBeginImageContextWithOptions(CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight)), true, 0)
        self.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(newWidth), height: CGFloat(newHeight)))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func getPostImageScaleFactor(_ i_width: CGFloat) -> CGFloat {
        
        let oldWidth: CGFloat = CGFloat(self.size.width)
        let scaleFactor: CGFloat = oldWidth / i_width
        return scaleFactor
    }
    
    func getDeviceWiseImageScaleFactor(_ i_width: CGFloat) -> CGFloat {
        
        let oldWidth: CGFloat = CGFloat(self.size.width)
        let scaleFactor: CGFloat =  i_width / oldWidth
        return scaleFactor
    }
    
    
    
}

//MARK:- String

extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func findHeightForText(text: String, havingWidth widthValue: CGFloat, havingHeight heightValue: CGFloat, andFont font: UIFont) -> CGSize {
        let result: CGFloat = font.pointSize + 4
        var size: CGSize = CGSize()
        if text.count > 0 {
            
            let textSize: CGSize = CGSize(width: widthValue, height: (heightValue > 0.0) ? heightValue : heightValue)
            //Width and height of text area
            if #available(iOS 7, *) {
                //iOS 7
                let frame: CGRect = text.boundingRect(with: textSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
                
                size = CGSize(width: frame.size.width, height: frame.size.height + 1)
            }
            size.height = max(size.height, result)
            //At least one row
        }
        return size
    }
    
    func sizeOfString (font : UIFont) -> CGSize {
        return self.boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude),
                                 options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                 attributes: [NSAttributedStringKey.font: font],
                                 context: nil).size
    }
    
    func getHeight(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func getWidth(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.width
    }
    
    func url() -> URL {
        
        guard let url = URL(string: self) else {
            return URL(string : "www.google.co.in")!
        }
        return url
    }
    
    func applyDateCustomization() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self.lowercased())!
        
        dateFormatter.dateFormat  = "MMM dd, yyyy"
        let dateStr = dateFormatter.string(from: date)
        return dateStr
    }
    
    func decodeBase64() -> String {
        let decodedData = Data(base64Encoded: self, options: .ignoreUnknownCharacters)
        if let aData = decodedData {
            return String(data: aData, encoding: .utf8)!
        }
        return ""
    }
    
    func isValidAddress(showEmptyMessage: Bool) -> String {
        if self == " \n\n - \n" {
            if showEmptyMessage {
                return "You have not set up this type of address yet."
            }else{
                return "-"
            }
        }
        return self
    }
    
}

// MARK:- Dictionary

extension Dictionary {
    
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}

//MARK:- Date

extension Date {
    
    //--------------------------------------------------------------------------------------
    
//    ========================================
     /* Example of usage
     let firstDate = Date()
     let secondDate = firstDate
     Will return true
     let timeEqual = firstDate.time == secondDate.time
     */
    var time: Time {
        return Time(self)
    }
//    ==========================================
    
    //MARK: - convert date to local
    
    func convertToLocal(sourceDate : Date)-> Date{
        
        let sourceTimeZone                                     = NSTimeZone(abbreviation: "UTC")//NSTimeZone(name: "America/Los_Angeles") EDT
        let destinationTimeZone                                = NSTimeZone.system
        
        //calc time difference
        let sourceGMTOffset         : NSInteger                = (sourceTimeZone?.secondsFromGMT(for: sourceDate as Date))!
        let destinationGMTOffset    : NSInteger                = destinationTimeZone.secondsFromGMT(for:sourceDate as Date)
        let interval                : TimeInterval             = TimeInterval(destinationGMTOffset-sourceGMTOffset)
        
        //set currunt date
        let date: Date                                          = Date(timeInterval: interval, since: sourceDate as Date)
        return date
    }
    
    //--------------------------------------------------------------------------------------
    
    //MARK: - convert date to utc
    
    func convertToUTC(sourceDate : Date)-> Date{
        
        let sourceTimeZone                                      = NSTimeZone.system
        let destinationTimeZone                                 = NSTimeZone(abbreviation: "UTC") //NSTimeZone(name: "America/Los_Angeles") EDT
        
        //calc time difference
        let sourceGMTOffset         : NSInteger                 = (sourceTimeZone.secondsFromGMT(for:sourceDate as Date))
        let destinationGMTOffset    : NSInteger                 = destinationTimeZone!.secondsFromGMT(for: sourceDate as Date)
        let interval                : TimeInterval              = TimeInterval(destinationGMTOffset-sourceGMTOffset)
        
        //set currunt date
        let date: Date                                        = Date(timeInterval: interval, since: sourceDate as Date)
        return date
    }
    
    //------------------------------------------------------
    
    //MARK: - DateFormat
    
    func formatdateLOCAL(dt: String,dateFormat: String,formatChange: String) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = self.convertToLocal(sourceDate: dateFormatter.date(from: dt)! as Date)
        dateFormatter.dateFormat = formatChange
        return dateFormatter.string(from: date as Date)
    }
    
    func formatdateUTC(dt: String,dateFormat: String,formatChange: String) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date = self.convertToUTC(sourceDate: dateFormatter.date(from: dt)! as Date)
        dateFormatter.dateFormat = formatChange
        return dateFormatter.string(from: date as Date)
    }
    
    func getTimeStampFromDate() -> (double : Double,string : String) {
        let timeStamp = self.timeIntervalSince1970
        return (timeStamp,String(format: "%f", timeStamp))
    }
}

// MARK:- Navigation Controller
extension UINavigationController{
    func customize(isTransparent: Bool = false, isPicker: Bool? = false){
        
        let navigationFont                      = UIFont.applyBlocSSiBold(fontSize: UIDevice.current.userInterfaceIdiom == .pad ? 14.0 : 18.0)
        self.navigationBar.barTintColor         = GConstant.AppColor.blue
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes  = [NSAttributedStringKey.font:navigationFont, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage          = UIImage()
        self.navigationBar.layer.masksToBounds  = false
        
        if isTransparent {
            self.navigationBar.backgroundColor = .clear
            self.navigationBar.isTranslucent       = true
        }else{
            self.navigationBar.isTranslucent       = false
        }
        
    }
    
}

class BarButton : NSObject {
    var title : String?
    var image : UIImage?
    var color : UIColor?
    var tintColor : UIColor?
    var isLeftMenu : Bool?
    
    init(title : String? = nil, image: UIImage? = nil , color : UIColor? = nil , tintColor : UIColor? = nil, isLeftMenu : Bool? = nil) {
        self.title = title == nil ? "" : title
        self.image = image == nil ? UIImage() : image
        self.color = color == nil ? UIColor.white : color
        self.tintColor = tintColor == nil ? UIColor.white : tintColor
        self.isLeftMenu = isLeftMenu == nil ? true : isLeftMenu
    }
    
}

//MARK:- UIViewController
extension UIViewController {
    
    func toolBarDoneButtonClicked() {
        self.view.endEditing(true)
    }
    
    // add BarButton
    func addBarButtons(btnLeft : BarButton? , btnRight : BarButton? , title : String? , isShowLogo : Bool = false) -> [UIButton] {
        
        let btnFont = UIFont.applyRegular(fontSize: 15.0, isAspectRasio: false)
        var arrButtons : [UIButton] = [UIButton(),UIButton()]
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)]
        
        // setup for left button
        if btnLeft != nil {
            
            let leftButton = UIButton(type: .custom)
            leftButton.contentHorizontalAlignment = .left
            
            if btnLeft?.title == String() {
                
                if btnLeft?.image != UIImage() {
                    leftButton.setImage(btnLeft?.image, for: .normal)
                    leftButton.imageView?.contentMode = .scaleAspectFit
                }
                
            }else
            {
                leftButton.setTitleColor(btnLeft?.color, for: .normal)
                leftButton.setTitleColor(UIColor.white, for: .disabled)
                leftButton.setTitle(btnLeft?.title, for: .normal)
                leftButton.titleLabel?.font = btnFont
            }
            
            leftButton.adjustsImageWhenHighlighted = false
            leftButton.tintColor = btnLeft?.tintColor
            leftButton.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(44), height: 44)
            
            if (btnLeft?.isLeftMenu)! {
           
            }else{
                let leftBtnSelector: Selector = NSSelectorFromString("leftButtonClicked")
                if responds(to: leftBtnSelector) {
                    leftButton.addTarget(self, action: leftBtnSelector, for: .touchUpInside)
                }
            }
            
            let leftItem = UIBarButtonItem(customView: leftButton)
            navigationItem.leftBarButtonItems = [leftItem]
            arrButtons.removeFirst()
            arrButtons.insert(leftButton, at:0)
            
        }
        
        // setup for right button
        
        if btnRight != nil {
            
            let rightButton = UIButton(type: .custom)
            rightButton.contentHorizontalAlignment = .right
            rightButton.tintColor = UIColor.darkGray
            
            if btnRight?.title == String() {
                if btnRight?.image != UIImage() {
                    rightButton.setImage(btnRight?.image, for: .normal)
                    rightButton.imageView?.contentMode = .scaleAspectFit
                }
            }else
            {
                rightButton.setTitleColor(btnRight?.color, for: .normal)
                rightButton.setTitleColor(UIColor.white, for: .disabled)
                if btnRight?.image != UIImage() {
                    rightButton.setImage(btnRight?.image, for: .normal)
                    rightButton.imageView?.contentMode = .scaleAspectFit
                    rightButton.setTitle(" \(btnRight?.title ?? "")", for: .normal)
                }else{
                    rightButton.setTitle(btnRight?.title, for: .normal)
                }
                rightButton.titleLabel?.font = btnFont
            }
            
            rightButton.adjustsImageWhenHighlighted = false
            rightButton.tintColor = btnRight?.tintColor
            rightButton.frame = CGRect(x: 0, y: CGFloat(0), width: CGFloat(44), height: 44)
            let rightBtnSelector: Selector = NSSelectorFromString("rightButtonClicked")
            if responds(to: rightBtnSelector) {
                rightButton.addTarget(self, action: rightBtnSelector, for: .touchUpInside)
            }
            let rightItem = UIBarButtonItem(customView: rightButton)
            navigationItem.rightBarButtonItems = [rightItem]
            arrButtons.removeLast()
            arrButtons.append(rightButton)
            
        }
        
        if (title!.isEmpty) {
            if isShowLogo {
                navigationTitleImage(sender: self)
            }else{
                self.navigationItem.title = ""
            }
        }else{
            self.navigationItem.title = title
        }
        
        return arrButtons
    }
    
    func navigationTitleImage(sender: UIViewController){
        let logo = UIImage(named: "top_logo")
        let imageView = UIImageView(image:logo)
        sender.navigationItem.titleView = imageView
    }
}
//MARK: - UINavigationController
extension UINavigationController {
    func fadeTo(_ viewController: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionFade
        view.layer.add(transition, forKey: nil)
        pushViewController(viewController, animated: false)
    }
}
//MARK: - UIApplication
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

//MARK: -
extension Collection where Iterator.Element == String {
    var initials: [String] {
        return map{String($0.characters.prefix(1))}
    }
}

//MARK: -
extension Array where Element : Hashable {
    var unique: [Element] {
        return Array(Set(self))
    }
}

//MARK: -
extension Double
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        default:                                        return identifier
        }
    }
    
}
