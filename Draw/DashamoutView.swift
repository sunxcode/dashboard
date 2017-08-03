//
//  DashamoutView.swift
//  ConcenPay
//
//  Created by YLCHUN on 16/2/22.
//  Copyright © 2016年 YLCHUN. All rights reserved.
//

import UIKit

class DashamoutView: UIView ,ETimerDelegate{

    var zoomOffset:CGFloat{
        return UIScreen.main.bounds.width/414.0
    }
    
    private let startAngle = -(Double.pi/2)//外圈（底色圈）开始位置
    private var endAngle=0.0//外圈（底色圈）结束位置
     private var eTimer:ETimer?//计时器
    
    private var arcLayer:CAShapeLayer?//环形圈
    private var contentTxteLater:ETextLayer?//信用分数
    
    private var dashAmoutTmp=0{
        didSet{
            contentTxteLater?.string=dashAmoutTmp.string
        }
    }

    private var animationTime=1.5
    private var dashAmoutInterval=0//信用分数累加间隔（计时器执行一次累加数据）
    private var wh:CGFloat=414.0//宽高，小屏幕采用缩放
    private var dashAmout=20000//可用额度
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    init( available:Int=0, combination:Int=0) {
        super.init(frame: CGRect(x: 0, y: 0, width: wh, height: 324))
        dashAmout=available
//        dashboardTime=time
        initRoundView(available: available, combination)
        zoom()
//        self.backgroundColor=UIColor.greenColor()
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
    
    func initRoundView( available:Int=0,_ combination:Int=0){
        if available<=0{
//            butCread.enabled=false
        }else{
//            butCread.enabled=true
        }
        let center=self.center_bounds.offset(y:20)
        let radius:CGFloat=130.0
        //绘制背景圆
//        let roundLayer=EDraw.ellipseLayer(center, radius: (radius,0), fillColor: UIColor.whiteColor())
//        self.layer.addSublayer(roundLayer)
        
        //
        //        let roundLayer2=EDraw.ellipseLayer(center, radius: (radius-8,0), fillColor: UIColor.whiteColor().colorWithAlphaComponent(0.45))
        //        self.viewRoundBg.layer.addSublayer(roundLayer2)
        
        let color=UIColor.white//.colorWithHexString("#b3b3b3")
        
        let ringLayer=EDraw.arcLayer(color: color.withAlphaComponent(0.4), lineWidth: 12, center: center, radius: radius, startAngle: 0, endAngle: 2*Double.pi.cgFloat)
        self.layer.addSublayer(ringLayer)
        
     
        
        let allAngle=available.double/combination.double*2.0*Double.pi
//        let startAngle = -(Double.pi/2)//(Double.pi/2)+(2.0*Double.pi-allAngle)/2.0
        endAngle=startAngle-allAngle//startAngle+allAngle
//        let endAngle2=(Double.pi/2)-(2.0*Double.pi-allAngle)/2.0
        
        
//        let arcLayer=EDraw.arcLayer( color.colorWithAlphaComponent(0.55), lineWidth: 12, center: center, radius: radius, startAngle: startAngle.cGFloat, endAngle: endAngle.cGFloat)
//        arcLayer.lineCap = kCALineCapRound
//        self.layer.addSublayer(arcLayer)
        
        arcLayer=EDraw.arcLayer( color: color.withAlphaComponent(0.55), lineWidth: 12, center: center, radius: radius, startAngle: startAngle.cgFloat, endAngle: endAngle.cgFloat,clockWise:false)

        self.layer.addSublayer(arcLayer!)

//        
//        let arcLayerR=EDraw.arcLayer( color.colorWithAlphaComponent(0.55), lineWidth: 12, center: center, radius: radius, startAngle: -((Double.pi/2)).cGFloat, endAngle: endAngle2.cGFloat)
////        arcLayerR.lineCap = kCALineCapRound
//        self.layer.addSublayer(arcLayerR)
        
        
        let contentTxteLater0=EDraw.text(text: "可用额度（元）", font: UIFont(name: "Helvetica", size: 13)!, color: color.withAlphaComponent(0.4), point: center.offset(y:-30), anchor: CGPoint(x:0.5,y:1.0))
        self.layer.addSublayer(contentTxteLater0)
        //Helvetica-Bold
        contentTxteLater=EDraw.text(text: available.string, font: UIFont(name: "Helvetica", size: 60)!, color: color, point: center, anchor: CGPoint(x:0.5,y:0.5)) as? ETextLayer
        self.layer.addSublayer(contentTxteLater!)
        
        let contentTxteLater1=EDraw.text(text: "总额度：¥"+combination.string, font: UIFont(name: "Helvetica", size: 13)!, color: color.withAlphaComponent(0.4), point: center.offset(y:30), anchor: CGPoint(x:0.5,y:0.0))
        self.layer.addSublayer(contentTxteLater1)
    }
    
    //计时器代理
    func eTimerDidResume(eTimer:ETimer){
        dashAmoutTmp=0
        //外圈(显色圈)动画
        let animation=CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = animationTime
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = 0
        animation.toValue = 1
        animation.autoreverses = false
        arcLayer?.add(animation, forKey: "strokeEndAnimation")
        animation.fillMode=kCAFillModeForwards
        //外圈点动画
    }
    
    func eTimerDidRefresh(eTimer:ETimer){
        dashAmoutTmp+=dashAmoutInterval
    }
    
    func eTimerDidCancel(eTimer:ETimer){
        dashAmoutTmp=dashAmout
    }
    //开始动画
    func startAnimation(){
        eTimer=ETimer(count: 150, interval: 0.01, delegate: self)
        dashAmoutInterval=(dashAmout)/150
        let _ = eTimer?.resume()
    }
    



}
