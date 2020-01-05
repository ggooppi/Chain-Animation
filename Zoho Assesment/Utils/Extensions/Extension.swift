//
//  Extension.swift
//  Zoho Assesment
//
//  Created by gopinath.a on 05/01/20.
//

import Foundation
import UIKit
import Charts

extension UIView{
    func roundedCorners(radius: CGFloat) -> Void {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

extension String{
    func toRGBColor() -> UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIColor{
    @nonobjc class var themeColor: UIColor {
        return "#19C6B5".toRGBColor()
    }
}
