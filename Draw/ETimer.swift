//
//  ETimer.swift
//  ExpandC_Swift
//
//  Created by YLCHUN on 15/10/10.
//  Copyright © 2015年 ylchun. All rights reserved.
//

import UIKit

enum ETimerStatus {
    case Resume//执行中
    case Cancel//停止
    case Suspend//暂停
}


@objc public protocol ETimerDelegate {
    
    @objc optional func eTimerDidCancel(eTimer:ETimer)
    
    @objc optional func eTimerDidRefresh(eTimer:ETimer)
    
    @objc optional func eTimerDidSuspend(eTimer:ETimer)
    
    @objc optional func eTimerDidResume(eTimer:ETimer)
}


public class ETimer:NSObject {
    private var timer:Timer?
    private var count:NSInteger = 0
    private var tCount:NSInteger = 0
    private var interval:TimeInterval = 1
    private var status:ETimerStatus = .Cancel
    private var runLoop:RunLoop?
    private var delegate:AnyObject!
    
    private static var ETimer_Queue:DispatchQueue?
    private var queue:DispatchQueue {
        if ETimer.ETimer_Queue == nil {
            ETimer.ETimer_Queue = DispatchQueue(label: "com.ETimer.thread", attributes:.concurrent)
        }
        return ETimer.ETimer_Queue!;
    }

    init(count:NSInteger, interval:TimeInterval, delegate:AnyObject) {
        self.count = count
        self.interval = interval
        self.delegate = delegate
        self.status = .Cancel
    }

   private func initTimer() {
        self.tCount = self.count
        self.queue.async {
            self.timer = Timer(timeInterval: self.interval, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
            self.runLoop = RunLoop.current
            self.runLoop?.add(self.timer!, forMode: RunLoopMode.defaultRunLoopMode)
            self.runLoop?.run();
        }
    }
    @objc private func timerAction(){
        if (self.count>0){
            self.tCount -= 1
        }else {
            self.tCount += 1
        }

        DispatchQueue.main.async {
            self.delegate.eTimerDidRefresh?(eTimer: self)
        }

        if self.tCount == 0  {
            let _ = cancel()
        }

    }
    
    func cancel() -> Bool {
        if (self.status == .Resume || self.status == .Suspend) {
            if let timer = self.timer, timer.isValid {
                timer.invalidate()
                self.timer = nil
            }
            self.status = .Cancel
            self.delegate.eTimerDidCancel?(eTimer: self)
            return true;
        }
        return false;
    }
    
    func suspend() -> Bool {
        if (self.status == .Resume) {
            self.timer?.fireDate = NSDate.distantFuture
            self.status = .Suspend;
            self.delegate.eTimerDidSuspend?(eTimer: self)
            return true;
        }
        return false;
    }
    
    func resume() -> Bool {
        if (self.status == .Cancel) {
            initTimer()
            self.status = .Resume;
            self.delegate.eTimerDidResume?(eTimer: self)
            return true;
        }
        if (self.status == .Suspend) {
            self.timer?.fireDate = NSDate() as Date
            self.status = .Resume;
            return true;
        }
        return false;
    }
}


