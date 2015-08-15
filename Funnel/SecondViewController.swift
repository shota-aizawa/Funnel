//
//  SecondViewController.swift
//  FunnelTW
//
//  Created by 相澤渉太 on 2015/08/01.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//

import UIKit
import TwitterKit


//@objc protocol senderDelegate{
//    func receiveMessage(message:NSString)
//    
//}

var funnelTag:Int = 0

class SecondViewController: UIViewController {
    
//    weak var delegate: senderDelegate?
//    var message = funnelTag.description
//    
    
//    func sendMessage(sender: AnyObject){
//        delegate?.receiveMessage(message)
//    }
    
    let circleLUColor = UIColor(red:113/255, green:252/255, blue:235/255, alpha:1.0)
    let circleRUColor = UIColor(red:255/255, green:250/255, blue:102/255, alpha:1.0)
    let circleLDColor = UIColor(red:250/255, green:151/255, blue:149/255, alpha:1.0)
    let circleRDColor = UIColor(red:172/255, green:123/255, blue:51/255, alpha:1.0)
    
    var needReload: Bool = false
    
    
    func onClick(sender: UIButton){
        
        let funnelDetailViewController = FunnelDetailViewController()
        let funnelDetailTwoViewController = FunnelDetailTwoViewController()
        let funnelDetailThreeViewController = FunnelDetailThreeViewController()
        let funnelDetailFourViewController = FunnelDetailFourViewController()
        
        switch sender.tag {
        case 1:
            self.navigationController?.pushViewController(funnelDetailViewController, animated: false)
        case 2:
            self.navigationController?.pushViewController(funnelDetailTwoViewController, animated: false)
        case 3:
            self.navigationController?.pushViewController(funnelDetailThreeViewController, animated: false)
        case 4:
            self.navigationController?.pushViewController(funnelDetailFourViewController, animated: false)
        default:
            self.navigationController?.pushViewController(funnelDetailViewController, animated: false)
            break
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.navigationItem.title = "MyFunnel"
        
        let screenWidth = self.view.bounds.width
        let screenHeight = self.view.bounds.height
        let BGColor = UIColor(red:255, green:255, blue:255, alpha:1.0)
        
        
        var funnelDraw = FunnelView(frame: CGRectMake(20, 20, screenWidth-40, screenHeight-40))
        funnelDraw.backgroundColor = BGColor
        self.view.addSubview(funnelDraw)
        
        let circleLUBtn = UIButton(frame: CGRectMake(40, 100, 100, 100))
        let circleRUBtn = UIButton(frame: CGRectMake(180, 100, 100, 100))
        let circleLDBtn = UIButton(frame: CGRectMake(40, 250, 100, 100))
        let circleRDBtn = UIButton(frame: CGRectMake(180, 250, 100, 100))
        
        circleLUBtn.tag = 1
        circleRUBtn.tag = 2
        circleLDBtn.tag = 3
        circleRDBtn.tag = 4
        
        circleLUBtn.setTitle("", forState: UIControlState.Normal)
        circleRUBtn.setTitle("", forState: UIControlState.Normal)
        circleLDBtn.setTitle("", forState: UIControlState.Normal)
        circleRDBtn.setTitle("", forState: UIControlState.Normal)
        
        circleLUBtn.backgroundColor = circleLUColor
        circleRUBtn.backgroundColor = circleRUColor
        circleLDBtn.backgroundColor = circleLDColor
        circleRDBtn.backgroundColor = circleRDColor
        
        circleLUBtn.layer.cornerRadius = 50
        circleRUBtn.layer.cornerRadius = 50
        circleLDBtn.layer.cornerRadius = 50
        circleRDBtn.layer.cornerRadius = 50
        
        
        circleLUBtn.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
        circleRUBtn.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
        circleLDBtn.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
        circleRDBtn.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        self.view.addSubview(circleLUBtn)
        self.view.addSubview(circleRUBtn)
        self.view.addSubview(circleLDBtn)
        self.view.addSubview(circleRDBtn)
        
        // Funnel Name Lable
        let nameLableOne: UILabel = UILabel(frame: CGRectMake(40, 200, 100, 20))
        //nameLableOne.textColor = UIColor.blackColor()
        nameLableOne.textColor = circleLUColor
        nameLableOne.textAlignment = NSTextAlignment.Center
        //nameLableOne.text = "3"
        
        nameLableOne.text = SettingStore.sharedInstance.getfunnelNameOne()
        self.view.addSubview(nameLableOne)
        
        
        let nameLableTwo: UILabel = UILabel(frame: CGRectMake(180, 200, 100, 20))
        //nameLableTwo.textColor = UIColor.blackColor()
        nameLableTwo.textColor = circleRUColor
        nameLableTwo.textAlignment = NSTextAlignment.Center
        nameLableTwo.text = SettingStore.sharedInstance.getfunnelNameTwo()
        self.view.addSubview(nameLableTwo)
        
        
        let nameLableThree: UILabel = UILabel(frame: CGRectMake(40, 350, 100, 20))
        //nameLableThree.textColor = UIColor.blackColor()
        nameLableThree.textColor = circleLDColor
        nameLableThree.textAlignment = NSTextAlignment.Center
        nameLableThree.text = SettingStore.sharedInstance.getfunnelNameThree()
        self.view.addSubview(nameLableThree)
        
        let nameLableFour: UILabel = UILabel(frame: CGRectMake(180, 350, 100, 20))
        //nameLableFour.textColor = UIColor.blackColor()
        nameLableFour.textColor = circleRDColor
        nameLableFour.textAlignment = NSTextAlignment.Center
        nameLableFour.text = SettingStore.sharedInstance.getfunnelNameFour()
        self.view.addSubview(nameLableFour)
        
        
        
        
        // nav right item button
        var settingBtn:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        settingBtn.addTarget(self, action: "onClickSetting", forControlEvents: UIControlEvents.TouchUpInside)
        settingBtn.frame = CGRectMake(0, 0, 30, 30)
        settingBtn.setImage(UIImage(named: "FunnelSetting.png"), forState: .Normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingBtn)
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func onClickSetting() {
        let settingViewCtrl = SettingViewController()
        let modalView = UINavigationController(rootViewController: settingViewCtrl)
        modalView.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(modalView, animated: true, completion: nil)
    }
    

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
