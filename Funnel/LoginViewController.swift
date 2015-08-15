//
//  LoginViewController.swift
//  FunnelTW
//
//  Created by 相澤渉太 on 2015/08/01.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

class LoginViewController: UIViewController, UIScrollViewDelegate {
    
    var alert: UIAlertController?
    var pageControl: UIPageControl!
    var scrollView: UIScrollView!
    
    let pageSize = 6
    let titleH: CGFloat = 70.0
    let controlH: CGFloat = 20.0
    let twBtnH: CGFloat = 80.0
    let imageW: CGFloat = 475
    let imageH: CGFloat = 327
    let paddingTop: CGFloat = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var smallScreenAdjustment: CGFloat = 0.0
        let size = self.view.bounds.size
        if size.height <= 480 {
            smallScreenAdjustment = 48.0
        }
        
        
        
        
        let width = self.view.frame.maxX
        let height = self.view.frame.maxY
        self.view.backgroundColor = UIColor(red:113/255, green:122/255, blue:252/255, alpha:1.0)
        scrollView = UIScrollView(frame: self.view.frame)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pagingEnabled = true
//        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(CGFloat(self.pageSize) * width, 0)
        self.view.addSubview(scrollView)
        for var i = 0; i < self.pageSize; i++ {
            let x = CGFloat(i) * width
            let margin = height - imageH - twBtnH - paddingTop * 2 - controlH + smallScreenAdjustment
            let introTitle:UILabel = UILabel(frame: CGRectMake(x + 10, paddingTop * 2 + controlH + (margin - titleH) / 2, width - 20, titleH))
            introTitle.textColor = UIColor.whiteColor()
            introTitle.textAlignment = NSTextAlignment.Center
            introTitle.text = NSLocalizedString("tutorial_title_" + String(i + 1), comment: "")
            introTitle.numberOfLines = 0
            introTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
            scrollView.addSubview(introTitle)
        
            // show image later
            
            
            
            
            
            pageControl = UIPageControl(frame: CGRectMake(0, paddingTop * 2, width, controlH))
            pageControl.numberOfPages = self.pageSize
            pageControl.currentPage = 0
            pageControl.userInteractionEnabled = false
            self.view.addSubview(pageControl)
            
            
            
            
            let logInButton = TWTRLogInButton { (session, error) in
                // play with Twitter session
                
                if session != nil {
                    println(session.userName)
                    UIApplication.sharedApplication().keyWindow?.rootViewController = MainTabBarController()
                } else{
                    println(error.localizedDescription)
                }
            }
            logInButton.center = self.view.center
            logInButton.frame = CGRectMake(0, self.view.frame.maxY - twBtnH, width, twBtnH)
            self.view.addSubview(logInButton)

            
            
            
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }
    }
    
}



