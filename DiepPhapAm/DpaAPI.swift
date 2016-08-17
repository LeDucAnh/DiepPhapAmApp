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


    var ResourceString = "http://dieuphapam.net/appforo/index.php?resources&limit=15&resource_category_id=0&page=1&order=resource_update_date_reverse&oauth_token=8acd915c87164542e60a85b73b8d4eaa051a0c6c&in_sub=1"
    //    var ResourceString = "http://dieuphapam.net/appforo/index.php?resources&limit=15&resource_category_id=CURRENTCAT&page=CURRENTPAGE&order=resource_update_date_reverse&oauth_token=8acd915c87164542e60a85b73b8d4eaa051a0c6c&in_sub=1"
    func requestForResource(completion:(Error:Bool,resultArray :NSArray)->Void)
    {
    
    
    let requestURL =  NSURL(string: self.ResourceString)
    
    
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
