//
//  DPASideMenuTableViewCell.swift
//  DiepPhapAm
//
//  Created by Mac on 8/19/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable class DPASideMenuTableViewCell:UITableViewCell
{
    //DPAResourceDetailStretchyHeaderView
    @IBOutlet weak var DPASideMenuTableViewCellTitleLabel: UILabel!
    
    @IBOutlet weak var DPASideMenuTableViewCellMenuImgView: UIImageView!
    @IBOutlet weak var TitleHeightContraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        //   ResourceTitle.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        //   ResourceTitle.numberOfLines = 0
        //ResourceTitle.frame = CGRectMake(ResourceTitle.frame.origin.x ,ResourceTitle.frame.origin.y, ResourceTitle.frame.width, 34)
        
        
        
        
    }
    
}