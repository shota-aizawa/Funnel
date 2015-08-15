//
//  ThirdViewController.swift
//  Funnel
//
//  Created by 相澤渉太 on 2015/08/14.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit
import CoreData




class ThirdViewController: BaseTweetViewController , FavoriteTableViewCellDelegate {

    var alert : UIAlertController?
    var onUnFavorite : (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSLocalizedString("My Favorite", comment: "")
        
        prototypeCell = TWTRTweetTableViewCell(style: .Default, reuseIdentifier: "cell")
        
        tableView.registerClass(FavoriteTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        refresh()
    }
    
    override func loadMore(cb: ()->(), errcb: () -> ()) {
        var params = ["count": "35"]
        
        TwitterAPI.listMyFavorites(params, tweets: {
            twttrs in
            cb()
            for tweet in twttrs {
                // adjust max_id position because requested max_id is included in a result on favorite API
                if tweet.tweetID == self.maxIdStr {
                    continue
                }
                self.tweets.append(tweet)
                self.maxIdStr = tweet.tweetID
            }
            
            
            self.tableView.reloadData()
            }, error: {
                error in
                self.alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .Alert)
                self.alert!.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .Cancel, handler: nil))
                self.presentViewController(self.alert!, animated: true, completion: nil)
                errcb()
        })
    }
    
    func unfavoriteTweet(cell: FavoriteTableViewCell) {
        let index: Int = cell.tag
        if SettingStore.sharedInstance.isNoAlert() {
            self.submitUnfavorite(index, cell: cell)
        } else {
            // show confirmation
            self.alert = UIAlertController(title: NSLocalizedString("Are you sure you want to unfavorite?", comment: ""), message: nil, preferredStyle: .Alert)
            self.alert!.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .Destructive) { action in
                self.submitUnfavorite(index, cell: cell)
                })
            self.alert!.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .Cancel) { action in
                cell.moveToRight()
                })
            self.presentViewController(self.alert!, animated: true, completion: nil)
        }
    }
    
    func submitUnfavorite(index: Int, cell: FavoriteTableViewCell) {
        // call favorite API
        if tweets.count > index {
            var params = ["id": self.tweets[index].tweetID]
            TwitterAPI.unfavoriteTweet(params, success: {
                twttrs in
                
                // Toast
                var options: NSDictionary = [
                    kCRToastTextKey: "The tweet has been unfavorited",
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
                // remove registered id from local storage
                if let obj = FunnelStore.sharedInstance.getStoredData(tweet.tweetID) {
                    FunnelStore.sharedInstance.deleteReadData(obj, reload: true)
                }
                self.tweets.removeAtIndex(index)
                self.tableView!.reloadData()
                // set reload flag to read view
                self.onUnFavorite?()
                }, error: {
                    error in
                    cell.moveToRight()
                    self.alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .Alert)
                    self.alert!.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .Cancel, handler: nil))
                    self.presentViewController(self.alert!, animated: true, completion: nil)
            })
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as! FavoriteTableViewCell
        cell.delegate = self
        return cell
    }
    
}


