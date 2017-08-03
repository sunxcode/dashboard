//
//  UIColor+E.swift
//  CloudBill_Swift
//
//  Created by YLCHUN on 15/11/4.
//  Copyright © 2015年 easyinfoo. All rights reserved.
//

import Foundation
import UIKit
extension UIColor{
    
    /**调整透明度创建新颜色*/
    func newAlpha(_ alpha: CGFloat) -> UIColor{
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: nil)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    final var alpha: CGFloat{
        get{
            var alpha: CGFloat = 0
            self.getRed(nil, green: nil, blue: nil, alpha: &alpha)
            return alpha
        }
    }
    
    class func RGB(red: Int, green: Int, blue: Int)->UIColor{
        return RGBA(red: red, green: green, blue: blue, alpha: 255)
    }
    
    class func RGBA(red: Int, green: Int, blue: Int, alpha: Int)->UIColor{
        let v:CGFloat = 255.0
        return UIColor(red: CGFloat(red)/v, green: CGFloat(green)/v, blue: CGFloat(blue)/v, alpha: CGFloat(alpha)/v)
    }
    
    
    public convenience init(hexString:String){
        var cString =  hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.length < 6) {
            self.init(red: 1, green: 1, blue: 1, alpha: 0)
            return
        }
        
        // strip 0X if it appears
        if cString.hasPrefix("0X"){
            cString = cString.subString(from:2)
        }
        if cString.hasPrefix("#"){
            cString = cString.subString(from:1)
        }
        if cString.length != 6{
            self.init(red: 1, green: 1, blue: 1, alpha: 0)
            return
        }
        
        //r
        let rString = cString.subString(from:0, length: 2)
        
        //g
        let gString = cString.subString(from:2, length: 2)
        
        //b
        let bString = cString.subString(from:4, length: 2)
        
        // Scan values
        //        var r, g, b:Int
        var r:uint=0
        var g:uint=0
        var b:uint=0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        let v:CGFloat = 255.0
        self.init(red: CGFloat(r)/v, green: CGFloat(g)/v, blue: CGFloat(b)/v, alpha: 1)
    }
}






