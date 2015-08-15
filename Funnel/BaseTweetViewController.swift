//
//  BaseTweetViewController.swift
//  Funnel
//
//  Created by 相澤渉太 on 2015/08/10.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

class BaseTweetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TWTRTweetViewDelegate {

    var tableView: UITableView!
    var tweets: [TWTRTweet] = []
    var prototypeCell: TWTRTweetTableViewCell?
    var refreshControl:UIRefreshControl!
    var maxIdStr:String = ""
    var needReload:Bool = false


    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "refresh")
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        
        prototypeCell = TWTRTweetTableViewCell(style: .Default, reuseIdentifier: "cell")
        tableView.registerClass(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        
        
    
    }
    
    
    func refresh(){
        self.tweets = []
        self.maxIdStr = ""
        
        let loadImage = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadImage.labelText = "Loading"
        loadImage.detailsLabelText = "please wait"
        
        loadMore({()->() in
            
            loadImage.hide(true)
            
            self.refreshControl.endRefreshing()
            },errcb: {()->() in
                loadImage.hide(true)
                self.refreshControl.endRefreshing()
        })
        
    }

    
    // for override
    func loadMore(cb: ()->(), errcb: () -> ()) {
    }
    
    func onClickSetting() {
        let settingViewCtrl = SettingViewController()
        let modalView = UINavigationController(rootViewController: settingViewCtrl)
        modalView.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(modalView, animated: true, completion: nil)
    }

    
    override func viewDidAppear(animated: Bool) {
        if needReload == true {
            refresh()
            needReload = false
        }
    }
    
    // UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? TWTRTweetTableViewCell
        
        if tweets.count > indexPath.row{
            cell?.tweetView.delegate = self
            let tweet = tweets[indexPath.row]
            cell!.tag = indexPath.row
            cell!.configureWithTweet(tweet)
            // load more data by showing a last table cell
//            if (tweets.count-1) == indexPath.row && self.maxIdStr != "" {
//                
//                
//                let loadImage = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                loadImage.labelText = "Loading"
//                loadImage.detailsLabelText = "please wait"
//                loadImage.dimBackground = true
//                
//                self.loadMore({() -> () in
//                    loadImage.hide(true)
//                    }, errcb: {() -> () in
//                        loadImage.hide(true)
//                })
//            }
        }
        
        return cell!
    }

    
    
    // UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = tweets[indexPath.row]
        if tweets.count > indexPath.row {
            
            prototypeCell?.configureWithTweet(tweet)
        }
        return TWTRTweetTableViewCell.heightForTweet(tweet, width: self.view.bounds.width)
        
    
    }
    
    func tweetView(tweetView: TWTRTweetView!, didSelectTweet tweet: TWTRTweet!) {
        // tap a cell
        var url:String = ""
        if let urlTweet = tweet as? URLTweet {
            url = urlTweet.url
        }
        if url == "" {
            return
        }
        self.openWebView(NSURL(string: url)!)
    }
        // tap a link in cell
    func tweetView(tweetView: TWTRTweetView!, didTapURL url: NSURL!) {
        self.openWebView(url)
    }
    
    func openWebView(url: NSURL){
        let webviewController = CustomWebViewController()
        webviewController.url = url
        webviewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(webviewController, animated: true)
    }


}