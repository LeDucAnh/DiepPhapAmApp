//
//  DPAResource.swift
//  DiepPhapAm
//
//  Created by Mac on 8/16/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation
class DPAResource:NSObject

{
    
    var resourceID:Int = -1
    var resouceLinks:DPALinks?
    var resourceTitle = ""
    var resourceDescription = ""
    init(fromDict dict: NSDictionary) {
        
        if let ID = dict["resource_id"] as? Int {
            
            self.resourceID = ID
            
        }

        
        if let title = dict["resource_title"] as? String {
            
            self.resourceTitle = title
            
        }
        if let description = dict["resource_description"] as? String {
            
            
            self.resourceDescription = description
        }
        if let links = dict["links"] as? NSDictionary {
            
            
            let newlinks =  DPALinks(fromDict: links)
            self.resouceLinks =  newlinks
            
        }
        


        // "icon":"http:\/\/dieuphapam.net\/data\/resource_icons\/3\/3896.jpg?1467947583",
        //"thumb":"http:\/\/dieuphapam.net\/data\/resource_icons\/3\/3896.jpg?1467947583"

        
    }
    
}