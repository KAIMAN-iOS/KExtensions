//
//  UIColor+Ext.swift
//  CovidApp
//
//  Created by jerome on 06/04/2020.
//  Copyright © 2020 Jerome TONNELIER. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    class func random() -> UIColor {
        return UIColor.init(red: CGFloat(CGFloat((arc4random_uniform(100) + 1))/100.0),
                            green: CGFloat(CGFloat((arc4random_uniform(100) + 1))/100.0),
                            blue: CGFloat(CGFloat((arc4random_uniform(100) + 1))/100.0),
                            alpha: 0.8)
    }
}

public extension UIColor {
    convenience init(hexString:String, defaultReturn: UIColor = .black) {
        
        let scanner  = Scanner(string: hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        guard scanner.scanHexInt32(&color) == true else {
            self.init(cgColor: defaultReturn.cgColor)
            return
        }
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
    
    var luminanceValue : UIColor {
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 0
        var alpha:CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let luminance: CGFloat = 0.2126 * inv_gam_sRGB(ic: red) + 0.7152 * inv_gam_sRGB(ic: green) + 0.0722 * inv_gam_sRGB(ic: blue)
        let luminance_saturated: CGFloat = luminance <= 0 ? 0 : luminance >= 1 ? 1 : luminance
        return luminance_saturated > 0.179 ? UIColor.black : UIColor.white
    }
    
    func inv_gam_sRGB(ic:CGFloat) -> CGFloat{
        if ( ic <= 0.03928 ) {
            return ic/12.92
        } else {
            return pow(((ic+0.055)/(1.055)),2.4)
        }
    }
}

public extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return self
        }
    }
}
