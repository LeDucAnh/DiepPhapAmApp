//
//  DPAPost.swift
//  DiepPhapAm
//
//  Created by Mac on 8/29/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation

class DPAPost: NSObject {
    
    
    var PostID:Int = -1
    var PostLinks:DPALinks?

    var PostPlainText = ""
    var PostBBCodeText = ""
    
    var PostPosterID:Int? = -1
    var PostPosterName = ""
    


    
    init(fromDict dict: NSDictionary) {
        
        if let ID = dict["post_id"] as? Int {
            
            self.PostID = ID
            
        }
        
   
        if let text = dict["post_body_plain_text"] as? String {
            
            self.PostPlainText = text.stringByReplacingOccurrencesOfString("\n", withString: "")
            
        }
        /*
        if let text = dict["post_body_html"] as? String {
            
       
            self.PostPlainText = text
        }
*/
        
            if let links = dict["links"] as? NSDictionary {
            
            
            let newlinks =  DPALinks(fromDict: links)
            self.PostLinks =  newlinks
            
        }
        
        
        if let codeText = dict["post_body"] as? String {
            
                        self.PostBBCodeText =  codeText
        }
        
        
        
        // "icon":"http:\/\/dieuphapam.net\/data\/resource_icons\/3\/3896.jpg?1467947583",
        //"thumb":"http:\/\/dieuphapam.net\/data\/resource_icons\/3\/3896.jpg?1467947583"
        
        
    }

}
