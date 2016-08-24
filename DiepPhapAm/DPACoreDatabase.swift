//
//  DPACoreDatabase.swift
//  DiepPhapAm
//
//  Created by Mac on 8/23/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation
import CoreData
public enum  DPACoreDatabaseAddResourceFavoriteFailCase: Int {
    
    
    case AlreadyExist
    case Unknown // iPhone and iPod touch style UI
    
}

class DPACoreDatabase: NSObject {
    static let shareInstance = DPACoreDatabase()
      let managedContext =    AppDelegate.sharedInstance.managedObjectContext
    func saveFavoriteItemToDatabase(Resource:DPAResource,completion:(Error:Bool,FailType :DPACoreDatabaseAddResourceFavoriteFailCase)->Void)
    {
        //2
       if self.checkIfResourceExistInDatabase(Resource) ==  true
       {
        completion(Error: true, FailType: DPACoreDatabaseAddResourceFavoriteFailCase.AlreadyExist)
        
        return
        
        }
        
        let entity =  NSEntityDescription.entityForName("FavoriteResouce",
            inManagedObjectContext:managedContext)
        
        let FavoriteResouce = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        //3
        FavoriteResouce.setValue(Resource.resourceID, forKey: "resourceID")
        
        //4
        do {
            try managedContext.save()
            //5
           // people.append(person)
        } catch let error as NSError  {
            
                  completion(Error: true, FailType: DPACoreDatabaseAddResourceFavoriteFailCase.Unknown)
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
    }
    func removeFavoriteItemToDatabase(Resource:DPAResource,completion:(Error:Bool)->Void)
    {
        
        
        
        
        
        let request =  NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("FavoriteResouce",
            inManagedObjectContext:managedContext)
        let predicate =  NSPredicate(format: "resourceID == %d", Resource.resourceID)
        
        
        request.predicate = predicate
        print(Resource.resourceID)
        
        
        
        do {
            let result = try self.managedContext.executeFetchRequest(request) as! NSArray
            
            if result.count >= 1
            {
                do {
                    try managedContext.deleteObject(result[0] as! NSManagedObject)
                    
                    
                    do {
                        try managedContext.save()
                        completion(Error: false)
                        //5
                        // people.append(person)
                    } catch let error as NSError  {
                        
                        completion(Error: true)
                        print("Could not save \(error), \(error.userInfo)")
                    }

                    
                    //5
                    
                    
                    // people.append(person)
                } catch let error as NSError  {
                    
                    completion(Error: true)
                    print("Could not save \(error), \(error.userInfo)")
                }

            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }

        
    }

    func loadFavoriteResource(completion:(Error:Bool,result :NSArray)->Void)
    {
        let request =  NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("FavoriteResouce",
            inManagedObjectContext:managedContext)
      
       
        
        
        
        do {
            let result = try self.managedContext.executeFetchRequest(request) as! NSArray
         
            var returnArray = NSMutableArray()
            
            for data  in result
            {
               
                print(data)
                DpaAPI.shareInstance.requestForResouceByID((data.valueForKey("resourceID") as? Int)!,completion: {
                    (Error:Bool,result :DPAResource) ->  Void in
                    
                    
                    if Error == false
                    {
                        
                        returnArray.addObject(result)
                        completion(Error: false, result: returnArray)
                    }
                }
                
                )
            }
            completion(Error: false, result: returnArray)

        
    
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
      

    }
    func checkIfResourceExistInDatabase(resource:DPAResource) -> Bool
    {
        /*NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"EntityName" inManagedObjectContext:moc]];
        
        NSError *error = nil;
        NSArray *results = [moc executeFetchRequest:request error:&error];
        
        // error handling code
        The array results contains all the managed objects contained within the sqlite file. If you want to grab a specific object (or more objects) you need to use a predicate with that request. For example:
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"attribute == %@", @"Some Value"];
        [request setPredicate:predicate];*/
        
        let request =  NSFetchRequest()
        request.entity = NSEntityDescription.entityForName("FavoriteResouce",
            inManagedObjectContext:managedContext)
        let predicate =  NSPredicate(format: "resourceID == %d", resource.resourceID)
        

        request.predicate = predicate
        print(resource.resourceID)
   
   
        
        do {
            let result = try self.managedContext.executeFetchRequest(request) as! NSArray
          
            if result.count >= 1
            {
                return true
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return false
        
        
    }
    


}
