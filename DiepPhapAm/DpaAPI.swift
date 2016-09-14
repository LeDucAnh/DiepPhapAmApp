//
//  DpaAPI.swift
//  DiepPhapAm
//
//  Created by Mac on 8/16/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation

class DpaAPI:NSObject
    
{
     static let shareInstance = DpaAPI()


    var ResourceString = "http://dieuphapam.net/appforo/index.php?resources&limit=15&resource_category_id=CURRENTCATEGORY&page=CURRENTPAGE&order=resource_update_date_reverse&oauth_token=8acd915c87164542e60a85b73b8d4eaa051a0c6c&in_sub=1"
    //    var ResourceString = "http://dieuphapam.net/appforo/index.php?resources&limit=15&resource_category_id=CURRENTCAT&page=CURRENTPAGE&order=resource_update_date_reverse&oauth_token=8acd915c87164542e60a85b73b8d4eaa051a0c6c&in_sub=1"
    
    let CategoryRequestString = "http://dieuphapam.net/appforo/index.php?resource-categories"
    var ResourceRequestByIDString = "http://dieuphapam.net/appforo/index.php?resources/RESOURCEID/&oauth_token=e335d4a1008174d5c78084bcd469fad4c752e587"
    var informationRequestString = "http://dieuphapam.net/appforo/index.php?threads/promoted&oauth_token=0,1472120928,4a399e9641bce5e02ebd7aa2a40bf865,mkxx7h3o2n&locale=vi&limit=15&page=CURRENTPAGE"
    
    func RequestForInformationNews(currentPage:Int,completion:(Error:Bool,resultArray :NSArray)->Void)
    {
        var requestString =  self.informationRequestString.stringByReplacingOccurrencesOfString("CURRENTPAGE", withString: String(currentPage))
        
        
        
        let requestURL =  NSURL(string:requestString)
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL!)
        // print(ALAssetsLibraryAssetForURLResultBlock)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            
            if response == nil
            {
                completion(Error: true, resultArray: NSArray())
            }
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    var returnArray = NSMutableArray()
                    if let resultArray = json.objectForKey("threads") as?
                        //[[String: AnyObject]] {
                        NSArray
                    {
                        for resource in resultArray {
                            
                            var newResouce =  DPAThread.init(fromDict: resource as! NSDictionary)
                            
                            returnArray.addObject(newResouce)
                            
                        }
                        
                    }
                    completion(Error: false, resultArray: returnArray)
                    
                }catch {
                    print("Error with Json: \(error)")
                }
                
                
            }else
            {
                print(error)
            }
        }
        
        
        
        task.resume()
        
        

        

        
    }
    
    func addNewResouceAsCategory(originalArray:NSArray) -> NSArray
    {
        var array = NSMutableArray(array: originalArray)
        

        var i = 0
        
        for cat in  array
        {
            let singleCat =  cat as! DPACategory
                if singleCat.CategoryParentID == 0
                {
                    var totalRes = 0
                    for cat  in array
                    {
                        let cat = cat as! DPACategory
                        if cat.CategoryParentID == singleCat.CategoryID
                        {
                            totalRes =  totalRes + cat.CategoryResourceCount!
                        }
                    }
                    singleCat.CategoryResourceCount = totalRes
                    array.replaceObjectAtIndex(i, withObject: singleCat)
                    
                }
            i++
        }
        var NewResourceCategory:DPACategory = DPACategory()
        NewResourceCategory.CategoryTitle =  "Tác Phẩm Mới"
        NewResourceCategory.CategoryID = 0
        NewResourceCategory.CategoryParentID =  -1
         var totalRes = 0
        for cat in  array
        {
            let singleCat =  cat as! DPACategory
            if singleCat.CategoryParentID == 0
            {
                  totalRes =  totalRes + singleCat.CategoryResourceCount!
            }
        
        }
        NewResourceCategory.CategoryResourceCount =  totalRes
        
        
        array.insertObject(NewResourceCategory, atIndex: 0)
        
        return array
    }
    
    
    
    func requestForCategory(completion:(Error:Bool,resultArray :NSArray)->Void)
    {
        
        
        let requestURL =  NSURL(string: self.CategoryRequestString)
        
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL!)
        // print(ALAssetsLibraryAssetForURLResultBlock)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    var returnArray = NSMutableArray()
                    if let resultArray = json.objectForKey("categories") as?
                        //[[String: AnyObject]] {
                        NSArray
                    {
                        for categoryDict in resultArray {
                            
                            var newcategory =  DPACategory.init(fromDict: categoryDict as! NSDictionary)
                            
                            
                            
                            returnArray.addObject(newcategory)
                            
                        }
                        
                    }
                    
                   returnArray = self.addNewResouceAsCategory(returnArray) as! NSMutableArray
                    
                    completion(Error: false, resultArray: returnArray)
                    
                }catch {
                    print("Error with Json: \(error)")
                }
                
                
            }else
            {
                print(error)
            }
        }
        
        
        
        task.resume()
        

        
        
    }
    func requestForResouceByID(resourceID:Int,completion:(Error:Bool,result :DPAResource)->Void)
    
    {
        var requestString =  self.ResourceRequestByIDString.stringByReplacingOccurrencesOfString("RESOURCEID", withString: String(resourceID))
       
        
        let requestURL =  NSURL(string:requestString)
        
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL!)
        // print(ALAssetsLibraryAssetForURLResultBlock)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            
            if response == nil
            {
                completion(Error: true, result:DPAResource(fromDict: NSDictionary()))
            }
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    var returnArray = NSDictionary()
                    if let result = json.objectForKey("resource") as?
                        //[[String: AnyObject]] {
                        NSDictionary
                    {
                        var newResouce =  DPAResource.init(fromDict: result as! NSDictionary)
                           completion(Error: false, result: newResouce)
                    }
                    else
                    {
                        print(json)
                    }
                 
                    
                }catch {
                    print("Error with Json: \(error)")
                }
                
                
            }else
            {
                print(error)
            }
        }
        
        
        
        task.resume()
        


    }
    
    
    func requestForResource(currentCategory:Int,currentPage:Int,completion:(Error:Bool,resultArray :NSArray)->Void)
    {
    
        var requestString =  self.ResourceString.stringByReplacingOccurrencesOfString("CURRENTPAGE", withString: String(currentPage))
         requestString =  requestString.stringByReplacingOccurrencesOfString("CURRENTCATEGORY", withString: String(currentCategory))
        

        
    let requestURL =  NSURL(string:requestString)
    
    let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL!)
    // print(ALAssetsLibraryAssetForURLResultBlock)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(urlRequest) {
        (data, response, error) -> Void in
        
        
        if response == nil
        {
            completion(Error: true, resultArray: NSArray())
        }
        
        let httpResponse = response as! NSHTTPURLResponse
        let statusCode = httpResponse.statusCode
        
        if (statusCode == 200) {
            print("Everyone is fine, file downloaded successfully.")
            
            
            do{
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                
                var returnArray = NSMutableArray()
                if let resultArray = json.objectForKey("resources") as?
                //[[String: AnyObject]] {
                NSArray
                {
                    for resource in resultArray {
                        
                        var newResouce =  DPAResource.init(fromDict: resource as! NSDictionary)
                        
                        returnArray.addObject(newResouce)
                        
                    }
                    
                }
                completion(Error: false, resultArray: returnArray)
                
            }catch {
                print("Error with Json: \(error)")
            }
            
            
        }else
        {
            print(error)
        }
    }
    
    
    
    task.resume()
    

    }
    
    
    
    
    
}
