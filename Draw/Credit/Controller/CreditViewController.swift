//
//  CHomeViewController.swift
//  ConcenPay
//
//  Created by YLCHUN on 16/2/18.
//  Copyright © 2016年 YLCHUN. All rights reserved.
//

import UIKit

class CreditViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var pageScroll: UIPageControl!
    @IBOutlet weak var viewButBg_score: UIView!
    @IBOutlet weak var scrollDashboardBg: UIScrollView!
    @IBOutlet weak var viewDashboard_score: UIView!//信用分数
    @IBOutlet weak var viewDashboard_amount: UIView!//信用额度
    
    var dashboardView_score:DashboardView?
    var dashboardView_amount:DashamoutView?

    
    fileprivate var _scrollPageInsex:Int=1{
        didSet{
            if _scrollPageInsex==1{
                dashboardView_amount?.startAnimation()
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.viewButBg_score.alpha=0
                })
            }else{
                dashboardView_score?.startAnimation()
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.viewButBg_score.alpha=1
                })
            }
        }
    }
    
    fileprivate var scrollPageInsex:Int{
        get{
            return _scrollPageInsex
        }
        set(newValue){
            if newValue != _scrollPageInsex{
                _scrollPageInsex=newValue
                pageScroll.currentPage=_scrollPageInsex
            }
        }
    }
    
    init(){
        super.init(nibName: "CreditViewController", bundle: Bundle.main)
            self.edgesForExtendedLayout = UIRectEdge()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initV()
        scrollDashboardBg.setContentOffset(CGPoint(x: scrollDashboardBg.width, y: 0), animated: false)
        // Do any additional setup after loading the view.
    }
    func initV(){
        pageScroll.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let layer = EDraw.gradientLayer(rect: UIScreen.main.bounds, startAnchor: CGPoint(x:0,y:0), endAnchor: CGPoint(x:0,y:1), colors:UIColor(hexString: "#1BBC9E"),UIColor(hexString:"#03a5c2"))
        
        self.view.layer.insertSublayer(layer, at: 0)
        
        dashboardView_score=DashboardView(score:678,time:"2016.02.06")
        viewDashboard_amount.addSubview(dashboardView_score!)
        dashboardView_score?.x=0
        dashboardView_score?.y=0

        
        dashboardView_amount=DashamoutView(available: 20000,combination:30000)
        viewDashboard_score.addSubview(dashboardView_amount!)
        dashboardView_amount?.x=0
        dashboardView_amount?.y=0
        
        scrollDashboardBg.delegate=self
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let nOffset=abs(scrollView.contentOffset.x-scrollView.width*scrollPageInsex.cGFloat)
//        print("\(nOffset), \(scrollPageInsex)")
//        if nOffset>=50{
//        }
        scrollPageInsex=Int((scrollView.contentOffset.x+scrollView.width/2)/scrollView.width)
        self.viewButBg_score.alpha = 1-scrollView.contentOffset.x/scrollView.width

    }
    
    @IBAction func butActionBack(_ sender: AnyObject) {
//        self.navigationController?.popViewControllerAnimated(true)
        self.dismiss(animated: true) { () -> Void in
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func butInterpretationAction(_ sender: AnyObject) {
        
    }
    @IBAction func butPromoteAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func butActionBorrow(_ sender: AnyObject) {//借款按钮
//        TipsTU("去借款")
    }
    @IBAction func butActionRepayment(_ sender: AnyObject) {//还款按钮
//        TipsTU("去还款")
    }
}
