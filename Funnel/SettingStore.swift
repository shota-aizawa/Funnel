//
//  SettingStore.swift
//  Funnel
//
//  Created by 相澤渉太 on 2015/08/08.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SettingStore {

    let entityName:String = "Setting"
    
    let KEY_FUNNEL_NAME_One: String = "funnelNameOne"
    let KEY_FUNNEL_NAME_Two: String = "funnelNameTwo"
    let KEY_FUNNEL_NAME_Three: String = "funnelNameThree"
    let KEY_FUNNEL_NAME_Four: String = "funnelNameFour"
    let KEY_NO_ALERT: String = "noAlert"
    
    var config: NSManagedObject?
    
    class var sharedInstance: SettingStore {
        struct Static {
            static let instance = SettingStore()
        }
        return Static.instance
    }

    func load() {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    let fetchRequest = NSFetchRequest(entityName: self.entityName)
    var error: NSError?
    // Get result array from ManagedObjectContext
    let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: &error)
        if let results: Array = fetchResults {
            if results.count > 0 {
                self.config = results[0] as? NSManagedObject
            }
        } else {
//            println("Could not fetch \(error) , \(error!.userInfo)")
        }
        
    }
    
    func saveSettingData(key: String, value: AnyObject?){
    // Get ManagedObjectContext from AppDelegate
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext!
        if self.config == nil {
            let entity = NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: managedContext)
            self.config = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        }
        self.config?.setValue(value, forKey: key)
        
        var error: NSError?
        if !managedContext.save(&error){
    //     println("Could not save \(error), \(error?.userInfo)")
        }
        
    }
    
    func getfunnelNameOne() -> String? {
        return self.config?.valueForKey(self.KEY_FUNNEL_NAME_One) as! String?
    }
    
    func getfunnelNameTwo() -> String? {
        return self.config?.valueForKey(self.KEY_FUNNEL_NAME_Two) as! String?
    }
    
    func getfunnelNameThree() -> String? {
        return self.config?.valueForKey(self.KEY_FUNNEL_NAME_Three) as! String?
    }
    
    func getfunnelNameFour() -> String? {
        return self.config?.valueForKey(self.KEY_FUNNEL_NAME_Four) as! String?
    }

    
    func savefunnelNameOne(funnelNameOne: String?){
        self.saveSettingData(self.KEY_FUNNEL_NAME_One, value: funnelNameOne)
    }
    
    func savefunnelNameTwo(funnelNameTwo: String?){
        self.saveSettingData(self.KEY_FUNNEL_NAME_Two, value: funnelNameTwo)
    }
    
    func savefunnelNameThree(funnelNameThree: String?){
        self.saveSettingData(self.KEY_FUNNEL_NAME_Three, value: funnelNameThree)
    }
    
    func savefunnelNameFour(funnelNameFour: String?){
        self.saveSettingData(self.KEY_FUNNEL_NAME_Four, value: funnelNameFour)
    }
    
    
    func isNoAlert() -> Bool {
        if let r = self.config?.valueForKey(self.KEY_NO_ALERT) as! Bool? {
        return r
        }
        return false
    }
    
    func saveNoAlert(noAlert: Bool) {
        self.saveSettingData(self.KEY_NO_ALERT, value: noAlert)
    }
}


