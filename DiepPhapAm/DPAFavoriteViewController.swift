//
//  DPAFavoriteViewController.swift
//  DiepPhapAm
//
//  Created by Mac on 8/23/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import TUSafariActivity
import CoreData

class DPAFavoriteViewController: DPAViewController {
    
    
    
    
    @IBOutlet weak var FavoriteResourceCollectionView: UICollectionView!
    
    
    
    
    func loadDataFromDatabase()
    {
        
        
        DPACoreDatabase.shareInstance.loadFavoriteResource({
            (Error:Bool,result :NSArray) ->  Void in
            print(result.count)
                
            self.resourceArray =  result as! NSMutableArray
                      dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.ResourceCollectionView.reloadData()
            }
            )
            
            }
        )

    }
    override func viewWillAppear(animated: Bool) {
        self.loadDataFromDatabase()
    }
    override func viewDidLoad() {
    
        AppDelegate.sharedInstance.DPAFavoriteVC  = self
    let revealVC = self.revealViewController()
    if ((revealVC) != nil)
    {
    self.sideBarButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
    
    }
    
    // super.viewDidLoad()
    
  //    AppDelegate.sharedInstance.DPATabbarVC =  self.tabBarController
    AppDelegate.sharedInstance.DPAFavoriteVC = self
    self.view.bringSubviewToFront(self.optionView)
    
    self.view.sendSubviewToBack(self.ResourceCollectionView)
    
    self.optionView.alpha = 0.0
    
    
    
    
    
    
    
    
    
    
    //self.ResourceCollectionView.registerClass(ResourceCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    self.ResourceCollectionView.registerNib(UINib(nibName: "ResourceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    self.ResourceCollectionView.delegate = self
    self.ResourceCollectionView.dataSource = self
    //self.FavoriteResourceCollectionView.collectionViewLayout = DDPACollectionVCCustomFlow()
    
    self.loadDataFromDatabase()
    
    // Do any additional setup after loading the view, typically from a nib.
    
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
    
    
    
    
    if self.resourceArray != nil
    {
        print(self.resourceArray?.count)
    return (self.resourceArray?.count)!
    }
    return 0
    
    }
    //collectionviewDatasource
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
    
    
    let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ResourceCollectionViewCell
    cell.setNeedsLayout()
    cell.layoutIfNeeded()
    cell.layoutSubviews()
    cell.layoutIfNeeded()
    cell.delegate = self
    cell.tag = indexPath.row
    cell.contentView.userInteractionEnabled = false
    
    let resouce =  self.resourceArray?.objectAtIndex(indexPath.row) as! DPAResource
    
    
    
    let url =  NSURL(string: resouce.resouceLinks!.DPALinksThumbnail)
    
    cell.ResourceImageView.sd_setImageWithURL(url)
    cell.ResourceTitle.text =  resouce.resourceTitle
    
    
    cell.ResourceBookName.text =  resouce.resourceDescription
    
    return cell
    
    }
    

    override  func DPAResourceCellOptionPopUpViewDidTapOption(index:DPAResourceCellOptionPopUpViewOption)
    {
        print(index)
        self.optionView.alpha = 0.0
        let resource:DPAResource = self.resourceArray?.objectAtIndex(self.optionView.tag) as! DPAResource
        if index == DPAResourceCellOptionPopUpViewOption.Share
        {
            
            
            
            self.displayShareSheet(resource.resouceLinks!.DPALinksPermalink)
        }
        if index == DPAResourceCellOptionPopUpViewOption.RemoveLike
        {
            
            if  DPACoreDatabase.shareInstance.checkIfResourceExistInDatabase(resource) == true
            {
                //did exist
                
                DPACoreDatabase.shareInstance.removeFavoriteItemToDatabase(resource, completion:  {
                    (Error:Bool) ->  Void in
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in

                    self.loadDataFromDatabase()
                    self.ResourceCollectionView.reloadData()
                    }
                    )
                    
                    
                })
            }
            else
            {
                DPACoreDatabase.shareInstance.saveFavoriteItemToDatabase(resource,completion: {
                    (Error:Bool,FailType :DPACoreDatabaseAddResourceFavoriteFailCase) ->  Void in
                    
                    
                    
                })
            }
            
            
        }
        
    }

    
    
    
    
    
}
