//
//  N+E.swift
//  ConcenPay
//
//  Created by YLCHUN on 16/1/23.
//  Copyright © 2016年 YLCHUN. All rights reserved.
//

import Foundation
import UIKit
extension Double{
    //保留几位小数字符串
    func string(_ dot:UInt)->String{
        return String(format: "%.\(dot)f", self)
    }
    var string:String{
        return String(format: "%f", self)
    }
    var float:Float{
        return Float(self)
    }
    var cgFloat:CGFloat{
        return CGFloat(self)
    }
//    var to2Dot:Double{
//        return (Double(Int(100*self))/100)
//    }
//    
//    var to4Dot:Double{
//        return (Double(Int(10000*self))/10000)
//    }
//    
//    func toDot(_ dot:UInt) -> Double {
//        let dotN = pow(10.0, Double(dot))
//        return (Double(Int(dotN*self))/dotN)
//    }
}

extension Float{
    //保留几位小数字符串
    
    func string(_ dot: UInt) -> String {
        return String(format: "%.\(dot)f", self)
    }
    var string: String {
        return String(format: "%f", self)
    }
    var double: Double {
        return Double(self)
    }
    var cgFloat: CGFloat {
        return CGFloat(self)
    }

//    var to2Dot: Float {
//        return (Float(Int(100*self))/100)
//    }
//    
//    var to4Dot: Float {
//        return (Float(Int(10000*self))/10000)
//    }
//    
//    func toDot(_ dot:UInt) -> Float {
//        let dotN = pow(10.0, Float(dot))
//        return (Float(Int(dotN*self))/dotN)
//    }
}

extension CGFloat {
    //保留几位小数字符串
    func string(_ dot: UInt) -> String{
        return String(format: "%.\(dot)f", self)
    }
    var string: String {
        return String(format: "%f", self)
    }

    var double: Double {
        return Double(self)
    }
    var float: Float {
        return Float(self)
    }
    
//    var to2Dot: CGFloat {
//        return (CGFloat(Int(100*self))/100)
//    }
//    
//    var to4Dot:CGFloat {
//        return (CGFloat(Int(10000*self))/10000)
//    }
//    
//    func toDot(_ dot:UInt) -> CGFloat {
//        let dotN = pow(10.0, CGFloat(dot))
//        return (CGFloat(Int(dotN*self))/dotN)
//    }
}

extension Int{
    //保留几位小数字符串
    func string(_ dot: UInt) -> String{
        var str = ""
        if dot > 0{
            str = "."
            for _ in 1...dot{
                str += "0"
            }
        }
        return String(format: "%d", self)+str
    }
    var string: String{
        return String(format: "%d", self)
    }
    var double: Double{
        return Double(self)
    }
    var float: Float{
        return Float(self)
    }
    var cgFloat:CGFloat{
        return CGFloat(self)
    }
}


