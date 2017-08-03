//
//  CGPoint+E.swift
//  ConcenPay
//
//  Created by YLCHUN on 16/1/11.
//  Copyright © 2016年 YLCHUN. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint{
    /**x向偏*/
    func offset(x: CGFloat) -> CGPoint {
       return CGPoint(x: self.x+x, y: self.y)
    }
    
    /**y向偏*/
    func offset(y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x, y: self.y+y)
    }
    
    /**xy向偏*/
    func offset(x: CGFloat, y: CGFloat) -> CGPoint {
        return CGPoint(x: self.x+x, y: self.y+y)
    }
    
    /**point向偏*/
    func offset(point: CGPoint) -> CGPoint {
        return offset(x: point.x, y: point.y)
    }
    
    /**点是否位于区域内部*/
    func isIn(rect: CGRect, doCode: (()->Void)? = nil) -> Bool {
        let b = rect.contains(self)
        if b {
            doCode?()
        }
        return b
    }
    
    /**点是否位于区域外部*/
    func isOut(rect: CGRect, doCode: (()->Void)? = nil) -> Bool {
        let b = !rect.contains(self)
        if b {
            doCode?()
        }
        return b
    }
    
    /**点是否位于视图内部时候执行代码*/
    func isIn(view: UIView, doCode: (()->Void)? = nil) -> Bool {
        return isIn(rect: view.frame, doCode: doCode)
    }
    
    /**点是否位于视图外部部时候执行代码*/
    func isOut(view: UIView, doCode:(()->Void)? = nil) -> Bool {
        return isOut(rect: view.frame, doCode: doCode)
    }
    
    /**计算到另一点之间的距离*/
    func distance(to: CGPoint) -> CGFloat {
        let xDist = (self.x - to.x);
        let yDist = (self.y - to.y);
        return sqrt((xDist * xDist) + (yDist * yDist));
    }
    
    func center(to: CGPoint) -> CGPoint {
        return CGPoint(x: (self.x+to.x)/2.0, y: (self.y+to.y)/2.0)
    }
    
}

/**获取两点中心点坐标*/
public func CGCenter(point1: CGPoint, point2: CGPoint) -> CGPoint {
    return CGPoint(x: (point1.x+point2.x)/2.0, y: (point1.y+point2.y)/2.0)
}
