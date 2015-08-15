//
//  MainTabBarController.swift
//  FunnelTW
//
//  Created by 相澤渉太 on 2015/08/01.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit


class MainTabBarController: UITabBarController {
    
    var timelineView: FirstViewController!
    var funnelView: SecondViewController!
    var favoriteView: ThirdViewController!
    var listView: FourthViewController!
    var session: TWTRSession!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize local stored core data
        FunnelStore.sharedInstance.load()
        
        // init config
        SettingStore.sharedInstance.load()
        
        timelineView = FirstViewController()
        funnelView = SecondViewController()
        favoriteView = ThirdViewController()
        listView = FourthViewController()
        timelineView.tabBarItem = UITabBarItem(title: "MyTweet", image: UIImage(named: "TabBarIcon-01.png") , tag: 1)
        funnelView.tabBarItem = UITabBarItem(title: "MyFunnel", image: UIImage(named: "TabBarIcon-02.png") , tag: 2)
        favoriteView.tabBarItem = UITabBarItem(title: "MyFavorite", image: UIImage(named: "TabBarIcon-03.png") , tag: 3)
        listView.tabBarItem = UITabBarItem(title: "MyList", image: UIImage(named: "TabBarIcon-04.png") , tag: 3)
        
        var timelineNavigationController = UINavigationController(rootViewController: timelineView)
        var funnelNavigationController = UINavigationController(rootViewController: funnelView)
        var favoriteNavigationController = UINavigationController(rootViewController: favoriteView)
        var listNavigationController = UINavigationController(rootViewController: listView)
        self.setViewControllers([timelineNavigationController, funnelNavigationController,favoriteNavigationController, listNavigationController], animated: false)
        
        // Navigation Appearance
        UINavigationBar.appearance().barTintColor =  UIColor(red:113/255, green:122/255, blue:252/255, alpha:1.0)
        UITabBar.appearance().barTintColor = UIColor(red:113/255, green:122/255, blue:252/255, alpha:1.0)
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().backgroundColor = UIColor.whiteColor()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func removeFromParentViewController() {
        self.timelineView?.view?.removeFromSuperview()
        self.timelineView?.removeFromParentViewController()
        self.funnelView?.view?.removeFromSuperview()
        self.funnelView?.removeFromParentViewController()
        super.removeFromParentViewController()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
