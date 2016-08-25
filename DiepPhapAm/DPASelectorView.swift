//
//  DPASelectorButton.swift
//  DiepPhapAm
//
//  Created by Mac on 8/17/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation
import UIKit
protocol DPASelectorViewDelegate{
    
        func DPASelectorViewDidTouch()
    
}

@IBDesignable class DPASelectorView:UIView
    
{
    @IBOutlet weak var TitleLabel: UILabel!

    @IBOutlet weak var ImageView: UIImageView!

    
    var view: UIView!
    var delegate:DPASelectorViewDelegate?
    

    
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
        self.TitleLabel.font = UIFont.boldSystemFontOfSize(15.0)
        
        
        let gesture = UITapGestureRecognizer(target: self, action: "viewDidTouch:")
        self.addGestureRecognizer(gesture)
        self.view.addGestureRecognizer(gesture)
        
        
    }
    func viewDidTouch(sender:UITapGestureRecognizer){
        self.delegate?.DPASelectorViewDidTouch()
    
    
    }
    

    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "DPASelectorView", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }



}
