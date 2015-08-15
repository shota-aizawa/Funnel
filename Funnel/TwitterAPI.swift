//
//  TwitterAPI.swift
//  FunnelTW
//
//  Created by 相澤渉太 on 2015/08/01.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//

import Foundation
import TwitterKit


class TwitterAPI {
    let  baseURL = "https://api.twitter.com"
    let version = "/1.1"
    
    init(){
        
    }
    
    
    class var sharedInstance : TwitterAPI {
        struct Static {
            static let instance : TwitterAPI = TwitterAPI()
        }
        return Static.instance
    }
    
    // get userTL
    class func getUserTL(params: [NSObject : AnyObject]!, tweets: [TWTRTweet]->(), error: (NSError) -> ()){
        let api = self.sharedInstance
        var clientError: NSError?
        let path = "/statuses/user_timeline.json"
        let endpoint = api.baseURL + api.version + path
        var params = Dictionary<String, String>()
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod(
            "GET",
            URL: endpoint,
            parameters: params,
            error: &clientError
        )
        
        Twitter.sharedInstance().APIClient.sendTwitterRequest(request, completion: {
            response, data, err in
            if err == nil {
                var jsonError: NSError?
                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError)
                if let jsonArray = json as? NSArray {
                    tweets(URLTweet.tweetsWithJSONArray(jsonArray as [AnyObject]) as! [TWTRTweet])
                }
            } else {
                error(err!)
            }
        })
    }
    
    
//    class func search(params: [NSObject : AnyObject]!, tweets: [TWTRTweet]->(), error: (NSError) -> () ){
//        let api = self.sharedInstance
//        var clientError: NSError?
//        let path = "/search/tweets.json"
//        let endpoint = api.baseURL + api.version + path
//        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod(
//            "GET",
//            URL: endpoint,
//            parameters: params,
//            error: &clientError
//        )
//    
//        
//        Twitter.sharedInstance().APIClient.sendTwitterRequest(request, completion: {
//        response, data, err in
//            if err == nil {
//                var jsonError: NSError?
//                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: &jsonError)
//                if let top = json as? NSDictionary{
//                    var list: [TWTRTweet] = []
//                    if let statues = top["statues"] as? NSArray {
//                        list = URLTweet.tweetsWithJSONArray(statues as [AnyObject]) as! [TWTRTweet]
//                    }
//                    tweets(list)
//                } else if let jsonArray = json as? NSArray {
//                    tweets(URLTweet.tweetsWithJSONArray(jsonArray as [AnyObject]) as! [TWTRTweet])
//                }
//            } else {
//                error(err!)
//            }
//        })
//    
//    }
   
    class func search(params: [NSObject : AnyObject]!, tweets: [TWTRTweet]->(), error: (NSError) -> ()) {
        self.callAPI("/search/tweets.json", parameters: params, completion: {
            response, data, err in
            //            println(NSString(data: data, encoding: NSUTF8StringEncoding))
            if err == nil {
                var jsonError: NSError?
                let json: AnyObject? =  NSJSONSerialization.JSONObjectWithData(data!,
                    options: nil,
                    error: &jsonError)
                if let top = json as? NSDictionary {
                    var list: [TWTRTweet] = []
                    if let statuses = top["statuses"] as? NSArray {
                        list = URLTweet.tweetsWithJSONArray(statuses as [AnyObject]) as! [TWTRTweet]
                    }
                    tweets(list)
                }else if let jsonArray = json as? NSArray {
                    tweets(URLTweet.tweetsWithJSONArray(jsonArray as [AnyObject]) as! [TWTRTweet])
                }
            } else {
                error(err!)
            }
        })
    }

    
    class func listMyFavorites(params: [NSObject : AnyObject]!, tweets: [TWTRTweet]->(), error: (NSError) -> ()) {
        self.callAPI("/favorites/list.json", parameters: params, completion: {
            response, data, err in
            if err == nil {
                var jsonError: NSError?
                let json: AnyObject? =  NSJSONSerialization.JSONObjectWithData(data!,
                    options: nil,
                    error: &jsonError)
                if let jsonArray = json as? NSArray {
                    tweets(URLTweet.tweetsWithJSONArray(jsonArray as [AnyObject]) as! [TWTRTweet])
                }
            } else {
                error(err!)
            }
        })
    }

    
    class func favoriteTweet(params: [NSObject : AnyObject]!, success: ()->(), error: (NSError) -> ()) {
        self.callPostAPI("/favorites/create.json", parameters: params, completion: {
            response, data, err in
            if err == nil {
                success()
            } else {
                error(err!)
            }
        })
    }

    class func unfavoriteTweet(params: [NSObject : AnyObject]!, success: ()->(), error: (NSError) -> ()) {
        self.callPostAPI("/favorites/destroy.json", parameters: params, completion: {
            response, data, err in
            if err == nil {
                success()
            } else {
                error(err!)
            }
        })
    }
    
    
    
    class func callAPI(path: String, parameters: [NSObject : AnyObject]!, completion: TWTRNetworkCompletion!){
        self._callAPI(path, method: "GET", parameters: parameters, completion: completion)
    }
    
    class func callPostAPI(path: String, parameters: [NSObject : AnyObject]!, completion: TWTRNetworkCompletion!){
        self._callAPI(path, method: "POST", parameters: parameters, completion: completion)
    }

    
    
    class func _callAPI(path: String, method: String, parameters: [NSObject : AnyObject]!, completion: TWTRNetworkCompletion!){
        let api = TwitterAPI()
        var clientError: NSError?
        let endpoint = api.baseURL + api.version + path
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod(method, URL: endpoint, parameters: parameters, error: &clientError)
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request, completion: completion)
        
    }
    
    
    
}

