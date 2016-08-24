//
//  DPAResourceCellOptionPopUpView.swift
//  DiepPhapAm
//
//  Created by Mac on 8/18/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation
import UIKit


protocol DPAResourceCellOptionPopUpViewDelegate{
    
    func DPAResourceCellOptionPopUpViewDidTapOption(index:DPAResourceCellOptionPopUpViewOption)
    
    
}

public enum  DPAResourceCellOptionPopUpViewOption: Int {
    
    case Share
    case RemoveLike // iPhone and iPod touch style UI
   
}

@IBDesignable class DPAResourceCellOptionPopUpView:UIView
{

    
    @IBOutlet weak var tableView: UITableView!
    var view: UIView!
    var delegate:DPAResourceCellOptionPopUpViewDelegate?
    var viewPoint = CGPointMake(0, 0)
    
    @IBOutlet weak var removeLikeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        //  xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        
        
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)

        
        
       // let gesture = UITapGestureRecognizer(target: self, action: "viewDidTouch:")
        //self.addGestureRecognizer(gesture)
        
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     {
        return 2
    }

    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "DPAResourceCellOptionPopUpView", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }

    @IBAction func ShareButtonDidTapped(sender: AnyObject) {
    
    self.delegate?.DPAResourceCellOptionPopUpViewDidTapOption(DPAResourceCellOptionPopUpViewOption.Share)
    }
    @IBAction func RemoveButtonDidTap(sender: AnyObject) {
    
        self.delegate?.DPAResourceCellOptionPopUpViewDidTapOption(DPAResourceCellOptionPopUpViewOption.RemoveLike)

    
    }
    override func layoutSubviews() {
        self.layoutIfNeeded()
        
    }
    override func layoutIfNeeded() {
        
    }
    
    
    
}
