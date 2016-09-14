//
//  DPAInformationViewController.swift
//  DiepPhapAm
//
//  Created by Mac on 8/28/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit

import TUSafariActivity
import BBCodeParser

class DPAInformationViewController: DPAViewController ,DPAInformationCollectionViewCellDelegate{

    
    //DPAInformationCollectionViewCellDelegate
    
    func DPAInformationCollectionViewCellCommentButtonDidTouch(sender: DPAInformationCollectionViewCell) {
        
        
        dispatch_async(dispatch_get_main_queue()) {
         self.performSegueWithIdentifier("fromInformationViewToDetailVC", sender: self.resourceArray?.objectAtIndex(sender.tag))
        print("detail")
        
        }
        
    }
    func DPAInformationCollectionViewCellLoveButtonDidTouch(sender: DPAInformationCollectionViewCell) {
        print("love")
        // prepare json data
       
        let json = [ "user_id":"213" , "username": "anh" ]
        ///
        do
        {
        let jsonData = try  NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
        
        // create post request
        let url = NSURL(string: "http://dieuphapam.net/appforo/index.php?posts/3267/likes")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        // insert json data to the request
        request.HTTPBody = jsonData
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data,response,error in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            
            do
            {
            if let responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject]{
                print(responseJSON)
            }
            }
            catch
            {
                
            }
        }
        
        task.resume()
        }
        catch
        {
            
        }
    }
    func DPAInformationCollectionViewCellShareButtonDidTouch(sender: DPAInformationCollectionViewCell) {
         print("share")
        //self.displayShareSheet(resource.resouceLinks!.DPALinksPermalink)
    let thread =  self.resourceArray?.objectAtIndex(sender.tag) as! DPAThread
        
        
        self.displayShareSheet(thread.ThreadLinks!.DPALinksPermalink)
        

        
    }
    
    

    func loadDataFromDatabase()
    {
        
        
        
    }
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        
        
        if indexPath.row == (self.resourceArray?.count)! - 1 && (self.resourceArray?.count)!/(self.resourceArray?.count)! == self.currentPage
        {
            
            
            self.currentPage =  self.currentPage + 1
            
            
            
            DpaAPI.shareInstance.RequestForInformationNews(self.currentPage, completion:  {
                (Error:Bool,resultArray :NSArray) ->  Void in
              
                
                

                    self.resourceArray?.addObjectsFromArray(resultArray as! [DPAThread])
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.ResourceCollectionView.reloadData()
                    }
                )
                
                
                
                }
            )
            
            
        }
        
        
        
        
    }

    override func viewWillAppear(animated: Bool) {
        self.loadDataFromDatabase()
        self.DPAViewControllerTitleLabel.text = "Thông Tin"
    }
    override func viewDidLoad() {
        
        
        
        
        
        let revealVC = self.revealViewController()
        if ((revealVC) != nil)
        {
            self.sideBarButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
            
            
        }
        
        
        self.ResourceCollectionView.registerNib(UINib(nibName: "DPAInformationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.ResourceCollectionView.delegate = self
        self.ResourceCollectionView.dataSource = self
        
        self.currentPage =  1
        DpaAPI.shareInstance.RequestForInformationNews(self.currentPage, completion:  {
            (Error:Bool,resultArray :NSArray) ->  Void in
            self.resourceArray  = NSMutableArray(array: resultArray)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.ResourceCollectionView.reloadData()
                }
            )
            

            
            }
            )
            
        
        /*
        DpaAPI.shareInstance.requestForResource(self.currentCat, currentPage: self.currentPage,completion: {
            (Error:Bool,resultArray :NSArray) ->  Void in
            self.resourceArray  = NSMutableArray(array: resultArray)
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.ResourceCollectionView.reloadData()
                }
            )
            
            
            
            }
            
            
        )
*/
        

        
        
        
        
        

        
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
        
        
        
        let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! DPAInformationCollectionViewCell
        
        cell.delegate = self
        cell.tag =  indexPath.row
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        cell.layoutIfNeeded()
        //cell.contentView.userInteractionEnabled = false
        cell.tag = indexPath.row
        
        
        
        
        let thread =  self.resourceArray?.objectAtIndex(indexPath.row) as! DPAThread
        
  
      
        
        cell.DPAInformationCollectionViewCell_lovebutton.imageView?.image = UIImage(named: "heart.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
      
        cell.DPAInformationCollectionViewCell_lovebutton.imageView?.tintColor = UIColor.lightGrayColor()
        
        

        
        let useriamgeurl =  NSURL(string: (thread.ThreadPosts?.PostLinks!.DPALinkPosterAvatar)!)
        
        cell.DPAInformationCollectionViewCell_uploaderImageView.sd_setImageWithURL(useriamgeurl)
        cell.DPAInformationCollectionViewCell_TitleLabel.text =  thread.ThreadTitle
        
        var contentText = thread.ThreadPosts?.PostPlainText
        
      if contentText?.characters.count > 1000
      {
        /*
        let nsRange : NSRange = NSRange(location: 0, length: 4)
        
        let replaced = (textField.text as NSString)
            .stringByReplacingCharactersInRange(nsRange, withString: "that");
*/
            let range : NSRange = NSRange(location: 1000, length: (contentText?.characters.count)! - 1000)
        contentText = (contentText! as NSString)
            .stringByReplacingCharactersInRange(range, withString: "...")

        
        
        
        }
        cell.DPAInformationCollectionViewCell_ContentLabel.text =  contentText
        
        cell.DPAInformationCollectionViewCell_uploaderNameLabel.text = thread.ThreadCreateorName
        cell.DPAInformationCollectionViewCell_TimeLabel.text =  NSDate.getElapsedInterval(NSDate(timeIntervalSince1970: thread.ThreadCreationDate!))()
        
        
        cell.DPAInformationCollectionViewCell_lovebutton.layer.cornerRadius = 18.0
        cell.DPAInformationCollectionViewCell_lovebutton.layer.masksToBounds =  true
        
        cell.DPAInformationCollectionViewCell_sharebutton.layer.cornerRadius = 18.0
        cell.DPAInformationCollectionViewCell_sharebutton.layer.masksToBounds =  true
      
        cell.DPAInformationCollectionViewCell_CommentButton.layer.cornerRadius = 18.0
        
        
        cell.DPAInformationCollectionViewCell_CommentButton.layer.masksToBounds =  true
        
        


        var image  = UIImage(named: "share.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        
        cell.DPAInformationCollectionViewCell_sharebutton.setImage(image, forState: .Normal)
        image  =  UIImage(named: "comment.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        
        
        cell.DPAInformationCollectionViewCell_CommentButton.setImage(image, forState: .Normal)
        
    image  =  UIImage(named: "love.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.DPAInformationCollectionViewCell_lovebutton.setImage(image, forState: .Normal)
        
        
        
    cell.DPAInformationCollectionViewCell_lovebutton.imageView?.tintColor = UIColor(red: 109/255, green: 109/255, blue: 109/255, alpha: 1.0)
        cell.DPAInformationCollectionViewCell_CommentButton.imageView?.tintColor = UIColor(red: 109/255, green: 109/255, blue: 109/255, alpha: 1.0)
        
        cell.DPAInformationCollectionViewCell_sharebutton.imageView?.tintColor = UIColor(red: 109/255, green: 109/255, blue: 109/255, alpha: 1.0)
        

        
        
        cell.layer.masksToBounds = false
        cell.layer.borderColor = UIColor.whiteColor().CGColor
        cell.layer.borderWidth = 1
        cell.layer.shadowOpacity = 0.4
        
        cell.layer.contentsScale = UIScreen.mainScreen().scale
        cell.layer.shadowRadius = 5.0
       // cell.layer.shadowOffset = CGSizeZero
       // cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).CGPath

 //   cell.layer.shouldRasterize = true
        

        
        return cell
        
    }
    override func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var  numberOfColumns: CGFloat = 1.0
        
        
        let thread =  self.resourceArray?.objectAtIndex(indexPath.row) as! DPAThread
        
        
        
        
        let itemWidth = (CGRectGetWidth(self.ResourceCollectionView!.frame) - (numberOfColumns - 1)) / numberOfColumns  - 15.0
        
        
 
        var commentHeight = 80.0
        
    
        
          let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        
        let contentfont =  UIFont.systemFontOfSize(14.0)
        
      
        
        
        
        let heightforcontentlabel = heightForView((thread.ThreadPosts?.PostPlainText)!, font: contentfont, width: screenSize.width - 8) + 21.0 - 7.0
        
        
        let titlefont =  UIFont.systemFontOfSize(16.0)
        
         let heightfortitlelabel = heightForView((thread.ThreadTitle), font: titlefont, width: screenSize.width - 8)
      
        
    var  cellheight =   heightforcontentlabel + heightfortitlelabel
        
        cellheight = cellheight + 160.0
        self.cellSize = CGSizeMake(itemWidth - 10.0, cellheight)
        
        
        
        
        
        
        return self.cellSize!
    }
    
    override  func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            
            
            
            let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
            return sectionInsets
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
       
        return
        if self.CategorySelectionTableView != nil
        {
            if self.CategorySelectionTableView.alpha == 1.0
            {
                return
            }
        }
        if self.optionView.alpha == 1.0
        {
            return
        }
        
        self.performSegueWithIdentifier("fromFavoriteToDetailSegue", sender: self.resourceArray?.objectAtIndex(indexPath.row))
        
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "fromInformationViewToDetailVC") {
            
            
            
            var destinationVC = segue!.destinationViewController as! DPAThreadDetailViewController
            
            let resource = sender as! DPAThread
        
            destinationVC.exploringThread = sender as! DPAThread
            
            
        }
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
    func heightForView(var text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        
        if text.characters.count > 1000
        {
            /*
            let nsRange : NSRange = NSRange(location: 0, length: 4)
            
            let replaced = (textField.text as NSString)
            .stringByReplacingCharactersInRange(nsRange, withString: "that");
            */
            let range : NSRange = NSRange(location: 1000, length: (text.characters.count) - 1000)
            text = (text as NSString)
                .stringByReplacingCharactersInRange(range, withString: "...")
            
            
            
            
        }

        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    

}

extension String {
    public func rangesOfString(searchString:String, options: NSStringCompareOptions = [], searchRange:Range<Index>? = nil ) -> [Range<Index>] {
        if let range = rangeOfString(searchString, options: options, range:searchRange) {
            
            let nextRange = Range(start:range.endIndex, end:self.endIndex)
            return [range] + rangesOfString(searchString, searchRange: nextRange)
        } else {
            return []
        }
    }
}
extension String {
    func indexOf(string: String) -> String.Index? {
        
        return rangeOfString(string, options: .LiteralSearch, range: nil, locale: nil)?.startIndex
    }
}
extension NSDate {
    
    func getElapsedInterval() -> String {
        
    

   var     interval = NSCalendar.currentCalendar().components(.Day, fromDate: self, toDate: NSDate(), options: []).day
        
        if interval > 0 {
            
            
            
            let hour  = NSCalendar.currentCalendar().components(.Day, fromDate: self, toDate: NSDate(), options: []).hour
            let min = NSCalendar.currentCalendar().components(.Day, fromDate: self, toDate: NSDate(), options: []).minute
            
            /*
            NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
            [timeFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
            [timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            NSString *newTime = [timeFormatter stringFromDate:[[NSDate alloc]init] ]
            
            */
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            var newtime =  timeFormatter.stringFromDate(self)
            print(newtime)
            if interval ==  1
            {
                return interval == 1 ? "\(interval)" + " " + "Ngày" :
                    "\(interval)" + " " + "Hôm qua lúc " + newtime
                
            }
            else
            {
            timeFormatter.dateFormat = "MM:dd:YY"
             newtime =  timeFormatter.stringFromDate(self)
                newtime =  newtime.stringByReplacingOccurrencesOfString(":", withString: "/")
            return newtime
            }
        }

        
        return "Mới đây"
    }
}


