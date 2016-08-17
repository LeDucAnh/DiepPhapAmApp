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
    var resouceThumbnailURLString = ""
    var resourceTitle = ""
    var resourceDescription = ""
    init(fromDict dict: NSDictionary) {
        
        
        
        if let title = dict["resource_title"] as? String {
            
            self.resourceTitle = title
            
        }
        if let description = dict["resource_description"] as? String {
            
            
            self.resourceDescription = description
        }
        if let thumbnail = dict["thumbnail"] as? String {
            
            self.resouceThumbnailURLString = thumbnail
            
        }
        


        // "icon":"http:\/\/dieuphapam.net\/data\/resource_icons\/3\/3896.jpg?1467947583",
        //"thumb":"http:\/\/dieuphapam.net\/data\/resource_icons\/3\/3896.jpg?1467947583"

        
    }
    
}