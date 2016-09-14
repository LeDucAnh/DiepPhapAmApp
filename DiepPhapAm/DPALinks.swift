//
//  Links.swift
//  DiepPhapAm
//
//  Created by Mac on 8/17/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation
class DPALinks:NSObject
    
{

    var DPALinksPermalink = ""
    var DPALinksThumbnail = ""
    
    
    var DPALinkPosterAvatar = ""
    //var resourceDescription = ""
    init(fromDict dict: NSDictionary) {
        
        
        
        if let permalink = dict["permalink"] as? String {
            
            self.DPALinksPermalink = permalink
            
        }
      
        if let thumbnail = dict["thumbnail"] as? String {
            
            self.DPALinksThumbnail = thumbnail
            
        }
        
        
        if let avatar = dict["poster_avatar"] as? String {
            
            self.DPALinkPosterAvatar = avatar
            
        }
        
        // "icon":"http:\/\/dieuphapam.net\/data\/resource_icons\/3\/3896.jpg?1467947583",
        //"thumb":"http:\/\/dieuphapam.net\/data\/resource_icons\/3\/3896.jpg?1467947583"
        
        
    }



}