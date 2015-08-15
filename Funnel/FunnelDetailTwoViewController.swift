//
//  FunnelDetailTwoViewController.swift
//  Funnel
//
//  Created by 相澤渉太 on 2015/08/14.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit
import CoreData

class FunnelDetailTwoViewController: BaseTweetViewController, CustomTweetTableViewCellDelegate {
    
    var alert: UIAlertController?
    var onFavorite : (() -> Void)?
    var excludeTag: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prototypeCell = TWTRTweetTableViewCell(style: .Default, reuseIdentifier: "cell")
        tableView.registerClass(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        
        // load the latest tweets
        refresh()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func refresh(){
        super.refresh()
    }
    
    override func loadMore(cb: ()->(), errcb: ()->()) {
        
        
        
        var q = "from:" + Twitter.sharedInstance().session().userName
        let hashtagTwo = SettingStore.sharedInstance.getfunnelNameTwo()
        if hashtagTwo == nil || hashtagTwo == "" {
            
        } else {
            q += "+" + hashtagTwo!
        }
        
        
        if self.excludeTag != "" {
            q += "+-" + self.excludeTag
        }
        
        var params = ["q":q, "result_type": "recent"]
        if self.maxIdStr != "" {
            params["max_id"] = self.maxIdStr
        }
        
        
        TwitterAPI.search(params, tweets: {
            twttrs in
            cb()
            for tweet in twttrs {
                
                // exclude stored ids already deleted
                if FunnelStore.sharedInstance.getStoredData(tweet.tweetID) != nil {
                    continue
                }
                
                self.tweets.append(tweet)
                self.maxIdStr = tweet.tweetID
                
            }
            self.tableView.reloadData()
            
            }, error: {
                error in
                self.alert = UIAlertController(title:  error.localizedDescription , message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                self.alert!.addAction(UIAlertAction(title: NSLocalizedString("common_close" , comment: ""), style:  UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(self.alert!, animated: true, completion: nil)
                errcb()
        })
        
        
    }
    
    func delTweet(cell: CustomTableViewCell){
        
        let index: Int = cell.tag
        if SettingStore.sharedInstance.isNoAlert(){
            
            self.submitRead(index)
        }else{
            
            
            self.alert = UIAlertController(title: NSLocalizedString("Are you sure you want to delete?", comment: ""), message: nil, preferredStyle: .Alert)
            self.alert!.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .Destructive) { action in
                self.submitRead(index)
                
                })
            self.alert!.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertActionStyle.Cancel) { action in  cell.moveToLeft()
                })
            self.presentViewController(self.alert!, animated: true, completion: nil)
            
        }
    }
    
    func submitRead(index: Int) {
        if tweets.count > index {
            // Toast
            var options: NSDictionary = [
                kCRToastTextKey: "The tweet has been deleted",
                kCRToastTextAlignmentKey: NSTextAlignment.Center.rawValue,
                kCRToastNotificationTypeKey: CRToastType.NavigationBar.rawValue,
                kCRToastFontKey: UIFont.systemFontOfSize(CGFloat(16)) ,
                kCRToastTextColorKey:  UIColor.whiteColor(),
                kCRToastBackgroundColorKey: UIColor.redColor(),
                kCRToastAnimationInTypeKey: CRToastAnimationType.Gravity.rawValue,
                kCRToastAnimationOutTypeKey: CRToastAnimationType.Gravity.rawValue,
                kCRToastAnimationInDirectionKey: CRToastAnimationDirection.Top.rawValue,
                kCRToastAnimationOutDirectionKey: CRToastAnimationDirection.Bottom.rawValue
            ]
            CRToastManager.showNotificationWithOptions(options as [NSObject : AnyObject], completionBlock: {() -> Void in
            })
            
            var tweet = self.tweets[index]
            
            
            FunnelStore.sharedInstance.saveData(tweet.tweetID, createdAt: tweet.createdAt)
            
            self.tweets.removeAtIndex(index)
            self.tableView!.reloadData()
        }
    }
    
    func favoriteTweet(cell: CustomTableViewCell) {
        let index: Int = cell.tag
        if SettingStore.sharedInstance.isNoAlert() {
            self.submitFavorite(index, cell: cell)
        } else {
            // show confirmation
            self.alert = UIAlertController(title: NSLocalizedString("Are you sure you want to favorite?", comment: ""), message: nil, preferredStyle: .Alert)
            self.alert!.addAction(UIAlertAction(title:  NSLocalizedString("Ok", comment: ""), style: .Destructive) { action in
                self.submitFavorite(index, cell: cell)
                })
            self.alert!.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel) { action in
                cell.moveToLeft()
                })
            self.presentViewController(self.alert!, animated: true, completion: nil)
        }
    }
    
    
    func submitFavorite(index: Int, cell: CustomTableViewCell) {
        // call favorite API
        if tweets.count > index {
            var params = ["id": self.tweets[index].tweetID]
            TwitterAPI.favoriteTweet(params, success: {
                twttrs in
                // Toast
                
                var options: NSDictionary = [
                    kCRToastTextKey: "The tweet has been favorited",
                    kCRToastTextAlignmentKey: NSTextAlignment.Center.rawValue,
                    kCRToastNotificationTypeKey: CRToastType.NavigationBar.rawValue,
                    kCRToastFontKey: UIFont.systemFontOfSize(CGFloat(16)) ,
                    kCRToastTextColorKey:  UIColor.whiteColor(),
                    kCRToastBackgroundColorKey: UIColor(red:101/255, green:208/255, blue:226/255, alpha:1.0),
                    kCRToastAnimationInTypeKey: CRToastAnimationType.Gravity.rawValue,
                    kCRToastAnimationOutTypeKey: CRToastAnimationType.Gravity.rawValue,
                    kCRToastAnimationInDirectionKey: CRToastAnimationDirection.Top.rawValue,
                    kCRToastAnimationOutDirectionKey: CRToastAnimationDirection.Bottom.rawValue
                ]
                CRToastManager.showNotificationWithOptions(options as [NSObject : AnyObject], completionBlock: {() -> Void in
                })
                
                
                
                // remove from view
                var tweet = self.tweets[index]
                // store to local storage
                FunnelStore.sharedInstance.saveData(tweet.tweetID, createdAt: tweet.createdAt)
                self.tweets.removeAtIndex(index)
                
                self.tableView!.reloadData()
                // set reload flag to fav view
                self.onFavorite?()
                }, error: {
                    error in
                    // maybe already favorited
                    // remove from view
                    var tweet = self.tweets[index]
                    // store to local storage
                    FunnelStore.sharedInstance.saveData(tweet.tweetID, createdAt: tweet.createdAt)
                    self.tweets.removeAtIndex(index)
                    
                    self.tableView!.reloadData()
                    // set reload flag to fav view
                    self.onFavorite?()
                    // skip show an error on code 139 (http response 403) because it is already favorited
                    if error.code != 139 {
                        cell.moveToLeft()
                        self.alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .Alert)
                        self.alert!.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .Cancel, handler: nil))
                        self.presentViewController(self.alert!, animated: true, completion: nil)
                    }
            })
        }
    }
    
    
    
    
    // UITableViewDataSource
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as? CustomTableViewCell
        
        cell?.delegate = self
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as? CustomTableViewCell
        let deleteBtn = UITableViewRowAction(style: .Default, title: "Delete") {
            (action, indexPath) -> Void in
            self.delTweet(cell!)
            tableView.setEditing(false, animated: true)
        }
        
        return [deleteBtn]
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
