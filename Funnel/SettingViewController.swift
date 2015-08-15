//
//  SettingViewController.swift
//  FunnelTW
//
//  Created by 相澤渉太 on 2015/08/05.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

//protocol SettingViewControllerDelegate {
//    func settingFunnel(modalText: String)
//}

class SettingViewController: UIViewController, UITextFieldDelegate {
    
    
    var closeBtn: UIBarButtonItem?
    var funnelOneText: UITextField?
    var funnelTwoText: UITextField?
    var funnelThreeText: UITextField?
    var funnelFourText: UITextField?
    
    var noAlertSwitch: UISwitch?
    
//    var send: SettingViewControllerDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("setting", comment: "")
        self.view.backgroundColor = UIColor.whiteColor()
       
        // right top close button
        var closeBtn: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        closeBtn.addTarget(self, action: "onClickClose", forControlEvents: UIControlEvents.TouchUpInside)
        closeBtn.frame = CGRectMake(0, 0, 20, 20)
        closeBtn.setImage(UIImage(named: "batsu.png"), forState: UIControlState.Normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeBtn)
        
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        let rowHeight: CGFloat = 40.0
        let rowPaddingTop: CGFloat = 4.0
        let rowPaddingLeft: CGFloat = 20.0
        let inputWidth: CGFloat = 160.0
        let switchWidth: CGFloat = 60.0
       
        // funnel text input
        
        let funnelOneLabel: UILabel = UILabel(frame: CGRectMake(rowPaddingLeft, rowPaddingTop, width - inputWidth - rowPaddingLeft*2, rowHeight))
        funnelOneLabel.text = NSLocalizedString("Hashtag A", comment: "")
        
        let funnelTwoLabel: UILabel = UILabel(frame: CGRectMake(rowPaddingLeft, rowPaddingTop, width - inputWidth - rowPaddingLeft*2, rowHeight))
        funnelTwoLabel.text = NSLocalizedString("Hashtag B", comment: "")
        
        let funnelThreeLabel: UILabel = UILabel(frame: CGRectMake(rowPaddingLeft, rowPaddingTop, width - inputWidth - rowPaddingLeft*2, rowHeight))
        funnelThreeLabel.text = NSLocalizedString("Hashtag C", comment: "")
        
        let funnelFourLabel: UILabel = UILabel(frame: CGRectMake(rowPaddingLeft, rowPaddingTop, width - inputWidth - rowPaddingLeft*2, rowHeight))
        funnelFourLabel.text = NSLocalizedString("Hashtag D", comment: "")
        
        
        
        let funnelOneText = UITextField(frame: CGRectMake(width - inputWidth - rowPaddingLeft, rowPaddingTop, inputWidth, rowHeight))
        let funnelTwoText = UITextField(frame: CGRectMake(width - inputWidth - rowPaddingLeft, rowPaddingTop, inputWidth, rowHeight))
        let funnelThreeText = UITextField(frame: CGRectMake(width - inputWidth - rowPaddingLeft, rowPaddingTop, inputWidth, rowHeight))
        let funnelFourText = UITextField(frame: CGRectMake(width - inputWidth - rowPaddingLeft, rowPaddingTop, inputWidth, rowHeight))
        
        funnelOneText.tag = 1
        funnelTwoText.tag = 2
        funnelThreeText.tag = 3
        funnelFourText.tag = 4
        
        funnelOneText.text = SettingStore.sharedInstance.getfunnelNameOne()
        funnelTwoText.text = SettingStore.sharedInstance.getfunnelNameTwo()
        funnelThreeText.text = SettingStore.sharedInstance.getfunnelNameThree()
        funnelFourText.text = SettingStore.sharedInstance.getfunnelNameFour()
        
        funnelOneText.delegate = self
        funnelTwoText.delegate = self
        funnelThreeText.delegate = self
        funnelFourText.delegate = self
        
        self.funnelOneText = funnelOneText
        self.funnelTwoText = funnelTwoText
        self.funnelThreeText = funnelThreeText
        self.funnelFourText = funnelFourText
        
        funnelOneText.borderStyle = UITextBorderStyle.RoundedRect
        funnelTwoText.borderStyle = UITextBorderStyle.RoundedRect
        funnelThreeText.borderStyle = UITextBorderStyle.RoundedRect
        funnelFourText.borderStyle = UITextBorderStyle.RoundedRect
        
        funnelOneText.placeholder = NSLocalizedString("name:", comment: "")
        funnelTwoText.placeholder = NSLocalizedString("name:", comment: "")
        funnelThreeText.placeholder = NSLocalizedString("name:", comment: "")
        funnelFourText.placeholder = NSLocalizedString("name:", comment: "")
        
        let containerOne = UIView()
        containerOne.backgroundColor = UIColor(red:113/255, green:252/255, blue:235/255, alpha:1.0)
        containerOne.frame = CGRectMake(0, 100, width, rowHeight + rowPaddingTop*2)
        containerOne.addSubview(funnelOneLabel)
        containerOne.addSubview(funnelOneText)
        self.view.addSubview(containerOne)
        
        let containerTwo = UIView()
        containerTwo.backgroundColor = UIColor(red:255/255, green:250/255, blue:102/255, alpha:1.0)
        containerTwo.frame = CGRectMake(0, 100 + rowHeight*1.5, width, rowHeight + rowPaddingTop*2)
        containerTwo.addSubview(funnelTwoText)
        containerTwo.addSubview(funnelTwoLabel)
        self.view.addSubview(containerTwo)
        
        let containerThree = UIView()
        containerThree.backgroundColor = UIColor(red:250/255, green:151/255, blue:149/255, alpha:1.0)
        containerThree.frame = CGRectMake(0, 100 + rowHeight*3, width, rowHeight + rowPaddingTop*2)
        containerThree.addSubview(funnelThreeText)
        containerThree.addSubview(funnelThreeLabel)
        self.view.addSubview(containerThree)
        
        let containerFour = UIView()
        containerFour.backgroundColor = UIColor(red:172/255, green:123/255, blue:51/255, alpha:1.0)
        containerFour.frame = CGRectMake(0, 100 + rowHeight*4.5, width, rowHeight + rowPaddingTop*2)
        containerFour.addSubview(funnelFourText)
        containerFour.addSubview(funnelFourLabel)
        self.view.addSubview(containerFour)
        
        
        // switch
        
        let noAlertLabel: UILabel = UILabel(frame: CGRectMake(rowPaddingLeft, rowPaddingTop, width - switchWidth - rowPaddingLeft, rowHeight))
        noAlertLabel.text = NSLocalizedString("Eliminate Confirm Alirt", comment: "")
        let noAlertSwitch = UISwitch(frame: CGRectMake(width - switchWidth - rowPaddingLeft, rowPaddingTop + 4, switchWidth, rowHeight))
        
        //noConfirmSwitch.on = SettingStore.sharedInstance.isNoConfirm()
        
        self.noAlertSwitch = noAlertSwitch
        let containerSwitch = UIView()
        containerSwitch.backgroundColor = UIColor(red:199/255, green:229/255, blue:250/255, alpha:1.0)
        containerSwitch.frame = CGRectMake(0, 340, width, rowHeight + rowPaddingTop * 2)
        containerSwitch.addSubview(noAlertLabel)
        containerSwitch.addSubview(noAlertSwitch)
        self.view.addSubview(containerSwitch)
        
        
        
        // logout
        let logoutBtn: UIButton = UIButton(frame: CGRectMake(rowPaddingLeft, 400, width - rowPaddingLeft*2, rowHeight))
        logoutBtn.setTitle(NSLocalizedString("Twitter Logout", comment: ""), forState: UIControlState.Normal)
        logoutBtn.backgroundColor = UIColor(red:113/255, green:122/255, blue:252/255, alpha:1.0)
        logoutBtn.layer.cornerRadius = 8
        logoutBtn.addTarget(self, action: "onClickLogout", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(logoutBtn)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    func onClickLogout(){
        Twitter.sharedInstance().logOut()
        close(false)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.view?.removeFromSuperview()
        UIApplication.sharedApplication().keyWindow?.rootViewController?.removeFromParentViewController()
        // show a new login view
        UIApplication.sharedApplication().keyWindow?.rootViewController = LoginViewController()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField.tag{
        case 1:
            funnelOneText?.text = textField.text
        case 2:
            funnelTwoText?.text = textField.text
        case 3:
            funnelThreeText?.text = textField.text
        case 4:
            funnelFourText?.text = textField.text
        default:
        break
        }
        
        textField.resignFirstResponder()
        return true
        
    }
    
    
    func close(reload: Bool) {
     // save all settings
        SettingStore.sharedInstance.savefunnelNameOne(self.funnelOneText?.text)
        SettingStore.sharedInstance.savefunnelNameTwo(self.funnelTwoText?.text)
        SettingStore.sharedInstance.savefunnelNameThree(self.funnelThreeText?.text)
        SettingStore.sharedInstance.savefunnelNameFour(self.funnelFourText?.text)
        
        if let noAlert = self.noAlertSwitch {
            SettingStore.sharedInstance.saveNoAlert(noAlert.on)
        
        }
        if reload {
        // set true for reload flag for timeline view
            if let viewController = UIApplication.sharedApplication().keyWindow?.rootViewController as? MainTabBarController{
                viewController.timelineView.needReload = true
            
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func onClickClose() {
        var reload: Bool = false
    
        if self.funnelOneText?.text != SettingStore.sharedInstance.getfunnelNameOne(){
            reload = true
        }
        if self.funnelTwoText?.text != SettingStore.sharedInstance.getfunnelNameTwo(){
            reload = true
        }
        if self.funnelThreeText?.text != SettingStore.sharedInstance.getfunnelNameThree(){
            reload = true
        }
        if self.funnelFourText?.text != SettingStore.sharedInstance.getfunnelNameFour(){
            reload = true
        }
        if let noAlert = self.noAlertSwitch{
            if noAlert.on != SettingStore.sharedInstance.isNoAlert(){
                reload = true
            }
        }
        close(reload)
    }


//    func submit (sender: AnyObject) {
//        self.send.settingFunnel(self.funnelOneText!.text!)
//        self.send.settingFunnel(self.funnelTwoText!.text!)
//        self.send.settingFunnel(self.funnelThreeText!.text!)
//        self.send.settingFunnel(self.funnelFourText!.text!)
//    }
}
