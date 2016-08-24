//
//  DPAViewController.swift
//  DiepPhapAm
//
//  Created by Mac on 8/16/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import TUSafariActivity

class DPAViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout,DPASelectorViewDelegate,ResourceCollectionViewCellDelegate,UITableViewDataSource,UITableViewDelegate,DPAResourceCellOptionPopUpViewDelegate{
    
    var tapGesture:UITapGestureRecognizer?
    @IBOutlet weak var CategorySelectionTableView: UITableView!
    @IBOutlet weak var optionView: DPAResourceCellOptionPopUpView!
    @IBOutlet weak var selectorView: DPASelectorView!
   // @IBOutlet weak var CategoryButton: UIButton!
    @IBOutlet weak var sideBarButton: UIButton!
    @IBOutlet weak var ResourceCollectionView: UICollectionView!
    var cellSize:CGSize?
    
    let link = "http://dieuphapam.net/appforo/index.php?resource-categories"
    var currentCat = 0
    var currentPage = 1
    

    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    var resourceArray:NSMutableArray?
    var categoryArray:NSMutableArray?
    var categoryParentArray = NSMutableArray()
    var categoryNumofRows = NSMutableArray()
    //Changing Status Bar
    override func viewDidLayoutSubviews() {
        
        if self.optionView != nil
        {
        self.optionView.frame = CGRectMake(self.optionView.viewPoint.x, self.optionView.viewPoint.y, self.optionView.frame.size.width, self.optionView.frame.size.height)
        }
    }
    
  
    func DPASelectorViewDidTouch()
    {
    
        
        let imagePickerController = UIImagePickerController()
     //   imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        imagePickerController.allowsEditing = false
        
      //  let  popOver = UIPopoverController(contentViewController: imagePickerController)
       //popOver.presentPopoverFromRect(self.selectorView.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        
        self.CategorySelectionTableView.alpha =  1.0
        self.addTapGesturetoView()
                
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    override func viewDidAppear(animated: Bool) {
        
        if self.optionView != nil
        {
        self.optionView.alpha = 0.0
        }
        if self.ResourceCollectionView != nil
        {
        self.ResourceCollectionView.reloadData()
        }// self.CategorySelectionTableView.alpha = 0.0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
        

    
        AppDelegate.sharedInstance.DPATabbarVC =  self.tabBarController
      AppDelegate.sharedInstance.DPAViewVC =  self
        self.view.bringSubviewToFront(self.optionView)
        self.view.bringSubviewToFront(self.CategorySelectionTableView)
        self.view.sendSubviewToBack(self.ResourceCollectionView)

        self.optionView.alpha = 0.0
        self.CategorySelectionTableView.alpha = 0.0
               self.selectorView.TitleLabel.text = "Tác phẩm mới"
        self.selectorView.delegate = self
        
        
        
        self.CategorySelectionTableView.delegate = self
        self.CategorySelectionTableView.dataSource = self
        self.CategorySelectionTableView.delegate = self
        self.CategorySelectionTableView.dataSource =  self

        
       // self.CategorySelectionTableView.registerClass(DPACategoryTableViewCell.self, forCellReuseIdentifier: "Cell")
        self.CategorySelectionTableView.registerNib(UINib(nibName: "DPACategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
      
        print(self.resourceArray?.count)
        
        DpaAPI.shareInstance.requestForCategory({
            (Error:Bool,resultArray :NSArray) ->  Void in
            
         
            if Error == false
            {
                
                self.categoryArray  = NSMutableArray(array: resultArray)
                

                
             //   self.categoryArray?.addObjectsFromArray(resultArray as! [DPACategory])
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    
                                    self.CategorySelectionTableView.reloadData()

                                    
                                    }
                                    )
            
            }
        
        }
        )
              //  self.CategoryButton   = UIButton(type: UIButtonType.System) as UIButton! //this is Swift2.0 in this place use your code
       // CategoryButton.frame =  CGRectMake(2, 74, 140, 40)
        /*
        self.CategoryButton.tintColor = UIColor.whiteColor()
        self.CategoryButton.setImage(UIImage(named:"arrowdown.png"), forState: UIControlState.Normal)
        self.CategoryButton.imageEdgeInsets = UIEdgeInsets(top: 6,left: 100,bottom: 6,right: 0)
        self.CategoryButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: -(self.CategoryButton.titleLabel?.frame.size.width)!,bottom: 0,right: 50)
        self.CategoryButton.titleLabel?.frame.size = CGSizeMake(100, (self.CategoryButton.titleLabel?.frame.size.height)!)
        self.CategoryButton.setTitle("Tác Phẩm Mới", forState: UIControlState.Normal)
        self.CategoryButton.titleLabel?.font = UIFont.systemFontOfSize(15.0)
       // self.CategoryButton.layer.borderWidth = 1.0
        self.CategoryButton.backgroundColor = UIColor.redColor()
       // self.CategoryButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.CategoryButton.addTarget(self, action: Selector("showSortTbl"), forControlEvents: UIControlEvents.TouchUpInside)
       // self.view.addSubview(btnSort)
        */
        
        let revealVC = self.revealViewController()
        if ((revealVC) != nil)
        {
            self.sideBarButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
            
        }
        
        //self.ResourceCollectionView.registerClass(ResourceCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.ResourceCollectionView.registerNib(UINib(nibName: "ResourceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.ResourceCollectionView.delegate = self
        self.ResourceCollectionView.dataSource = self
        //self.ResourceCollectionView.collectionViewLayout = DDPACollectionVCCustomFlow()
        
        DpaAPI.shareInstance.requestForResource(self.currentCat, currentPage: self.currentPage,completion: {
            (Error:Bool,resultArray :NSArray) ->  Void in
            self.resourceArray  = NSMutableArray(array: resultArray)
            
            
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.ResourceCollectionView.reloadData()
            }
            )
            
            

            }
    
        
        )
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
     {
        
        if self.resourceArray != nil
        {
        return (self.resourceArray?.count)!
        }
        return 0
        
    }
    

    
    /*- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
    }
    
    - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
    }
    
    // Layout: Set Edges
    - (UIEdgeInsets)collectionView:
    (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
    }*/
    
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
      return  10.0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var  numberOfColumns: CGFloat = 2.0
        
        
           let resouce =  self.resourceArray?.objectAtIndex(indexPath.row) as! DPAResource
        
    
        if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft || UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight
        {
            numberOfColumns = 3
            
        }
        if UIDevice.currentDevice().userInterfaceIdiom  ==  UIUserInterfaceIdiom.Pad {
            numberOfColumns += 1
        }

        
        
        
        let itemWidth = (CGRectGetWidth(self.ResourceCollectionView!.frame) - (numberOfColumns - 1)) / numberOfColumns  - 15.0
      
        
        let font =  UIFont.systemFontOfSize(14.0)
      
        var commentHeight = 80.0
        
      
     //   let TitleHeight = self.heightForComment(font, width: itemWidth,comment: resouce.resourceTitle)
      //  let bookHeight = 21.0
          //  print(TitleHeight)
       
        
        
          //  commentHeight = Double(TitleHeight) + bookHeight + 5.0
        
        
        
        
        
        self.cellSize = CGSizeMake(itemWidth, itemWidth + CGFloat(60.0))

        
        return self.cellSize!
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    
    
   

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            
            
            
            
            return sectionInsets
    }
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        
        
        if indexPath.row == (self.resourceArray?.count)! - 1 && (self.resourceArray?.count)!/15 == self.currentPage
        {
         
            
            self.currentPage =  self.currentPage + 1
            
        
            
            DpaAPI.shareInstance.requestForResource(self.currentCat, currentPage: self.currentPage,completion: {
                (Error:Bool,resultArray :NSArray) ->  Void in
                
                self.resourceArray?.addObjectsFromArray(resultArray as! [DPAResource])
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.ResourceCollectionView.reloadData()
                    
                    print("load more")
                    print(self.currentPage)
                    
                    
                    }
                )
                
                
                
                }
                
                
            )

        
        }
        
        
        
        
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "acb") {
            
            
            
            var destinationVC = segue!.destinationViewController as! DPAResourceDetailViewController
         
            let resource = sender as! DPAResource
            print(resource.resouceLinks!.DPALinksThumbnail)
            
            destinationVC.exploringResource = sender as! DPAResource
            
            
        }
    }
    //ResourceCollectionViewCellDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        self.performSegueWithIdentifier("acb", sender: self.resourceArray?.objectAtIndex(indexPath.row))
        
        
        
    }
    
    //DPAResourceCellOptionButtonDelegate
    func displayShareSheet(shareContent:String) {
        
        /* NSArray *activities = @[[SVWebViewControllerActivitySafari new], [SVWebViewControllerActivityChrome new]];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[_article.url] applicationActivities:activities];*/
        
      
      //  let activity = TUSafariActivity()
 
        /*SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:@"http://google.com"];
        [self.navigationController pushViewController:webViewController animated:YES];*/
     
       
        let activity = TUSafariActivity()
     
        let URL = NSURL(string: shareContent)
               let activityViewController = UIActivityViewController(activityItems: [URL!], applicationActivities: [activity])
        
        
        presentViewController(activityViewController, animated: true, completion: {})
    }
    func DPAResourceCellOptionPopUpViewDidTapOption(index:DPAResourceCellOptionPopUpViewOption)
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
    func DPAResourceCellOptionButtonDidTouch(sender:ResourceCollectionViewCell)
    {
        self.optionView.tag =  sender.tag
        

      //  UICollectionViewLayoutAttributes * theAttributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
        
        //CGRect cellFrameInSuperview = [collectionView convertRect:theAttributes.frame toView:[collectionView superview]];
        let resource:DPAResource = self.resourceArray?.objectAtIndex(self.optionView.tag) as! DPAResource
        
     
        let theAttributes = self.ResourceCollectionView.layoutAttributesForItemAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0))
        let cellPointInSuperview =  self.ResourceCollectionView.convertPoint((theAttributes?.frame.origin)!, toView: self.view)
        
        print(cellPointInSuperview)
        self.optionView.delegate = self
        self.optionView.frame = CGRectMake(cellPointInSuperview.x + self.cellSize!.width -  self.optionView.frame.size.width, cellPointInSuperview.y + 40, 100, 80)
      self.optionView.viewPoint = self.optionView.frame.origin
        self.addTapGesturetoView()
        
        if  DPACoreDatabase.shareInstance.checkIfResourceExistInDatabase(resource) == true
        {
            
            self.optionView.removeLikeButton.setTitle("Bỏ Thích", forState: .Normal)
            
        }
        else
        {
            self.optionView.removeLikeButton.setTitle("Thích", forState: .Normal)
        }
        
    self.optionView.alpha = 1.0
        
    
    }
    
    func addTapGesturetoView()
    {
        
        
        self.tapGesture = UITapGestureRecognizer(target: self, action : "handleTap:")
        tapGesture!.numberOfTapsRequired = 1
        if ((self.ResourceCollectionView.gestureRecognizers?.contains(self.tapGesture!)) != nil)
        {
        return 
        }
        self.ResourceCollectionView.addGestureRecognizer(tapGesture!)
        

    }
    //collectionviewScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
      
        if scrollView == self.ResourceCollectionView
        {
            
            if self.tapGesture != nil
            {
                self.handleTap(self.tapGesture!)
            }
            self.optionView.alpha = 0.0
            
            
            if    self.CategorySelectionTableView != nil{
            self.CategorySelectionTableView.alpha = 0.0
            }
        }
        
    }
    
    //collectionviewDatasource
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
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
   override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
        self.ResourceCollectionView.performBatchUpdates(nil, completion: nil)
    
        self.optionView.alpha = 0.0
    }
    //touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("ddsaf")
        
        self.optionView.alpha = 0.0
        if self.CategorySelectionTableView != nil
        {
        self.CategorySelectionTableView.alpha = 0.0
        }
    }
    func handleTap(sender: UITapGestureRecognizer)
    {
        print("aa")
        
        self.optionView.alpha = 0.0
        if self.CategorySelectionTableView != nil
        {
        self.CategorySelectionTableView.alpha = 0.0
        }

        self.ResourceCollectionView.removeGestureRecognizer(sender)
    }
    //CategorySelectionTableView Datasource + Delegate
      func numberOfSectionsInTableView(tableView: UITableView) -> Int // Default is 1 if not implemented
    
    {
        if tableView ==  self.CategorySelectionTableView
        {

            var i = 0
            var passitems = 0
            if self.categoryArray != nil
            {
            for cat  in self.categoryArray!
            {
                
                if let DPACat:DPACategory = cat as!  DPACategory
               {
                if DPACat.CategoryParentID == 0 || DPACat.CategoryParentID == -1
                {
                    i = i+1
                    self.categoryParentArray.addObject(DPACat.CategoryID)
                    self.categoryNumofRows.addObject(passitems)
                    print(self.categoryNumofRows)
                    
                }
                passitems  = passitems + 1
            
                }
            
            }
                
                
                print(self.categoryParentArray)
            return i

            }
        }
        return 1
    }
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
        
        if tableView == self.CategorySelectionTableView
        {
            
            if self.categoryArray != nil
            {
                //return (self.categoryArray?.count)!
                
                var i = 0
                for cat  in self.categoryArray!
                {
                    if let DPACat:DPACategory = cat as!  DPACategory
                    {
                        if DPACat.CategoryParentID == self.categoryParentArray.objectAtIndex(section) as! Int && self.categoryParentArray.objectAtIndex(section) as! Int != 0
                            
                        {
                            i = i + 1
                           
                            
                            
                        }
                        
                    }
                }
               
                return i + 1

            }
            
        
        }
        return 0
    
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == self.CategorySelectionTableView
        {
           print(self.categoryNumofRows)
            let indexinResouceArray =  self.categoryNumofRows[indexPath.section] as! Int + indexPath.row
            let CategoryModel =  self.categoryArray![indexinResouceArray] as! DPACategory
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! DPACategoryTableViewCell
          
            cell.DPACategoryTitleLabel.text = CategoryModel.CategoryTitle
            
            
            cell.DPACategoryResourceCountLabel.text = String(CategoryModel.CategoryResourceCount!)
            return cell
            
        }
        return UITableViewCell()
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section ==  0
        {
            return 0
        }
        return 20
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    
        
                    let indexinResouceArray =  self.categoryNumofRows[indexPath.section] as! Int + indexPath.row
        
        let refreshCategory  =  self.categoryArray?.objectAtIndex(indexinResouceArray) as! DPACategory
        self.refreshViewWithCategory(refreshCategory)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.CategorySelectionTableView.alpha = 0.0
    
    
    }
    func refreshViewWithCategory(cat:DPACategory)
    {
        
        self.currentCat =  cat.CategoryID
        self.currentPage =  0
        self.selectorView.TitleLabel.text =  cat.CategoryTitle
        
        
        DpaAPI.shareInstance.requestForResource(self.currentCat, currentPage: self.currentPage,completion: {
            (Error:Bool,resultArray :NSArray) ->  Void in
            self.resourceArray  = NSMutableArray(array: resultArray)
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.ResourceCollectionView.reloadData()
                }
            )
            
            
            
            }
            
            
        )

        
    }
  


}


