//
//  FirstViewController.swift
//  FunnelTW
//
//  Created by 相澤渉太 on 2015/08/01.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//
import Foundation
import UIKit
import TwitterKit
import CoreData



class FirstViewController: BaseTweetViewController , CustomTweetTableViewCellDelegate {
    
    var alert: UIAlertController?
    var onFavorite : (() -> Void)?
    var excludeTag: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "MyTimeLine"
        
        
        prototypeCell = TWTRTweetTableViewCell(style: .Default, reuseIdentifier: "cell")
        tableView.registerClass(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        // nav right item button
        var settingBtn:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        settingBtn.addTarget(self, action: "onClickSetting", forControlEvents: UIControlEvents.TouchUpInside)
        settingBtn.frame = CGRectMake(0, 0, 30, 30)
        settingBtn.setImage(UIImage(named: "FunnelSetting.png"), forState: .Normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingBtn)

        
        
        // load the latest tweets
        refresh()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func refresh(){
        super.refresh()
    }
    
    override func loadMore(cb: ()->(), errcb: ()->()) {
        
        var params = ["result_type": "recent", "count":"35"]

        TwitterAPI.getUserTL(params, tweets:{
            twttrs in
            cb()
            for tweet in twttrs {
                
                if FunnelStore.sharedInstance.getStoredData(tweet.tweetID) != nil {
                    continue
                }

                // exclude favorited
                if tweet.isFavorited == true {
                    continue
                }
                
                self.tweets.append(tweet)
            }
                self.tableView.reloadData()
            
            }, error: {
                error in
                self.alert = UIAlertController(title:  error.localizedDescription , message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                self.alert!.addAction(UIAlertAction(title: NSLocalizedString("Close" , comment: ""), style:  UIAlertActionStyle.Cancel, handler: nil))
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
    
    
    
    
    // UITableViewDelegate
   
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath) as? CustomTableViewCell
        let deleteBtn = UITableViewRowAction(style: .Default, title: "Delete") {
                       (action, indexPath) -> Void in
            self.delTweet(cell!)
            tableView.setEditing(false, animated: true)
        }
        
        return [deleteBtn]
//
//        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as? CustomTableViewCell
//        let funnelOne = UITableViewRowAction(style: .Default, title: "funnel", handler:
//            {
//                (action:UITableViewRowAction!, indexPath: NSIndexPath!) in
//                
//                 cell!.tag = 1
//                 funnelTag = 1
////                 self.funnelTweet(cell!)
////                
////                cell?.funnelTweet()
////                
//                self.tableView!.reloadData()
//                self.tweets.removeAtIndex(indexPath.row)
//                tableView.setEditing(false, animated: true)
//                
//        })
//
//        let funnelTwo = UITableViewRowAction(style: .Default, title: "funnel") {
//            (action, indexPath) -> Void in
//            
//            tableView.setEditing(false, animated: true)
//            cell!.tag = 2
//            
////            self.funnelTweet(cell!)
//            println("tag is \(cell!.tag)")
//            
//            self.tweets.removeAtIndex(indexPath.row)
//           // tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
//        }
//        
//        let funnelThree = UITableViewRowAction(style: .Default, title: "funnel") {
//            (action, indexPath) in
//            
//            tableView.setEditing(false, animated: true)
//            cell!.tag = 3
//            println("tag is \(cell!.tag)")
////            self.funnelTweet(cell!)
////            
//            
//            self.tweets.removeAtIndex(indexPath.row)
//          //  tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
//        }
//        
//        let funnelFour = UITableViewRowAction(style: .Default, title: "funnel") {
//            (action, indexPath) in
//            
//            tableView.setEditing(false, animated: true)
//            cell!.tag = 4
//           println("tag is \(cell!.tag)") 
////            self.funnelTweet(cell!)
////            
//            self.tweets.removeAtIndex(indexPath.row)
//          //  tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
//        }
//        
//        
//    
//        funnelOne.backgroundColor = UIColor(red:113/255, green:252/255, blue:235/255, alpha:1.0)
//        funnelTwo.backgroundColor = UIColor(red:255/255, green:250/255, blue:102/255, alpha:1.0)
//        funnelThree.backgroundColor = UIColor(red:250/255, green:151/255, blue:149/255, alpha:1.0)
//        funnelFour.backgroundColor = UIColor(red:172/255, green:123/255, blue:51/255, alpha:1.0)
//        
//        
//        
//        
//        return [funnelOne, funnelTwo, funnelThree, funnelFour]
//        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
//    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
//        let tmp = tweets[sourceIndexPath.row]
//        tweets.removeAtIndex(sourceIndexPath.row)
//        tweets.insert(tmp, atIndex: destinationIndexPath.row)
//    }
    
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Dispose of any resources that can be recreated.
    //    }
    
}


