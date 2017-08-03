//
//  ScoreView.swift
//  Test_Demo
//
//  Created by YLCHUN on 16/1/4.
//  Copyright © 2016年 ylchun. All rights reserved.
//

import UIKit

@IBDesignable class ScoreView: UIView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    @IBInspectable let all:Int=800//最大分数
    
    var pointerLayer:CAShapeLayer?
    var pointerStartAngle:CGFloat=0.0
    var pointerEndAngle:CGFloat=0.0
    
    let beginAngle=CGFloat(M_PI)
    let intervalAngle=CGFloat(M_PI/100)
    let contentAngle=CGFloat((M_PI-M_PI/100*3.0)/4.0)
    

    func draw(){
        self.backgroundColor=UIColor.clear
        let lineWidth:CGFloat=30
        let pointerWidth=lineWidth/4
        let radius = (self.width-lineWidth)/2
        let pointerLength=radius+pointerWidth
        
        let centerPoint=CGPoint(x: xsc, y: xsc)
        
        let colors=[UIColor(hexString: "#f16800"),UIColor(hexString: "#f5d700"),UIColor(hexString: "#7ec600"),UIColor(hexString: "#14aa01")]
        
        for i in 0...3{
            let startAngle=beginAngle+(intervalAngle+contentAngle) * CGFloat(i)
            let endAngle=startAngle+contentAngle
            let layer=getShapeLayerWithARCPath(color: colors[i], lineWidth: lineWidth, center: centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockWise: true)
            self.layer.addSublayer(layer)
        }
        if pointerLayer==nil{
            pointerLayer=CAShapeLayer()
            let path: UIBezierPath = UIBezierPath()
            pointerLayer?.bounds=bounds//CGRectMake(0, 0, x, x/2)
            let point0=CGPoint(x: centerPoint.x-pointerLength, y: centerPoint.y)
            let point1=CGPoint(x: centerPoint.x, y: centerPoint.y-pointerWidth/2.0)
            let point2=CGPoint(x: centerPoint.x+pointerWidth, y: centerPoint.y)
            let point3=CGPoint(x: centerPoint.x, y: centerPoint.y+pointerWidth/2.0)
            path.move(to: point0)
            path.addLine(to: point1)
            path.addLine(to: point2)
            path.addLine(to: point3)
            path.addLine(to: point0)
            pointerLayer?.path=path.cgPath
            pointerLayer?.fillColor=UIColor(hexString: "#5c5c5c").cgColor
            pointerLayer?.lineWidth=1
            pointerLayer?.strokeColor=nil//UIColor.blackColor().CGColor//UIColor.colorWithHexString("#dddddd").CGColor
            pointerLayer?.anchorPoint=CGPoint(x: 0.5, y: 1)
            pointerLayer?.position=centerPoint
            layer.addSublayer(pointerLayer!)
        }
    }
    
    private func calculateAngle( value:Int)->CGFloat{
        var value = value
        let actualAll=intervalAngle/beginAngle*CGFloat(all)*3+CGFloat(all)
        if value>=all{//最大分数为1000分
            value=all
        }
        if value<0{
            value=0
        }
        var n=CGFloat(value/(all/4))
        if value==all{//等于1000时候
            n-=1
        }
        let angle=CGFloat(value)/actualAll*beginAngle+n*intervalAngle//1000分下分数值对应角度
        return angle
    }
    
    func pointer(value:Int){
        pointerEndAngle=calculateAngle(value: value)
        let animation=CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 0.7; // 持续时间
        animation.repeatCount = 1; // 重复次数
        animation.fromValue = 0// 起始角度
        animation.toValue = pointerEndAngle // 终止角度
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fillMode=kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        pointerLayer?.add(animation, forKey: "pathLayer")
    }
    
    private func getShapeLayerWithARCPath(color: UIColor?, lineWidth: CGFloat, center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockWise: Bool) -> CAShapeLayer {
        //layer
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.lineCap = kCALineCapButt
        pathLayer.fillColor = UIColor.clear.cgColor
        if (color != nil) {
            pathLayer.strokeColor = color!.cgColor
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
    
    
    
}
