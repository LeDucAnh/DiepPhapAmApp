//
//  ResourceCollectionViewCell.swift
//  DiepPhapAm
//
//  Created by Mac on 8/16/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation
import UIKit
protocol ResourceCollectionViewCellDelegate{
    
    func DPAResourceCellOptionButtonDidTouch(sender:ResourceCollectionViewCell)
    
}


class ResourceCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ResourceBookName: UILabel!
    var Tag:Int?
    var delegate:ResourceCollectionViewCellDelegate?
    @IBOutlet weak var ResourceTitle: UILabel!

    @IBOutlet weak var ResourceImageView: UIImageView!
    @IBOutlet weak var TitleHeightContraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ResourceTitle.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        ResourceTitle.numberOfLines = 0
        self.ResourceImageView.layer.borderWidth = 2.0
        self.ResourceImageView.layer.borderColor = UIColor(red:255/255.0, green:255/255.0, blue:255/255.0, alpha: 1.0).CGColor
    }
    
 public  func heightForComment(font: UIFont, width: CGFloat,comment :String) -> CGFloat {
        
        
        let rect = NSString(string: comment).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        ResourceTitle.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        ResourceTitle.numberOfLines = 0
        //ResourceTitle.frame = CGRectMake(ResourceTitle.frame.origin.x ,ResourceTitle.frame.origin.y, ResourceTitle.frame.width, 34)
        
        
        
        let font =  UIFont.systemFontOfSize(12.0)
        
        var commentHeight = 80.0
        
        

self.TitleHeightContraint.constant = self.heightForComment(font, width: self.ResourceTitle.frame.width, comment: self.ResourceTitle.text!)
        //self.layoutSubviews()
       // print(self.ResourceTitle.frame.height)
        print(self.ResourceTitle.text)

        
    }
    @IBAction func OptionButtonDidTouch(sender: AnyObject) {
    
        self.delegate!.DPAResourceCellOptionButtonDidTouch(self)
        
    }




    

}


