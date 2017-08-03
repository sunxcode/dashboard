//
//  EDraw.swift
//  ConcenPay
//
//  Created by YLCHUN on 16/1/15.
//  Copyright © 2016年 YLCHUN. All rights reserved.
//

import UIKit

class EDraw {
    /**绘制多条风格一致的线条线条layer*/
    class func linesLayer(width: CGFloat = 1, color:UIColor, sdW: (solidW: Float, dottedW: Float)? = nil, lines: (startPoint: CGPoint, endPoint: CGPoint)...) -> CAShapeLayer {
        let lineLayer = CAShapeLayer()
        let path = CGMutablePath()
        for line in lines{
            path.move(to: line.startPoint)
            path.addLine(to: line.endPoint)
        }
        lineLayer.path = path
        lineLayer.lineWidth = width
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = color.cgColor
        if let sdW = sdW, sdW.solidW>0 && sdW.dottedW>0 {
            lineLayer.lineDashPattern = [NSNumber(value: sdW.solidW),NSNumber(value: sdW.dottedW)]
        }
        return lineLayer
    }
    
    /**绘制线条layer*/
    class func lineLayer(startPoint: CGPoint, endPoint: CGPoint, width: CGFloat=1, color: UIColor, sdW: (solidW: Float,dottedW: Float)? = nil) -> CAShapeLayer {
        let lineLayer = CAShapeLayer()
        let path = CGMutablePath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        lineLayer.path = path
        lineLayer.lineWidth = width
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = color.cgColor
        if let sdW=sdW, sdW.solidW>0 && sdW.dottedW>0 {
            lineLayer.lineDashPattern = [NSNumber(value: sdW.solidW),NSNumber(value: sdW.dottedW)]
        }
        return lineLayer
    }
    
    /**绘制图形路径*/
    class func linePath(closed: Bool = false, points: CGPoint...) -> CGMutablePath{
        let path = CGMutablePath()
        for i in 0 ... points.count-2{
            if i == 0 {
                path.move(to: points[i])
            }else{
                if !closed {
                    path.move(to: points[i])
                }
            }
            path.addLine(to: points[i+1])
        }
        return path
    }
    
    /**绘制多点线条路径*/
    class func lineLayer(width: CGFloat = 1,color: UIColor, sdW: (solidW: Float, dottedW: Float)? = nil, points: CGPoint...)->CAShapeLayer{
        let lineLayer = CAShapeLayer()
        let path = CGMutablePath()
        for i in 0 ... points.count-2{
            path.move(to: points[i])
            path.addLine(to: points[i+1])
        }
        lineLayer.path = path
        lineLayer.lineWidth = width
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = color.cgColor

        if let sdW = sdW, sdW.solidW>0 && sdW.dottedW>0 {
            lineLayer.lineDashPattern = [NSNumber(value: sdW.solidW),NSNumber(value: sdW.dottedW)]
        }
        return lineLayer
    }
    
    /**绘制圆形layer*/
    class func ellipseLayer(centerPoint: CGPoint, radius: (distance: CGFloat, border: CGFloat), fillColor: UIColor,borderColor: UIColor? = nil) -> CAShapeLayer{
        let ellipseLayer = CAShapeLayer()
        let path = CGMutablePath()
        ellipseLayer.lineWidth = radius.border
        if let borderColor = borderColor{
            ellipseLayer.strokeColor = borderColor.cgColor
        }
        ellipseLayer.fillColor = fillColor.cgColor
        let diameter = radius.distance+radius.distance+radius.border
        let offset = diameter/2
        
        path.addEllipse(in: CGRect(x:centerPoint.x-offset, y:centerPoint.y-offset, width:diameter, height:diameter))
        ellipseLayer.path = path
        return ellipseLayer
    }
    
    /**绘制文本*/
    class func text(text: String, alignmentMode: String = kCAAlignmentCenter, font: UIFont = UIFont(name: "Helvetica", size: 17)!, color: UIColor = UIColor.black, point: CGPoint, anchor: CGPoint) -> CATextLayer{
        let textLayer = ETextLayer()
        textLayer.font = font
        textLayer.anchorPoint = anchor
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.color = color.cgColor
        textLayer.position = point
        textLayer.string = text
        return textLayer
    }
    /**绘制弧线layer，默认顺时针方向绘制*/
    class  func arcLayer(color: UIColor?, lineWidth: CGFloat, center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockWise: Bool = true) -> CAShapeLayer {
        //layer
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.lineCap = kCALineCapButt
        pathLayer.fillColor = UIColor.clear.cgColor
        if let color = color {
            pathLayer.strokeColor = color.cgColor
        }
        pathLayer.lineWidth = lineWidth
        pathLayer.strokeStart = 0.0
        pathLayer.strokeEnd = 1.0
        pathLayer.backgroundColor = UIColor.clear.cgColor
        //path
        let path: UIBezierPath = UIBezierPath()
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockWise)
        path.stroke()
        pathLayer.path = path.cgPath
        return pathLayer
    }
    
    
    /**绘制渐变涂层layer*/
    class func gradientLayer(rect: CGRect? = nil, startAnchor: CGPoint, endAnchor: CGPoint, colors: UIColor ...)->CAGradientLayer{
        /*
        startAnchor、endAnchor 取值
        (0.0,0.0)  (0.5,0.0)  (1.0,0.0)
        (0.0,0.5)  (0.5,0.5)  (1.0,0.5)
        (0.0,0.1)  (0.5,0.1)  (1.0,0.1)
        */
        var cgColor:[CGColor] = []
        for c in colors{
            cgColor.append(c.cgColor)
        }
        let layer = CAGradientLayer()
        layer.colors = cgColor
        layer.startPoint = startAnchor
        layer.endPoint = endAnchor
        if let rect = rect{
            layer.frame = rect
        }
        return layer
    }
}

