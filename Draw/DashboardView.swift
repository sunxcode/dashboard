//
//  DashboardView.swift
//  ConcenPay
//
//  Created by YLCHUN on 16/2/17.
//  Copyright © 2016年 YLCHUN. All rights reserved.
//

import UIKit
import Foundation

class DashboardView: UIView,ETimerDelegate {

    private var wh:CGFloat=414.0//宽高，小屏幕采用缩放
    private var dashboardScore=350//信用分数
    
    private var dashboardTime="2016.01.01"{
        didSet{
            timeTextLayer?.string="评估时间："+dashboardTime
        }
    }
    
    private var dashboardScoreInterval=0//信用分数累加间隔（计时器执行一次累加数据）
    
    private var dashboardScoreTmp=350{
        didSet{
            countTextLayer?.string=dashboardScoreTmp.string
            switch true{
            case (dashboardScoreTmp>=350 && dashboardScoreTmp<550):
                dashboardLevel="较差"
            case (dashboardScoreTmp>=550 && dashboardScoreTmp<600):
                dashboardLevel="中等"
            case (dashboardScoreTmp>=600 && dashboardScoreTmp<650):
                dashboardLevel="良好"
            case (dashboardScoreTmp>=650 && dashboardScoreTmp<700):
                dashboardLevel="优秀"
            case (dashboardScoreTmp>=700 && dashboardScoreTmp<950):
                dashboardLevel="极好"
            default:
                break
            }
        }
    }
    
    private var dashboardLevel="较差"{
        didSet{
            levelTextLayer?.string="信用"+dashboardLevel
        }
    }
    
    private var animationTime=1.5
    
    private var countTextLayer:ETextLayer?//信用分数
    private var levelTextLayer:ETextLayer?//信用等级
    private var timeTextLayer:ETextLayer?//评估时间
    
    private var outerRingFgLayer:CAShapeLayer?//外圈显色圈
    private var dotLayer:CALayer?//外圈点
    
    private var bgLayer:CALayer?
    
    private let startAngle=158.0/180.0*Double.pi.cgFloat//外圈（底色圈）开始位置
    private let endAngle=22.0/180.0*Double.pi.cgFloat//外圈（底色圈）结束位置
    private let allAngle=224.0/180.0*Double.pi.cgFloat//外圈（底色圈）角度
    
    var zoomOffset:CGFloat{
        return UIScreen.main.bounds.width/414.0
    }
    
    private var endAngle_outerRingFg:CGFloat{//外圈（显色圈）结束位置
        let score=dashboardScore.double-350.0 //总分数－起始分数
        let angleI:Double=Double(allAngle/5.0)//大刻度线角度
        var endAngle:Double
        switch true{
        case (dashboardScore>=350 && dashboardScore<550):
            endAngle=angleI/200.0*score
        case (dashboardScore>=550 &&  dashboardScore<700):
            endAngle=angleI*3/150.0*(score-200.0)+angleI
        case (dashboardScore>=700 && dashboardScore<=950):
            endAngle=angleI/250.0*(score-350.0)+4*angleI
        default:
            endAngle=0.0
            break
        }
        return (endAngle.cgFloat+startAngle).truncatingRemainder(dividingBy: (2*Double.pi).cgFloat)//((endAngle.cgFloat+startAngle) % (2*Double.pi).cgFloat)
    }
    
    private var texts=["350","较差","550","中等","600","良好","650","优秀","700","极好","950"]//刻度文字
    
    private var eTimer:ETimer?//计时器
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    init(score:Int,time:String) {
        super.init(frame: CGRect(x:0,y:0,width:414,height:324))
        if score<350{
            dashboardScore=350
        }else if score>950{
            dashboardScore=950
        }else{
            dashboardScore=score
        }
        dashboardTime=time
        initV()
        zoom()
        startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //缩放适配宽度
    private func zoom(){//缩放适配宽度
        let s=zoomOffset
        self.transform = CGAffineTransform(scaleX: s, y: s)
    }
    //计时器代理
    func eTimerDidResume(eTimer:ETimer){
        dashboardScoreTmp=350
        //外圈(显色圈)动画
        let animation=CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = animationTime
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = 0
        animation.toValue = 1
        animation.autoreverses = false
        outerRingFgLayer?.add(animation, forKey: "strokeEndAnimation")
        animation.fillMode=kCAFillModeForwards
        //外圈点动画
        
        //外圈(显色点)动画
        let fromValue=startAngle+(Double.pi/2.0).cgFloat
        var toValue=endAngle_outerRingFg+(Double.pi/2.0).cgFloat
        if toValue<fromValue{
            toValue=(2.0*Double.pi).cgFloat+toValue
        }
        let animation_dotLayer=CABasicAnimation(keyPath: "transform.rotation.z")
        animation_dotLayer.duration = animationTime
        animation.repeatCount = 1
        animation_dotLayer.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation_dotLayer.fromValue = fromValue
        animation_dotLayer.toValue = toValue
        animation.fillMode=kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        dotLayer?.add(animation_dotLayer, forKey: "pathLayer")
    }
    
    func eTimerDidRefresh(eTimer:ETimer){
        dashboardScoreTmp+=dashboardScoreInterval
    }
    func eTimerDidCancel(eTimer:ETimer){
        dashboardScoreTmp=dashboardScore
    }
    //开始动画
    func startAnimation(){
        eTimer=ETimer(count: 150, interval: 0.01, delegate: self)
        dashboardScoreInterval=(dashboardScore-350)/150
        let _ = eTimer?.resume()
    }
    
    //初始化layer
    private func initV(){
        bgLayer=CALayer()
        bgLayer?.frame=CGRect(x: 0, y: 0, width: wh, height: wh)
        let scaleLineBW:CGFloat=0.006//粗刻度线宽度
        let scaleLineBS:CGFloat=0.003//细刻度线宽度
        let colorH=UIColor.white.withAlphaComponent(0.7)//高亮颜色
        let colorL=UIColor.white.withAlphaComponent(0.4)//灰暗颜色
        
        let center=CGPoint(x: wh/2.0, y: wh/2.0)
        
        //绘制外圈(底色圈)
        let outerRingBgLayer=EDraw.arcLayer(color: colorL, lineWidth: 2, center: center, radius: 150, startAngle: startAngle, endAngle: endAngle, clockWise: true)
        bgLayer?.addSublayer(outerRingBgLayer)
        
        //绘制内圈
        let innerRinglayer=EDraw.arcLayer(color: colorL, lineWidth: 10, center: center, radius: 138, startAngle: startAngle, endAngle: endAngle, clockWise: true)
        bgLayer?.addSublayer(innerRinglayer)
        
        //绘制内圈刻度线
        let scaleLineBW_count=6//长刻度线一共有条数
        let scaleLineBS_subCount=5//两个长刻度线中间的短刻度线
        let scaleLineIa=((224.0/(scaleLineBW_count*scaleLineBS_subCount).double)/180.0*Double.pi).cgFloat//刻度线间隔角度
        for i in 0...scaleLineBW_count*scaleLineBS_subCount{
            let angle=startAngle+scaleLineIa*i.cgFloat
            var layer:CAShapeLayer
            if  i%scaleLineBW_count==0{
                layer=EDraw.arcLayer(color: colorH.withAlphaComponent(0.4), lineWidth: 12, center: center, radius: 137, startAngle: angle, endAngle: angle+scaleLineBW, clockWise: true)
            }else{
                layer=EDraw.arcLayer(color: colorL.withAlphaComponent(0.3), lineWidth: 6, center: center, radius: 140, startAngle: angle, endAngle: angle+scaleLineBS, clockWise: true)
            }
            bgLayer?.addSublayer(layer)
        }
        
        
        let sPoint=center.offset(y:-126)
//        let cPoint=center
        
        
        let textsIa=((224.0/(texts.count-1).double)/180.0*Double.pi).cgFloat//刻度文字间隔角度
        
        for i in 0 ..< texts.count {
            var color:UIColor
            if i%2==0{
                color=colorH.withAlphaComponent(0.8)
            }else{
                color=colorL.withAlphaComponent(0.7)
            }
            let angle=startAngle+textsIa*i.cgFloat
            let l=cTextLayer(text: texts[i], font: UIFont(name: "Helvetica", size: 8)!, color: color, point: sPoint, anchor: CGPoint(x:0.5,y:0.5), angle: angle)
            bgLayer?.addSublayer(l)
        }
        
        //绘制中心位置大数字标签
        countTextLayer=EDraw.text(text: dashboardScore.string, font: UIFont(name: "Helvetica", size: 90)!, color: UIColor.white, point: center.offset(y:-30), anchor: CGPoint(x:0.5,y:0.5)) as? ETextLayer
        bgLayer?.addSublayer(countTextLayer!)
        
        //绘制中心位置优秀标签
        levelTextLayer=EDraw.text(text: "信用"+dashboardLevel, font: UIFont(name: "Helvetica", size: 35)!, color: UIColor.white, point: center.offset(y:30), anchor: CGPoint(x:0.5,y:0.5)) as? ETextLayer

        bgLayer?.addSublayer(levelTextLayer!)
        
        //绘制中心位置评估时间
        timeTextLayer=EDraw.text(text: "评估时间："+dashboardTime, font: UIFont(name: "Helvetica", size: 13)!, color: UIColor.white.withAlphaComponent(0.5), point: center.offset(y:60), anchor: CGPoint(x:0.5,y:0.5)) as? ETextLayer

        bgLayer?.addSublayer(timeTextLayer!)
        
        //绘制外圈(显色色圈)
        outerRingFgLayer=EDraw.arcLayer(color: colorH.withAlphaComponent(0.4), lineWidth: 2, center: center, radius: 150, startAngle: startAngle, endAngle: endAngle_outerRingFg, clockWise: true)
        bgLayer?.addSublayer(outerRingFgLayer!)
        
        //绘制外圈点
        dotLayer=dotPointLayer(color: UIColor.white, point: center.offset(y:-152), anchor: CGPoint(x:1,y:0.5), angle: endAngle_outerRingFg)
        bgLayer?.addSublayer(dotLayer!)
        
        self.layer.addSublayer(bgLayer!)
        
    }
    
    //绘制刻度标签文本
    private func cTextLayer(text:String,alignmentMode:String=kCAAlignmentCenter, font:UIFont = UIFont(name: "Helvetica", size: 17)!,color:UIColor=UIColor.black,point:CGPoint,anchor:CGPoint,angle:CGFloat)->CALayer{
        let textLayer=EDraw.text(text: text, alignmentMode: alignmentMode, font: font, color: color, point: point, anchor: anchor)
        let bgLayer=CALayer()
        bgLayer.frame=self.bgLayer!.bounds
        bgLayer.addSublayer(textLayer)
        bgLayer.transform=CATransform3DMakeRotation((Double.pi/2).cgFloat+angle, 0.0, 0.0, 1.0)
        return bgLayer
    }
    
    //绘制外圈白点
    private func dotPointLayer(color:UIColor=UIColor.black,point:CGPoint,anchor:CGPoint,angle:CGFloat)->CALayer{
        let layer=CAShapeLayer()
        let aPath = UIBezierPath()
        aPath.lineWidth = 1;
        aPath.addArc(withCenter: CGPoint(x: 2, y: 2), radius: 3, startAngle: 0, endAngle: (Double.pi*2.0).cgFloat, clockwise: true)
        aPath.fill()
        layer.path=aPath.cgPath
        layer.fillColor=color.cgColor
        layer.shadowColor=color.cgColor
        layer.position=point
        layer.anchorPoint=anchor
        
        layer.shadowColor = color.cgColor//阴影颜色
        layer.shadowOffset = CGSize(width: -1, height: 0)//偏移距离
        layer.shadowOpacity = 1//不透明度
        layer.shadowRadius = 3.0//半径
        
        let bgLayer=CALayer()
        bgLayer.frame=self.bgLayer!.bounds
        bgLayer.addSublayer(layer)
        bgLayer.transform=CATransform3DMakeRotation((Double.pi/2).cgFloat+angle, 0.0, 0.0, 1.0)
        return bgLayer
    }

}

