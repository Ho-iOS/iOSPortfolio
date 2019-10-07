//
//  UIColor_AppColor.swift
//  portfolioTabBar
//
//  Created by Loho on 23/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

// Mark: - NSObject + reusableIdentifier
extension NSObject {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

// Mark: - custom Collection Border
extension UICollectionView {
    func setBorder(width:CGFloat, color:UIColor, corner: CGFloat) -> Void {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = corner
    }
}

// MARK: - custom button methods
extension UIButton {
    func setBorderColor(width:CGFloat, color:UIColor, corner: CGFloat) -> Void {
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = corner
    }
    func applyGradient(colours: [UIColor]) -> Void {
        self.layer.cornerRadius = 5
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.layer.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
}

// MARK: - custom textfield methods
extension UITextField {
    
    func setBorderColor(width:CGFloat, color:UIColor, corner: CGFloat) -> Void {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = corner
    }
}

extension UITextView {
    func setBorderColor(width:CGFloat, color:UIColor, corner: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = corner
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedArroun() {
        let tapGesture = UIGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    func applyNavGradient(colours: [UIColor]) -> UIImage? {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        gradientLayer.colors = colours.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
}

// MARK: - custom view methods
extension UIPageViewController {
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}

// MARK: - custom view methods
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0, paddingBottom: CGFloat = 0, paddingRight: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

}
// MARK: - custom color methods
extension UIColor {
    
    class func colorWithRGBHex(hex: Int, alpha: Float = 1.0) -> UIColor {
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue:CGFloat(b / 255.0), alpha: CGFloat(alpha))
    }
    
    class func colorWithHex(rgbValue: UInt32) -> UIColor {
        return UIColor( red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                        alpha: CGFloat(1.0))
    }
    
    class func colorWithHexString(hexStr: String) -> UIColor {
        var cString:String = hexStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (hexStr.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if (cString.isEmpty || (cString.count) != 6) {
            return colorWithHex(rgbValue: 0xFF5300);
        } else {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return colorWithHex(rgbValue: rgbValue);
        }
    }
    
    func changeImageColor(theImageView: UIImageView, newColor: UIColor) {
        theImageView.image = theImageView.image?.withRenderingMode(.alwaysOriginal)
        theImageView.tintColor = newColor;
    }
}

extension Date {
    
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo == 0 {
            return "Just now"
        }
        if secondsAgo < minute {
            if secondsAgo == 1 {
                return "\(secondsAgo) second ago"
            } else {
                return "\(secondsAgo) seconds ago"
            }
        } else if secondsAgo < hour {
            if secondsAgo / minute == 1 {
                return "\(secondsAgo / minute) minute ago"
            } else {
                return "\(secondsAgo / minute) minutes ago"
            }
        } else if secondsAgo < day {
            if secondsAgo / hour == 1 {
                return "\(secondsAgo / hour) hour ago"
            } else {
                return "\(secondsAgo / hour) hours ago"
            }
        } else if secondsAgo < week {
            if secondsAgo / day == 1 {
                return "\(secondsAgo / day) day ago"
            } else {
                return "\(secondsAgo / day) days ago"
            }
        }
        
        if secondsAgo / week == 1 {
            return "\(secondsAgo / week) week ago"
        } else {
            return "\(secondsAgo / week) weeks ago"
        }
    }
    
    func timeAgoDisplayShort() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo == 0 {
            return "Just now"
        }
        if secondsAgo < minute {
            return "\(secondsAgo)s"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute)m"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour)h"
        } else if secondsAgo < week {
            return "\(secondsAgo / day)d"
        }
        
        return "\(secondsAgo / week)wk"
    }
}

extension NSNotification.Name {
    static var updateHomeFeed = NSNotification.Name(rawValue: "updateFeed")
    static var updateUserProfileFeed = NSNotification.Name(rawValue: "updateUserProfileFeed")
}
