//
//  DelegateInterceptor.swift
//  Draw
//
//  Created by YLCHUN on 16/11/4.
//  Copyright © 2016年 ylchun. All rights reserved.
//

import Foundation
/*
class DelegateInterceptor: NSObject {
    weak var receiver: AnyObject?
    weak var middleMan: AnyObject?
    
    override func responds(to aSelector: Selector!) -> Bool {
        if String(describing: aSelector).hasPrefix("keyboardInput") {
            return  super.responds(to: aSelector)
        }else {
            if let middleMan = self.middleMan , middleMan.responds(to: aSelector) {
                return true
            }
            if let receiver = self.receiver , receiver.responds(to: aSelector) {
                return true
            }
            return super.responds(to: aSelector)
        }
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let middleMan = self.middleMan , middleMan.responds(to: aSelector) {
            return middleMan
        }
        if let receiver = self.receiver , receiver.responds(to: aSelector) {
            return receiver
        }
        return super.forwardingTarget(for: aSelector)
    }
}
*/
class DelegateInterceptor {
    weak var receiver: AnyObject?
    weak var middleMan: AnyObject?
    
    func responds(to aSelector: Selector!) -> Bool {
        if String(describing: aSelector).hasPrefix("keyboardInput") {
            return  false;
        }else {
            if let middleMan = self.middleMan , middleMan.responds(to: aSelector) {
                return true
            }
            if let receiver = self.receiver , receiver.responds(to: aSelector) {
                return true
            }
            return false;
        }
    }
    
    func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let middleMan = self.middleMan , middleMan.responds(to: aSelector) {
            return middleMan
        }
        if let receiver = self.receiver , receiver.responds(to: aSelector) {
            return receiver
        }
        return nil
    }
}
