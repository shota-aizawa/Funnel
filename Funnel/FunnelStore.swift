//
//  FunnelStore.swift
//  FunnelTW
//
//  Created by 相澤渉太 on 2015/08/06.
//  Copyright (c) 2015年 Shota Aizawa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FunnelStore {
    
    let entityName:String = "Funnel"
    
    let expiration: Int = 30
    var readDataList = [NSManagedObject]()
    class var sharedInstance: FunnelStore {
        struct Static {
            static let instance = FunnelStore()
        }
        return Static.instance
    }
    
    
    // check if a tweet id is in stored data
    func getStoredData(id: String) -> NSManagedObject? {
        for obj: NSManagedObject in self.readDataList {
            if id == obj.valueForKey("id") as? String {
                return obj
            }
            
            
        }
        return nil
    }
    

    
    
    // load from CoreData
    func load(){
        self.readDataList = []
        // Get ManagedObjectContext from AppDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        // Set search conditions
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        var error: NSError?
        // Get result array from ManagedObjectContext
        let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: &error)
        if let results: Array = fetchResults{
            var removeList = [NSManagedObject]()
            for obj:AnyObject in results {
                
               
                let id:String? = obj.valueForKey("id") as? String
                let createdAt:NSDate? = obj.valueForKey("createdAt") as? NSDate
                
                // get current date
                let calendar = NSCalendar.currentCalendar()
                let comps = NSDateComponents()
                comps.day = -self.expiration
                // get the date of expiration for each tweet
                let expirationDate = calendar.dateByAddingComponents(comps, toDate: NSDate(), options: NSCalendarOptions.allZeros)
                if createdAt?.compare(expirationDate!) == NSComparisonResult.OrderedAscending {
                    removeList.append(obj as! NSManagedObject)
                    continue
                }
                
                self.readDataList.append(obj as! NSManagedObject)
            }
            //remove
            for obj:NSManagedObject in removeList {
                self.deleteReadData(obj, reload:false)
            }
        } else {
        //   println("Could not fetch \(error) , \(error!.userInfo)")
        }
        
    }
    
    // Add an tweet not necessary to show in CoreData
    func saveData(id: String, createdAt: NSDate) {
        // get managedObjectContext from AppDelegate
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext!
        // create new managedobject
        let entity = NSEntityDescription.entityForName(self.entityName, inManagedObjectContext: managedContext)
        let obj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        obj.setValue(id, forKey: "id")
        obj.setValue(createdAt, forKey: "createdAt")
       
        var error: NSError?
        if !managedContext.save(&error){
         //   println("Could not save \(error), \(error?.userInfo)")
        }
        // reload data
        load()
    }
    
    // Delete an tweet in CoreData
    func deleteReadData(managedObject: NSManagedObject, reload: Bool){
    
        // get managedObjectContext from AppDelegate
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.managedObjectContext!
        // delete managedObject from managed context
        managedContext.deleteObject(managedObject)
        // save value to managed context
        var error: NSError?
        if !managedContext.save(&error){
        // println("Could not update \(error), \(error!.userInfo)")
        }
        if reload {
            load()
        }
    }
    
    
}
