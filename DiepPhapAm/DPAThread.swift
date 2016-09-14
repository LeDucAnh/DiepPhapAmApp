//
//  DPAThread.swift
//  DiepPhapAm
//
//  Created by Mac on 8/29/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit

class DPAThread: NSObject {

    
    
    
    var ThreadID:Int = -1
    var ThreadLinks:DPALinks?
    var ThreadTitle = ""
    var ThreadDescription = ""
    var ThreadFourumId:Int = -1
    var ThreadPosts:DPAPost?
    
    
    var ThreadCreatorID:Int = -1
    var ThreadCreateorName : String = ""
    var ThreadCreationDate:Double?
    
    init(fromDict dict: NSDictionary) {
        
        if let ID = dict["thread_id"] as? Int {
            
            self.ThreadID = ID
            
        }
        
        
        if let title = dict["thread_title"] as? String {
            
            self.ThreadTitle = title
            
        }

        if let links = dict["links"] as? NSDictionary {
            
            
            let newlinks =  DPALinks(fromDict: links)
            self.ThreadLinks =  newlinks
            
        }
        
        
        if let post = dict["first_post"] as? NSDictionary {
            
            
            let newpost =  DPAPost(fromDict: post)
            self.ThreadPosts =  newpost
            
        }
        
        
        if let creatorname = dict["creator_username"] as? String {
            
                self.ThreadCreateorName =  creatorname
            
        }
        
        if let creationday = dict["thread_create_date"] as? Double {
            
            self.ThreadCreationDate =  creationday
            
        }

        
        // "icon":"http:\/\/dieuphapam.net\/data\/resource_icons\/3\/3896.jpg?1467947583",
        //"thumb":"http:\/\/dieuphapam.net\/data\/resource_icons\/3\/3896.jpg?1467947583"
        
        
    }
    

}
