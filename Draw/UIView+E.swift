//
//  UIView+E.swift
//  ExpandC_Swift
//
//  Created by YLCHUN on 15/10/10.
//  Copyright © 2015年 ylchun. All rights reserved.
//

import UIKit
public enum LayoutDirection:Int {
    case x = 0
    case y = 1
}
private var selfController:UIViewController?
@IBDesignable extension UIView{
    /** view所在视图控制器 */
    final var controller:UIViewController?{
        get {
            var _controller=objc_getAssociatedObject(self, &selfController) as? UIViewController
            if _controller == nil {
                _controller=self.getControll()
                objc_setAssociatedObject(self, &selfController, _controller, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
            return _controller
        }
    }
    /** view所在视图控制器的导航控制器 */
    final var navigationController:UINavigationController?{
        get {
            return self.controller?.navigationController
        }
    }
    final var bottomY: CGFloat {
        get { return self.frame.origin.y + self.frame.size.height }
        set { self.frame.origin.y = newValue - self.frame.size.height }
    }
    
    public final var xw:CGFloat{
        get{
            
            return orignInWindow().x
        }
    }
    public final var yw:CGFloat{
        get{
            return orignInWindow().y
        }
    }
    
    public final var x:CGFloat{
        get{
            return self.frame.origin.x
        }
        set(newValue){
            self.frame.origin.x=newValue
        }
    }
    public final var y:CGFloat{
        get{
            return self.frame.origin.y
        }
        set(newValue){
            self.frame.origin.y=newValue
        }
    }
    
    public final var width:CGFloat{
        get{
            return self.frame.size.width
        }
        set(newValue){
            self.frame.size.width=newValue
        }
    }
    public var height:CGFloat{
        get{
            return self.frame.size.height
        }
        set(newValue){
            self.frame.size.height=newValue
        }
    }
    
    public final var xlc:CGFloat{
        get{
            return self.center.x
        }
        set(newValue){
            self.center=CGPoint(x: newValue, y: self.center.y)
        }
    }
    public final var ylc:CGFloat{
        get{
            return self.center.y
        }
        set(newValue){
            self.center=CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    public final var xsc:CGFloat{
        return self.width/2
    }
    public var ysc:CGFloat{
        return self.height/2
    }
    /**bounds中心点*/
    public final var center_bounds:CGPoint{
        return CGPoint(x: xsc, y: ysc)
    }
    public final var xAfter:(UIView,CGFloat) -> UIView {
        return ({
            (view:UIView, offset:CGFloat)->UIView  in
            self.x=view.frame.origin.x+view.width+offset
            return self
        })
    }
    public final var yAfter:(UIView,CGFloat) -> UIView{
        return({
            (view:UIView,offset:CGFloat)->UIView in
            self.y=view.frame.origin.y+view.height+offset
            return self
        })
    }
    
    public var xBefore:(UIView,CGFloat) -> UIView{
        return({
            (view:UIView,offset:CGFloat)->UIView in
            self.x=view.frame.origin.x-self.width-offset
            return self
        })
    }
    public final var yBefore:(UIView,CGFloat) -> UIView{
        return({
            (view:UIView,offset:CGFloat)->UIView in
            self.y=view.frame.origin.y-self.height-offset
            return self
        })
    }
    
    final var rectInWindow:CGRect{
        return self.convert(self.bounds, to: UIApplication.shared.delegate!.window! )
    }
    
    /**根据当前视图计算父视图高度（父视图底部与当前视图底部一致）*/
    func superviewH(_ offset:CGFloat=0)->CGFloat{
        if let superview=self.superview{
            let rect = self.convert(self.bounds, to: superview)
            return rect.origin.y+rect.size.height+offset
        }
        return 0
    }
    
    /**根据当前视图计算父视图宽度（父视图右部与当前视图右部一致）*/
    func superviewW(_ offset:CGFloat=0)->CGFloat{
        if let superview=self.superview{
            let rect = self.convert(self.bounds, to: superview)
            return rect.origin.x+rect.size.width+offset
        }
        return 0
    }
    
    /**
     设置圆角(圆角半径),优先级高于round
     */
    @IBInspectable public final var cornerRadius:CGFloat{
        get{
            return self.layer.cornerRadius
        }
        set(newValue){
            if newValue <= 0 {
                return
            }
            self.layer.cornerRadius=newValue
            self.layer.masksToBounds=true
        }
    }
    
    @IBInspectable public final var borderWidth:CGFloat{
        get{
            return self.layer.borderWidth
        }
        set(newVlue){
            self.layer.borderWidth=newVlue
        }
    }
    /**
     设置边框线颜色
     */
    @IBInspectable public final var borderColor:UIColor{
        get{
            if let color=self.layer.borderColor{
                return UIColor(cgColor: color)
            }
            return UIColor.clear
        }
        set(newValue){
            self.layer.borderColor=newValue.cgColor
        }
    }
    
    /**
     设置圆形(视图必须是方形)
     */
    @IBInspectable final var round:Bool{
        get{
//            self.layoutIfNeeded()
            if self.cornerRadius==self.bounds.height/2 {
                return true
            }
            return false
        }
        set(newValue){
//            self.layoutIfNeeded()
            if self.bounds.width==self.bounds.height {
                if newValue{
                    self.layer.cornerRadius=self.bounds.height/2
                    self.layer.masksToBounds=true
                }else{
                    self.layer.cornerRadius=0
                    self.layer.masksToBounds=false
                }
            }
        }
    }
    
    /**
     缩放
     */
    public func narrow(_ percentage:CGFloat){
        if percentage >= 0 && percentage != 1{
            let newTransform:CGAffineTransform=self.transform.scaledBy(x: percentage,y: percentage)
            self.transform=newTransform
        }else{
            self.transform = CGAffineTransform.identity
        }
    }
    
    /**
     抖动视图
     */
    public func shake(){
        let t:CGFloat = 2.0
        let translateRight:CGAffineTransform=CGAffineTransform.identity.translatedBy(x: t,y: 0.0)
        let translateLeft:CGAffineTransform=CGAffineTransform.identity.translatedBy(x: -t,y: 0.0)
        self.transform=translateLeft
        UIView.animate(withDuration: 0.07, delay: 0.0, options:[.autoreverse, .repeat], animations: { () -> Void in
            UIView.setAnimationRepeatCount(2.0)
            self.transform = translateRight
            }) { (finished) -> Void in
                if finished {
                    UIView.animate(withDuration: 0.05, delay: 0.0, options: .beginFromCurrentState, animations: { () -> Void in
                        self.transform = CGAffineTransform.identity
                        }, completion: nil)
                }
        }
    }
    
    /**
     晃动视图
     */
    public final var wobble:Bool{
        get{
            if self.layer.animation(forKey: "transform") == nil{
                return false
            }else{
                return true
            }
        }
        set(newValue){
            func angelToRandian(_ x:Double)->Double{
                return x/180.0*M_PI
            }
            if newValue {
                let animation:CAKeyframeAnimation=CAKeyframeAnimation()
                animation.keyPath="transform.rotation"
                animation.values=[angelToRandian(-0.5),angelToRandian(0.5),angelToRandian(-0.5)]
                animation.repeatCount=MAXFLOAT
                animation.duration=0.5
                self.layer.add(animation, forKey: "transform")
            }else{
                self.layer.removeAnimation(forKey: "transform")
            }
        }
    }
    
    
    /**
     *多视图居中布局，superview.frame需要确定
     */
    public func layoutCenter(_ direction:LayoutDirection,subviews:UIView...){
        var alll:CGFloat=0
        var offset:CGFloat=0
        if direction == .x{
            for view in subviews{
                view.x=alll
                alll+=view.width
            }
            offset=(self.width-alll)/2
            for view in subviews{
                view.x+=offset
            }
        }else{
            for view in subviews{
                view.y=alll
                alll+=view.height
            }
            offset=(self.height-alll)/2
            for view in subviews{
                view.y+=offset
            }
        }
    }
    
    //获取视图所在控制器
    fileprivate func getControll()->UIViewController?{
        var responder:UIResponder?=self
        while(responder != nil){
            if responder is UIViewController{
                return responder as? UIViewController
            }
            responder=responder?.next
        }
        return nil
    }
    
    
    /**
     背景颜色alpha,直接设置视图本身的alpha会劫持子视图
     */
    @IBInspectable final var cAlpha:CGFloat{
        get{
            var alpha:CGFloat=0
//            self.backgroundColor?.getHue(<#T##hue: UnsafeMutablePointer<CGFloat>##UnsafeMutablePointer<CGFloat>#>, saturation: <#T##UnsafeMutablePointer<CGFloat>#>, brightness: <#T##UnsafeMutablePointer<CGFloat>#>, alpha: <#T##UnsafeMutablePointer<CGFloat>#>)
            self.backgroundColor?.getRed(nil, green: nil, blue: nil, alpha: &alpha)
            return alpha
        }
        set(newValue){
            var red:CGFloat=0
            var green:CGFloat=0
            var blue:CGFloat=0
            self.backgroundColor?.getRed(&red, green: &green, blue: &blue, alpha: nil)
            
            self.backgroundColor=UIColor(red: red, green: green, blue: blue, alpha: newValue)
        }
    }
    
    /**调用所在视图控制器进行模态条转*/
    func presentViewController(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?){
        self.controller?.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    /**调用所在视图控制器进行模态返回*/
    func  dismissViewControllerAnimated(_ flag: Bool, completion: (() -> Void)?){
        self.controller?.dismiss(animated: flag, completion: completion)
    }
    
    /**清除所有子视图*/
    func clearAllSubview(){
        let subviews=self.subviews
        for view in subviews{
            view.removeFromSuperview()
        }
    }
    
    func orignInWindow()->CGPoint{
        var orignX=self.x
        var orignY=self.y
        var superView=self.superview
        while(superView != nil){
            orignX += superView!.x
            orignY += superView!.y
            if superView is UIWindow{
                break
            }
            superView = superView!.superview
        }
        return CGPoint(x: orignX, y: orignY)
    }
    
    /**设置圆角，圆角方向，圆角半径,默认5*/
    func cornerRadius(_ corners: UIRectCorner,radius:CGFloat=5){
        if radius<=0{
            self.layer.mask=nil
        }else{
            let maskPath=UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer=CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
    }
    
}
