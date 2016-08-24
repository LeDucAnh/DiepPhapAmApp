//
//  DPAResourceDetailViewController.swift
//  DiepPhapAm
//
//  Created by Mac on 8/24/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit

class DPAResourceDetailViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!

    var DPAResourceDetailVC_TableViewStretchyHeaderView : DPAResourceDetailStretchyHeaderView?
    
    var exploringResource : DPAResource?
    
    @IBOutlet weak var DPAResourceDetailVC_TableView: UITableView!
    func setupView()
    {
   
    
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        
        /*   NSArray<UIView *> *nibViews = [[NSBundle mainBundle] loadNibNamed:@"GSKTabsStretchyHeaderView"
        owner:self
        options:nil];
        self.stretchyHeaderView = nibViews.firstObject;
        [self.tableView addSubview:self.stretchyHeaderView];
        }*/
        
        
        let array = NSBundle.mainBundle().loadNibNamed("DPAResourceDetailStretchyHeaderView", owner: self, options: nil)
        self.DPAResourceDetailVC_TableViewStretchyHeaderView = array.first as! DPAResourceDetailStretchyHeaderView
        self.DPAResourceDetailVC_TableView.addSubview(self.DPAResourceDetailVC_TableViewStretchyHeaderView!)
        
        self.loadResourceDetail()
        
        
        // Do any additional setup after loading the view.
    }
    func loadResourceDetail()
    {
        print(self.exploringResource?.resouceLinks!.DPALinksThumbnail)
        
        
    self.DPAResourceDetailVC_TableViewStretchyHeaderView?.DPAResourceDetailStretchyHeaderView_ResourceImageView.sd_setImageWithURL(NSURL(string: (self.exploringResource?.resouceLinks!.DPALinksThumbnail)!))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButtonDidTouch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
