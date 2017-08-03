//
//  ETextLayer.swift
//  ConcenPay
//
//  Created by YLCHUN on 16/1/15.
//  Copyright © 2016年 YLCHUN. All rights reserved.
//

import UIKit

class ETextLayer:CATextLayer{
    private lazy var _position: CGPoint = CGPoint(x: 0, y: 0)
    private lazy var _anchorPoint: CGPoint = CGPoint(x: 0, y: 0)
    private lazy var _font: UIFont = UIFont(name: "Helvetica", size: 17)!
    
    final var color:CGColor? {
        get{
            return foregroundColor
        }
        set(newValue){
            foregroundColor = newValue
        }
    }
    override final var string: Any? {
        didSet{
            update()
        }
    }
    
    override final var font: AnyObject? {
        didSet{
            if let font = font as? UIFont {
                _font = font
                fontSize = font.pointSize
                update()
            }
            
        }
    }
    
    override final var position: CGPoint {
        didSet{
            _position = position
        }
    }
    
    override final var anchorPoint: CGPoint {
        didSet{
            _anchorPoint = anchorPoint
        }
    }
    
    func update() {
        let size = (string as? NSString ?? "").size(attributes: [NSFontAttributeName : _font])
        CATransaction.setDisableActions(true)
        bounds = CGRect(x:0, y:0, width:size.width, height:size.height)
        CATransaction.setDisableActions(false)
        anchorPoint = _anchorPoint
        position = _position
        contentsScale = UIScreen.main.scale
    }
    
}

