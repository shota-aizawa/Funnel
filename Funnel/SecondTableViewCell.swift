////
////  SecondTableViewCell.swift
////  Funnel
////
////  Created by 相澤渉太 on 2015/08/14.
////  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
////
//
//import Foundation
//import UIKit
//import TwitterKit
//
//
//
//@objc protocol SecondTweetTableViewCellDelegate {
//    optional func delTweet(cell: SecondTableViewCell)
//    optional func favoriteTweet(cell: SecondTableViewCell)
//}
//
//class SecondTableViewCell: TWTRTweetTableViewCell {
//    
//    weak var delegate: SecondTweetTableViewCellDelegate?
//    var haveButtonsDisplayed = false
//    var alert: UIAlertController?
//    
//    func delTweet() {
//        delegate?.delTweet?(self)
//    }
//    
//    func favoriteTweet() {
//        delegate?.favoriteTweet?(self)
//    }
//    
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String!){
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.selectionStyle = .None
//        
//        self.createview()
//        
//        
//        self.contentView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: "onRightSwipe"))
//        
//    }
//    
//    required init(coder aDecoder: NSCoder){
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func createview(){
//        self.contentView.backgroundColor = UIColor.whiteColor()
//        self.backgroundView = UIView(frame: self.bounds)
//    }
//    
//    
//    func onRightSwipe() {
//        self.backgroundColor = UIColor(red:101/255, green:208/255, blue:226/255, alpha:1.0)
//        UIView.animateWithDuration(0.5, animations: {
//            let size   = self.contentView.frame.size
//            let origin = self.contentView.frame.origin
//            self.contentView.frame = CGRect(x: origin.x + 100, y:origin.y, width:size.width, height:size.height)
//            }) { completed in
//                if self.contentView.frame.origin.x == 100 {
//                    self.delegate?.favoriteTweet?(self)
//                }
//        }
//    }
//    
//    
//    func moveToRight() {
//        let size   = self.contentView.frame.size
//        let origin = self.contentView.frame.origin
//        self.contentView.frame = CGRect(x: origin.x + 100, y:origin.y, width:size.width, height:size.height)
//    }
//    
//    func moveToLeft() {
//        let size   = self.contentView.frame.size
//        let origin = self.contentView.frame.origin
//        self.contentView.frame = CGRect(x: origin.x - 100, y:origin.y, width:size.width, height:size.height)
//    }
//    
//    
//    
//}
//
