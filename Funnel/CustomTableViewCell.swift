//
//  CustomTableViewCell.swift
//  FunnelTW
//
//  Created by 相澤渉太 on 2015/08/01.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//
import Foundation
import UIKit
import TwitterKit



@objc protocol CustomTweetTableViewCellDelegate {
    optional func delTweet(cell: CustomTableViewCell)
    optional func favoriteTweet(cell: CustomTableViewCell)
}

class CustomTableViewCell: TWTRTweetTableViewCell {
    
    weak var delegate: CustomTweetTableViewCellDelegate?
    var haveButtonsDisplayed = false
    var alert: UIAlertController?
    
    func delTweet() {
        delegate?.delTweet?(self)
    }
    
    func favoriteTweet() {
        delegate?.favoriteTweet?(self)
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        
        self.createview()
        
       
        self.contentView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: "onRightSwipe"))
        
               
        
        
        //        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: "onLeftSwipe")
        //        swipeRecognizer.direction = .Left
        //        self.contentView.addGestureRecognizer(swipeRecognizer)
    }
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    func createview(){
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.backgroundView = UIView(frame: self.bounds)
    }
    
    //    func onLeftSwipe(){
    //        self.backgroundView?.backgroundColor = UIColor.whiteColor()
    //        UIView.animateWithDuration(0.1,animations:{
    //            let size = self.contentView.frame.size
    //            let origin = self.contentView.frame.origin
    //            self.contentView.frame = CGRect(x:origin.x - 100, y:origin.y, width:size.width, height:size.height)
    //            }) { completed in
    //                if self.contentView.frame.origin.x == -100 {
    //                    self.delegate?.readTweet?(self)
    //                    }
    //            }
    //    }
    //
    //    func moveToLeft() {
    //        let size   = self.contentView.frame.size
    //        let origin = self.contentView.frame.origin
    //        self.contentView.frame = CGRect(x: origin.x - 100, y:origin.y, width:size.width, height:size.height)
    //    }
    //
    
    
    func onRightSwipe() {
        self.backgroundColor = UIColor(red:101/255, green:208/255, blue:226/255, alpha:1.0)
        UIView.animateWithDuration(0.5, animations: {
            let size   = self.contentView.frame.size
            let origin = self.contentView.frame.origin
            self.contentView.frame = CGRect(x: origin.x + 100, y:origin.y, width:size.width, height:size.height)
            }) { completed in
                if self.contentView.frame.origin.x == 100 {
                    self.delegate?.favoriteTweet?(self)
                }
        }
    }
    
    
    func moveToRight() {
        let size   = self.contentView.frame.size
        let origin = self.contentView.frame.origin
        self.contentView.frame = CGRect(x: origin.x + 100, y:origin.y, width:size.width, height:size.height)
    }
    
    func moveToLeft() {
        let size   = self.contentView.frame.size
        let origin = self.contentView.frame.origin
        self.contentView.frame = CGRect(x: origin.x - 100, y:origin.y, width:size.width, height:size.height)
    }
    
    
   
    
//    func funnelTweet(){
//        var cell: CustomTableViewCell
//        let index: Int = cell.tag
//        var tweets: TWTRTweet
//        if SettingStore.sharedInstance.isNoAlert(){
//            self.submitFunnel()
//        } else {
//            self.alert = UIAlertController(title: NSLocalizedString("stock_confirm_funnel", comment: ""), message: nil, preferredStyle: .Alert)
//            self.alert!.addAction(UIAlertAction(title:  NSLocalizedString("common_ok", comment: ""), style: .Destructive) { action in
//                self.submitFunnel()
//                })
//            self.alert!.addAction(UIAlertAction(title: NSLocalizedString("common_cancel", comment: ""), style: .Cancel) { action in
//                cell.moveToLeft()
//                })
//            self.presentViewController(self.alert!, animated: true, completion: nil)
//        }
//    }
//    
//    func submitFunnel(){
//        var cell: CustomTableViewCell
//
//        let index: Int = cell.tag
//        var tweets: TWTRTweet
//        self.tweets.removeAtIndex(index)
//        
//        println("tag is \(cell.tag)")
//        
//        var tweet = self.tweets[index]
        // store to local storage
        //            switch cell.tag {
        //            case 1:
        //                funnelTag = 1
        //            case 2:
        //                funnelTag = 2
        //            case 3:
        //                funnelTag = 3
        //            case 4:
        //                funnelTag = 4
        //            default:
        //                funnelTag = 0
        //            break
        //        }
        
//        
//        
//        println("funnelTag3 is \(funnelTag)")
//        
//        TagStore.sharedInstance.saveData(tweet.createdAt, funnelTag: funnelTag, id: tweet.tweetID)
//        //              self.tweets.removeAtIndex(index)
//        
//        // self.tweets.removeAtIndex(index)
//        
//    }

   
    
}
