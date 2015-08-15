//
//  CustomWebViewController.swift
//  Funnel
//
//  Created by 相澤渉太 on 2015/08/13.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//
import Foundation
import UIKit

class CustomWebViewController : UIViewController, UIWebViewDelegate, UIActionSheetDelegate {
    
    var webView: UIWebView = UIWebView()
    var toolBar: UIToolbar = UIToolbar()
    var backButton: UIBarButtonItem!
    var forwardButton: UIBarButtonItem!
    var refreshButton: UIBarButtonItem!
    var safariButton: UIBarButtonItem!
    var url : NSURL?
    let toolBarHeight: CGFloat = 50.0
    
    var loadBarImage = MBProgressHUD()
   
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let selfFrame: CGRect = self.view.frame
        self.webView.frame = CGRect(x: 0, y: 0, width: selfFrame.size.width, height: selfFrame.size.height-toolBarHeight)
        self.webView.delegate = self
        self.view.addSubview(self.webView)
        self.toolBar.frame = CGRect(x: 0, y: selfFrame.size.height - toolBarHeight, width: selfFrame.size.width, height: toolBarHeight)
        self.toolBar.backgroundColor = UIColor(red:113/255, green:122/255, blue:252/255, alpha:1.0)
        self.toolBar.tintColor = UIColor(red:113/255, green:122/255, blue:252/255, alpha:1.0)
        self.view.addSubview(self.toolBar)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        let spacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        self.backButton = UIBarButtonItem(image: UIImage(named: "toolbar_back"), style: .Plain, target: self, action: Selector("back"))
        self.forwardButton = UIBarButtonItem(image: UIImage(named: "toolbar_forward"), style: .Plain, target: self, action: Selector("forward"))
        self.refreshButton = UIBarButtonItem(image: UIImage(named: "toolbar_reload"), style: .Plain, target: self, action: Selector("reload"))
        self.safariButton = UIBarButtonItem(image: UIImage(named: "toolbar_external"), style: .Plain, target: self, action: Selector("safari"))
        let items: NSArray = [spacer, self.backButton, spacer, self.forwardButton, spacer, self.refreshButton, spacer, self.safariButton, spacer]
        self.toolBar.items = items as [AnyObject]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton.enabled = self.webView.canGoBack
        self.forwardButton.enabled = self.webView.canGoForward
        self.refreshButton.enabled = false
        self.safariButton.enabled = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Toast
        loadBarImage = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadBarImage.labelText = "Loading"
        loadBarImage.dimBackground = true
        loadBarImage.mode = MBProgressHUDMode.Indeterminate
        let requestURL: NSURLRequest = NSURLRequest(URL: self.url!)
        self.webView.loadRequest(requestURL)
        
    }
    
    func back() {
        self.webView.goBack()
        self.backButton.enabled = self.webView.canGoBack
        self.forwardButton.enabled = self.webView.canGoForward
    }
    
    func forward() {
        self.webView.goForward()
        self.backButton.enabled = self.webView.canGoBack
        self.forwardButton.enabled = self.webView.canGoForward
    }
    
    func reload() {
        // Toast
        loadBarImage = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadBarImage.labelText = "Loading"
        loadBarImage.dimBackground = true
        loadBarImage.mode = MBProgressHUDMode.Indeterminate
        self.webView.reload()
    }
    
    func safari() {
        if self.osVersion() >= 8.0 {
            self.alertController()
        } else {
            self.actionSheet()
        }
    }
    
    func alertController() {
        let actionSheet: UIAlertController = UIAlertController(title: "", message: NSLocalizedString("webview_toolbar_open_in", comment: ""), preferredStyle: .ActionSheet)
        let otherAction1: UIAlertAction = UIAlertAction(title: NSLocalizedString("webview_toolbar_safari", comment: ""), style: UIAlertActionStyle.Default, handler: { action1 in
            if let req = self.webView.request {
                let url: NSURL = req.URL!
                UIApplication.sharedApplication().openURL(url)
            }
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("common_cancel", comment: ""), style: UIAlertActionStyle.Cancel, handler: { cancel in })
        actionSheet.addAction(otherAction1)
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func actionSheet() {
        let actionSheet: UIActionSheet = UIActionSheet()
        actionSheet.title = NSLocalizedString("webview_toolbar_open_in", comment: "")
        actionSheet.delegate = self
        actionSheet.addButtonWithTitle(NSLocalizedString("webview_toolbar_safari", comment: ""))
        actionSheet.addButtonWithTitle(NSLocalizedString("common_cancel", comment: ""))
        actionSheet.cancelButtonIndex = 1
        actionSheet.showFromToolbar(self.toolBar)
    }
    
    func actionSheet(myActionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch (buttonIndex) {
        case 0:
            if let req = self.webView.request {
                let url: NSURL = req.URL!
                UIApplication.sharedApplication().openURL(url)
            }
            break
        default:
            break
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.backButton.enabled = self.webView.canGoBack
        self.forwardButton.enabled = self.webView.canGoForward
        self.refreshButton.enabled = true
        self.safariButton.enabled = true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // Toast
        loadBarImage.hide(true)
        self.backButton.enabled = self.webView.canGoBack
        self.forwardButton.enabled = self.webView.canGoForward
    }
    
    func osVersion() -> Double {
        return NSString(string: UIDevice.currentDevice().systemVersion).doubleValue
    }
}