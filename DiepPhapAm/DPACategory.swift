//
//  DPAResource.swift
//  DiepPhapAm
//
//  Created by Mac on 8/16/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation
class DPACategory:NSObject
    
{
    var CategoryID:Int = 0
    var CategoryLinks:DPALinks?
    var CategoryTitle = ""
    var CategoryDescription = ""
    var CategoryParentID:Int?
    var CategoryResourceCount:Int?
    override init() {
   
        self.CategoryParentID = -99
        self.CategoryLinks = nil
        self.CategoryTitle = ""
        self.CategoryDescription = ""
        self.CategoryParentID = -99
     self.CategoryResourceCount = -99

    }
    init(fromDict dict: NSDictionary) {
        
        
        
        
        
        if let categoryID = dict["resource_category_id"] as? Int
        {
            self.CategoryID =  categoryID
            
        }
        if let categoryResCount = dict["category_resource_count"] as? Int
        {
         self.CategoryResourceCount = categoryResCount
        }

        if let title = dict["category_title"] as? String {
            
            self.CategoryTitle = title
            
        }
        if let description = dict["category_description"] as? String {
            
            
            self.CategoryDescription = description
        }
        if let links = dict["links"] as? NSDictionary {
            
            
            let newlinks =  DPALinks(fromDict: links)
            self.CategoryLinks =  newlinks
            
        }
        
        
        if let parentID = dict["parent_category_id"] as? Int {
            
                 self.CategoryParentID =  parentID
            
        }
        
        
        // "icon":"http:\/\/dieuphapam.net\/data\/resource_icons\/3\/3896.jpg?1467947583",
        //"thumb":"http:\/\/dieuphapam.net\/data\/resource_icons\/3\/3896.jpg?1467947583"
        
        
    }
    
}