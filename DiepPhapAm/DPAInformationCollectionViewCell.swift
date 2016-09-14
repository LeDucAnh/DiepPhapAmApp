//
//  DPAInformationCollectionViewCell.swift
//  DiepPhapAm
//
//  Created by Mac on 8/28/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit

protocol DPAInformationCollectionViewCellDelegate{
    
func DPAInformationCollectionViewCellCommentButtonDidTouch(sender:DPAInformationCollectionViewCell)
func DPAInformationCollectionViewCellShareButtonDidTouch(sender:DPAInformationCollectionViewCell)
    func DPAInformationCollectionViewCellLoveButtonDidTouch(sender:DPAInformationCollectionViewCell)
    
}


class DPAInformationCollectionViewCell: UICollectionViewCell {

    var delegate:DPAInformationCollectionViewCellDelegate?
        @IBOutlet weak var DPAInformationCollectionViewCell_CommentButton: UIButton!
    @IBOutlet weak var DPAInformationCollectionViewCell_lovebutton: UIButton!
  
    @IBOutlet weak var DPAInformationCollectionViewCell_sharebutton: UIButton!
  
    @IBOutlet weak var DPAInformationCollectionViewCell_uploaderNameLabel: UILabel!

    @IBOutlet weak var DPAInformationCollectionViewCell_TimeLabel: UILabel!
    
    @IBOutlet weak var DPAInformationCollectionViewCell_ContentLabel: UILabel!
    
    @IBOutlet weak var DPAInformationCollectionViewCell_TitleLabel: UILabel!
    @IBOutlet weak var DPAInformationCollectionViewCell_uploaderImageView: UIImageView!
    
    
    //tapGesture
    func handleTap(sender: UITapGestureRecognizer)
    {
        
                self.delegate?.DPAInformationCollectionViewCellCommentButtonDidTouch(self)
    
    
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        var tapGesture:UITapGestureRecognizer?
        
        tapGesture = UITapGestureRecognizer(target: self, action : "handleTap:")
        tapGesture?.numberOfTapsRequired =  1
        self.DPAInformationCollectionViewCell_ContentLabel.addGestureRecognizer(tapGesture!)
        self.DPAInformationCollectionViewCell_ContentLabel.userInteractionEnabled =  true
     
        
        var tapGesture2:UITapGestureRecognizer?
        
        tapGesture2 = UITapGestureRecognizer(target: self, action : "handleTap:")
        tapGesture2?.numberOfTapsRequired =  1
        
        self.DPAInformationCollectionViewCell_TitleLabel.addGestureRecognizer(tapGesture2!)
                self.DPAInformationCollectionViewCell_TitleLabel.userInteractionEnabled =  true

        
 //self.DPAInformationCollectionViewCell_ContentLabel
        /*
        cell.layer.shadowColor = [UIColor CGColor];
        cell.layer.shadowOffset = CGSizeMake(0, 2.0f);
        cell.layer.shadowRadius = 2.0f;
        cell.layer.shadowOpacity = 1.0f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        */
        
        
    //    self.layer.borderColor = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0).CGColor
      //  self.layer.borderWidth = 0.25
        
        //self.layer.shadowColor =  UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1.0).CGColor
       // self.layer.shadowOffset = CGSizeMake(0.1, 0.1)
       // self.layer.shadowOpacity = 0.5
           //     self.layer.masksToBounds = false
      //  self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).CGPath
        
        
    }
    @IBAction func shareButtonDidTouch(sender: AnyObject) {
        
        self.delegate?.DPAInformationCollectionViewCellShareButtonDidTouch(self)
    }
    
    @IBAction func loveButtonDidTouch(sender: AnyObject) {

    self.delegate?.DPAInformationCollectionViewCellLoveButtonDidTouch(self)
    
    }
    @IBAction func commentButtonDidTouch(sender: AnyObject) {
        
        self.delegate?.DPAInformationCollectionViewCellCommentButtonDidTouch(self)
        
        
    }
}
