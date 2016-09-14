//
//  DPAThreadDetailViewController.swift
//  DiepPhapAm
//
//  Created by Mac on 8/31/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit
import SDWebImage
import Foundation
import BBCodeParser
import SafariServices

class DPAThreadDetailViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,BBCodeParserDelegate{
    
    public enum  DPAParseBBCodeType: Int {
        case Image //0
        case Attach //1
        case BoldText //2
        case CenterText //3
        case  NormalText//4
        case Media
        case URLLink
        case Color
        case Left
        case Right
        case Center
        case Underline
        case Unknown
        
    }
    
    @IBOutlet weak var DPAThreadDetailTableView: UITableView!
    var exploringThread : DPAThread?
    
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let DPAThreadDetailViewController_attachImagePercentageToScreenHeight :Double = 0.75
    
    var  bbcodeStrureTypeArray = NSMutableArray()
    var resultArray = NSMutableArray()
    var CellsHeightArray = NSMutableArray()
   let boldFont =  UIFont.boldSystemFontOfSize(14.0)
    let normalFont = UIFont.systemFontOfSize(14.0)
    var DPALinkDict = NSMutableDictionary()

    @IBAction func backButtonDidTouch(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        var  bbcodeStruture = NSMutableArray()
      //  DPAThreadDetailTableView.allowsSelection = false
        
       
        
        self.resultArray =     self.convertbbcodeToNSArray() as! NSMutableArray
       var iCount = 0
        for i in self.resultArray
        {
        }
        for element  in resultArray
        {
            print(element)
            
        }
        for element  in self.bbcodeStrureTypeArray
        {
            print(element)
        }
        
        var i  = 0
        while i < self.bbcodeStrureTypeArray.count
        {
            self.CellsHeightArray.addObject(120.0)
            i++
        }
        
        
        
        self.DPAThreadDetailTableView.registerNib(UINib(nibName: "DPAThreadDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.DPAThreadDetailTableView.delegate =  self
        
        self.DPAThreadDetailTableView.dataSource =  self
        

        
        
        
        
        // Do any additional setup after loading the view.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.bbcodeStrureTypeArray.count != 0
        {
            
            print(self.bbcodeStrureTypeArray.count)
            
            return self.bbcodeStrureTypeArray.count
        }
        return 0
    }
   
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row > self.bbcodeStrureTypeArray.count - 1
        {
            return 120.0
        }
      
        
    
        if self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.Image.rawValue)  ==  true
        {
            
            
            return CGFloat(self.CellsHeightArray.objectAtIndex(indexPath.row) as! NSNumber) + 21.0
        }
         if self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.Attach.rawValue)  ==  true
        {
            
            
            return CGFloat(self.CellsHeightArray.objectAtIndex(indexPath.row) as! NSNumber) + 21.0
        }
        
   let     newHeight  =    AppDelegate.sharedInstance.heightForView(self.resultArray[indexPath.row] as! String, font: UIFont.systemFontOfSize(14.0), width: self.screenSize.size.width)
      return newHeight + 21.0
        
        return CGFloat(self.CellsHeightArray.objectAtIndex(indexPath.row) as! NSNumber) + 21.0

        return 120.0
        
        
    }
    func parser(parser: BBCodeParser!, didFinishParsingCode code: String!) {
      
        print(code)
        print(parser.element.elements.count)
        print(parser.element.elementAtIndex(0))
        
      
        for element in parser.element.elements
        {
            print(element.startIndex)
            print(element.description)
       
        
            
        }

        
        
        
    }
    func normalizeNormalString()
    {
        
    }
    func normalizeURLString(var urlString :String,indexPath:NSIndexPath,var firstTypesArray:[DPAParseBBCodeType]) -> NSAttributedString
    {
        if urlString.containsString("'")
        {
            let getURL =  urlString.sliceFrom("'", to: "'")
            
            
            let removedString = "'" + getURL! + "'"
            
            urlString = urlString.stringByReplacingOccurrencesOfString(removedString, withString: "")
            self.DPALinkDict.setValue(getURL, forKey: String(indexPath.row))
            if urlString.containsString("[")
            {
             //       self.normalizeString(urlString, indexPath: indexPath)
             let (startTag, endTag,ContainsTagOrNot,colorValue) =  self.getFirstTags(urlString as! NSMutableString)
              //  urlString =  urlString.stringByReplacingOccurrencesOfString(startTag, withString: "")
               // urlString = urlString.stringByReplacingOccurrencesOfString(endTag, withString: "")
               
                
                var  firstType:DPAParseBBCodeType = DPAParseBBCodeType.Unknown
                switch (true) {
                case (startTag.containsString("[ATTACH]")):
                    firstType = DPAParseBBCodeType.Attach
                case (startTag.containsString("[IMG]")):
                    firstType = DPAParseBBCodeType.Image
                    
                case (startTag.containsString("[CENTER]")):
                  firstType = DPAParseBBCodeType.CenterText
                    
                case (startTag.containsString("[B]")):
                   firstType = DPAParseBBCodeType.BoldText
                case (startTag.containsString("[URL]")):
                     firstType = DPAParseBBCodeType.URLLink
                case startTag.containsString("[COLOR"):
                        firstType = DPAParseBBCodeType.Color
                case startTag.containsString("[U]"):
                    firstType = DPAParseBBCodeType.Underline
 
                default:
                   firstType = DPAParseBBCodeType.NormalText
                }
                firstTypesArray.append(firstType)
               return self.normalizeAString(urlString, indexPath: indexPath, firstTypeArray: firstTypesArray)

            
            }
            
            

            
        
        }
        return self.normalizeAString(urlString, indexPath: indexPath, firstTypeArray: firstTypesArray)

        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        if self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.URLLink.rawValue)  == true || self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.Media.rawValue)  == true
        {
            let urlString =  self.resultArray.objectAtIndex(indexPath.row) as! String
           
            let url = self.DPALinkDict.objectForKey(String(indexPath.row))
            
            print(url)
            
            let svc = SFSafariViewController(URL: NSURL(string: url as! String)!)
            self.presentViewController(svc, animated: true, completion: nil)

        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
      
        let cell =  tableView.dequeueReusableCellWithIdentifier("Cell") as! DPAThreadDetailTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var newHeight:CGFloat = 20.0
        cell.DPAThreadDetailTableViewCell_ImageView.alpha = 0.0
        cell.DPAThreadDetailTableViewCell_Label.alpha = 0.0
        
        var firstTypeArray  = [DPAParseBBCodeType]()
      
                    cell.DPAThreadDetailTableViewCell_Label.textAlignment = NSTextAlignment.Left
        if self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.Media.rawValue)  == true
            
        {
            var converted = self.resultArray.objectAtIndex(indexPath.row) as! String
            if converted.containsString("[media]")
            {
                converted =   converted.sliceFrom("[media]", to: "[/media]")!
            }
           let url =  "http://dieuphapam.net/dpa/duong-di-cua-phat." + converted
            self.DPALinkDict.setObject(url, forKey: String(indexPath.row))
            cell.DPAThreadDetailTableViewCell_Label.text =  converted

            print(cell.DPAThreadDetailTableViewCell_Label.text)
            cell.DPAThreadDetailTableViewCell_ImageView.alpha = 0.0
            cell.DPAThreadDetailTableViewCell_Label.alpha = 1.0
            
            newHeight  =    AppDelegate.sharedInstance.heightForView(cell.DPAThreadDetailTableViewCell_Label.text!, font: cell.DPAThreadDetailTableViewCell_Label.font, width: self.screenSize.size.width)
            
            
            if newHeight != CGFloat(self.CellsHeightArray.objectAtIndex(indexPath.row) as! NSNumber)
            {
                self.CellsHeightArray.replaceObjectAtIndex(indexPath.row, withObject:newHeight)
                
                
                // 5
                dispatch_async(dispatch_get_main_queue(),{
                    
                    tableView.beginUpdates()
                    UIView.animateWithDuration(0.5) {
                        //  cell.contentView.layoutIfNeeded()
                    }
                    
                    //  tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
                    tableView.endUpdates()
                    }
                )
                
                
            }
            

        }

        
        if self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.CenterText.rawValue)  == true
            
        {
            
            var converted = self.resultArray.objectAtIndex(indexPath.row) as! String
            if converted.containsString("[CENER]")
            {
            converted =   converted.sliceFrom("[CENTER]", to: "[/CENTER]")!
            }
            cell.DPAThreadDetailTableViewCell_Label.text =  converted
            cell.DPAThreadDetailTableViewCell_Label.textAlignment = NSTextAlignment.Center
            print(cell.DPAThreadDetailTableViewCell_Label.text)
            cell.DPAThreadDetailTableViewCell_ImageView.alpha = 0.0
            cell.DPAThreadDetailTableViewCell_Label.alpha = 1.0
            
            newHeight  =    AppDelegate.sharedInstance.heightForView(cell.DPAThreadDetailTableViewCell_Label.text!, font: cell.DPAThreadDetailTableViewCell_Label.font, width: self.screenSize.size.width)
            
            
            if newHeight != CGFloat(self.CellsHeightArray.objectAtIndex(indexPath.row) as! NSNumber)
            {
                self.CellsHeightArray.replaceObjectAtIndex(indexPath.row, withObject:newHeight)
               
                
                // 5
                dispatch_async(dispatch_get_main_queue(),{

                tableView.beginUpdates()
                UIView.animateWithDuration(0.5) {
                    //  cell.contentView.layoutIfNeeded()
                }
                
              //  tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

                tableView.endUpdates()
                }
                )


            }
            
        }
                if self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.Underline.rawValue)  == true
                {
                    var converted = self.resultArray.objectAtIndex(indexPath.row) as! String
                    print(converted)
                    if converted.containsString("[U]") && converted.containsString("[/U]")
                    {
                        converted =   converted.sliceFrom("[U]", to: "[/U]")!
                    }
                    
                    
                    
                    cell.DPAThreadDetailTableViewCell_Label.text =  converted
                    
                    cell.DPAThreadDetailTableViewCell_Label.attributedText = self.normalizeAString( self.resultArray.objectAtIndex(indexPath.row) as! String, indexPath: indexPath,firstTypeArray:[DPAParseBBCodeType.Underline])
                    firstTypeArray.append(DPAParseBBCodeType.Underline)
                    cell.DPAThreadDetailTableViewCell_ImageView.alpha = 0.0
                    cell.DPAThreadDetailTableViewCell_Label.alpha = 1.0
                    newHeight  =    AppDelegate.sharedInstance.heightForView(cell.DPAThreadDetailTableViewCell_Label.text!, font: cell.DPAThreadDetailTableViewCell_Label.font, width: self.screenSize.size.width)
                    
                    if newHeight != CGFloat(self.CellsHeightArray.objectAtIndex(indexPath.row) as! NSNumber)
                    {
                        self.CellsHeightArray.replaceObjectAtIndex(indexPath.row, withObject:newHeight)
                        
                        
                        
                        // 5
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            tableView.beginUpdates()
                            UIView.animateWithDuration(0.5) {
                            }

                            
                            tableView.endUpdates()
                            }
                        )
                        
                        
                    }

                    

        }

        if self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.BoldText.rawValue)  == true
            
        {
            
            

            var converted = self.resultArray.objectAtIndex(indexPath.row) as! String
            print(converted)
            if converted.containsString("[B]") && converted.containsString("[/B]")
            {
                 converted =   converted.sliceFrom("[B]", to: "[/B]")!
            }
           
         
            
            cell.DPAThreadDetailTableViewCell_Label.text =  converted

            cell.DPAThreadDetailTableViewCell_Label.attributedText = self.normalizeAString( self.resultArray.objectAtIndex(indexPath.row) as! String, indexPath: indexPath,firstTypeArray:[DPAParseBBCodeType.BoldText])
              firstTypeArray.append(DPAParseBBCodeType.BoldText)
           
            
            //cell.DPAThreadDetailTableViewCell_Label.text =  self.resultArray.objectAtIndex(indexPath.row) as! String
            
            
           // cell.DPAThreadDetailTableViewCell_Label.attributedText = self.normalizeString(self.resultArray.objectAtIndex(indexPath.row) as! String,indexPath: indexPath)
            

            cell.DPAThreadDetailTableViewCell_ImageView.alpha = 0.0
            cell.DPAThreadDetailTableViewCell_Label.alpha = 1.0
            newHeight  =    AppDelegate.sharedInstance.heightForView(cell.DPAThreadDetailTableViewCell_Label.text!, font: cell.DPAThreadDetailTableViewCell_Label.font, width: self.screenSize.size.width)
            
            if newHeight != CGFloat(self.CellsHeightArray.objectAtIndex(indexPath.row) as! NSNumber)
            {
                self.CellsHeightArray.replaceObjectAtIndex(indexPath.row, withObject:newHeight)
 
           
                
                // 5
                dispatch_async(dispatch_get_main_queue(),{
                    
                    tableView.beginUpdates()
                    UIView.animateWithDuration(0.5) {
                        //  cell.contentView.layoutIfNeeded()
                    }
                    
                    //  tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
                    tableView.endUpdates()
                    }
                )


            }
            
        }
        
        if self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.NormalText.rawValue)  == true
        {
            
           // cell.DPAThreadDetailTableViewCell_Label.attributedText = self.normalizeString(self.resultArray.objectAtIndex(indexPath.row) as! String,indexPath: indexPath)
            cell.DPAThreadDetailTableViewCell_Label.text = self.resultArray.objectAtIndex(indexPath.row) as! String
cell.DPAThreadDetailTableViewCell_Label.text =  self.resultArray.objectAtIndex(indexPath.row) as! String
              //  cell.DPAThreadDetailTableViewCell_Label.attributedText = self.normalizeString( self.resultArray.objectAtIndex(indexPath.row) as! String, indexPath: indexPath,firstType: DPAParseBBCodeType.NormalText)
            
            cell.DPAThreadDetailTableViewCell_ImageView.alpha = 0.0
            cell.DPAThreadDetailTableViewCell_Label.alpha = 1.0
            newHeight  =    AppDelegate.sharedInstance.heightForView(cell.DPAThreadDetailTableViewCell_Label.text!, font: cell.DPAThreadDetailTableViewCell_Label.font, width: self.screenSize.size.width)
            
            
            if newHeight != CGFloat(self.CellsHeightArray.objectAtIndex(indexPath.row) as! NSNumber)
            {
                self.CellsHeightArray.replaceObjectAtIndex(indexPath.row, withObject:newHeight)
          
                // 5
                dispatch_async(dispatch_get_main_queue(),{
                    
                    tableView.beginUpdates()
                    UIView.animateWithDuration(0.5) {
                        //  cell.contentView.layoutIfNeeded()
                    }
                    
                    //  tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
                    tableView.endUpdates()
                    }
                )


            }
            
        }
        if self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.URLLink.rawValue)  == true
        {
            /*
            var converted = self.resultArray.objectAtIndex(indexPath.row) as! String
            let urlLink = converted.sliceFrom("'", to: "'")
            cell.DPAThreadDetailTableViewCell_ImageView.alpha = 0.0
            cell.DPAThreadDetailTableViewCell_Label.alpha = 1.0
            if self.DPALinkDict.objectForKey(indexPath.row) == nil
            {
                self.DPALinkDict.setValue(urlLink, forKey: String(indexPath.row))
            }
            
            converted =  converted.stringByReplacingOccurrencesOfString(urlLink!, withString: "")
            print(converted)
             cell.DPAThreadDetailTableViewCell_Label.text = converted
            newHeight  =    AppDelegate.sharedInstance.heightForView(cell.DPAThreadDetailTableViewCell_Label.text!, font: cell.DPAThreadDetailTableViewCell_Label.font, width: self.screenSize.size.width)
            if newHeight != CGFloat(self.CellsHeightArray.objectAtIndex(indexPath.row) as! NSNumber)
            {
                self.CellsHeightArray.replaceObjectAtIndex(indexPath.row, withObject:newHeight)
                //    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                UIView.animateWithDuration(0.3) {
                    //  cell.contentView.layoutIfNeeded()
                }
                
                // 5
                
                //  tableView.beginUpdates()
                //tableView.endUpdates()
                
            }
*/
            cell.DPAThreadDetailTableViewCell_ImageView.alpha = 0.0
            cell.DPAThreadDetailTableViewCell_Label.alpha = 1.0
                //cell.DPAThreadDetailTableViewCell_Label.text = self.resultArray.objectAtIndex(indexPath.row) as! String
          //  cell.DPAThreadDetailTableViewCell_Label.attributedText =   self.normalizeURLString(self.resultArray.objectAtIndex(indexPath.row) as! String,indexPath: indexPath)
              firstTypeArray.append(DPAParseBBCodeType.URLLink)
            
            
            newHeight  =    AppDelegate.sharedInstance.heightForView(cell.DPAThreadDetailTableViewCell_Label.text!, font: cell.DPAThreadDetailTableViewCell_Label.font, width: self.screenSize.size.width)
            if newHeight != CGFloat(self.CellsHeightArray.objectAtIndex(indexPath.row) as! NSNumber)
            {
                self.CellsHeightArray.replaceObjectAtIndex(indexPath.row, withObject:newHeight)
                //    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                // 5
                dispatch_async(dispatch_get_main_queue(),{
                    
                    tableView.beginUpdates()
                    UIView.animateWithDuration(0.5) {
                        //  cell.contentView.layoutIfNeeded()
                    }
                    
                    //  tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    
                    tableView.endUpdates()
                    }
                )


                
            }

            
        }
        if self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.Image.rawValue)  == true
        {
            
            var converted = self.resultArray.objectAtIndex(indexPath.row) as! String
            print(converted)
            if converted.containsString("[IMG]")
            {
            converted =   converted.sliceFrom("[IMG]", to: "[/IMG]")!
            }
                let imageString =  converted
            
            let url =  NSURL(string: imageString)
            
            cell.DPAThreadDetailTableViewCell_ImageView.sd_setImageWithURL(url, completed: {
                
                (image : UIImage!, error :NSError!,cachetype : SDImageCacheType, url:NSURL!) -> Void in
                
                newHeight = self.screenSize.height * CGFloat(self.DPAThreadDetailViewController_attachImagePercentageToScreenHeight)
                
                if newHeight != CGFloat(self.CellsHeightArray.objectAtIndex(indexPath.row) as! NSNumber)
                {
                    self.CellsHeightArray.replaceObjectAtIndex(indexPath.row, withObject:newHeight)
                    //     tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    // 5
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        tableView.beginUpdates()
                        UIView.animateWithDuration(0.5) {
                            //  cell.contentView.layoutIfNeeded()
                        }
                        
                        //  tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        
                        tableView.endUpdates()
                        }
                    )


                    
                }
            })
            
            cell.DPAThreadDetailTableViewCell_ImageView.alpha = 1.0
            cell.DPAThreadDetailTableViewCell_Label.alpha = 0.0
            
        }
  
        if self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.Attach.rawValue)  == true
        {
            
            var converted = self.resultArray.objectAtIndex(indexPath.row) as! String
            if converted.containsString("[ATTACH]")
            {
            
            converted =   converted.sliceFrom("[ATTACH]", to: "[/ATTACH]")!
           
            }
            let imageString = "http://dieuphapam.net/attachments/" + converted
            
            let url =  NSURL(string: imageString)
            
            cell.DPAThreadDetailTableViewCell_ImageView.sd_setImageWithURL(url, completed: {
                
                (image : UIImage!, error :NSError!,cachetype : SDImageCacheType, url:NSURL!) -> Void in
                
                let ratio =  image.size.height / image.size.width
                
                newHeight =  self.screenSize.width * ratio
                //  newHeight = self.screenSize.height * CGFloat(self.DPAThreadDetailViewController_attachImagePercentageToScreenHeight)
                
                if newHeight != CGFloat(self.CellsHeightArray.objectAtIndex(indexPath.row) as! NSNumber)
                {
                    self.CellsHeightArray.replaceObjectAtIndex(indexPath.row, withObject:newHeight)
                      //   tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    // 5
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        tableView.beginUpdates()
                        UIView.animateWithDuration(0.5) {
                            //  cell.contentView.layoutIfNeeded()
                        }
                        
                        //  tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        
                        tableView.endUpdates()
                        }
                    )


                    
                    
                }
                
                }
            )
            
            
            
            cell.DPAThreadDetailTableViewCell_ImageView.alpha = 1.0
            cell.DPAThreadDetailTableViewCell_Label.alpha = 0.0
        }
        if self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.Image.rawValue)  != true && self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.Attach.rawValue)  != true
        {
            
            if self.bbcodeStrureTypeArray.objectAtIndex(indexPath.row).containsObject(DPAParseBBCodeType.URLLink.rawValue)  == true
            {
                cell.DPAThreadDetailTableViewCell_Label.attributedText =   self.normalizeURLString(self.resultArray.objectAtIndex(indexPath.row) as! String,indexPath: indexPath,firstTypesArray: firstTypeArray)
                
                
            }
            else
            {
                 cell.DPAThreadDetailTableViewCell_Label.attributedText = self.normalizeAString( self.resultArray.objectAtIndex(indexPath.row) as! String, indexPath: indexPath,firstTypeArray: firstTypeArray)
            }
        }


        return cell
        
    }
        func getFirstTags(string:NSMutableString)->(String,String,Bool,String)
    {
        
       if self.checkContainsTagForString(string as String) == false
       {
          return("","",false,"")
        }
        
            var colorvalue = NSMutableString()
            var IscolorValue  = false
            var i  = 0
            while String(string.substringWithRange(NSMakeRange(i, 1))) != "]"
            {
                
                
                if IscolorValue == true
                {
                    colorvalue.appendString(string.substringWithRange(NSMakeRange(i, 1)))
                    
                }
                if string.substringWithRange(NSMakeRange(i, 1)) == "=" && string.containsString("[COLOR=]")
                {
                    IscolorValue  = true
                }
                i++
            }
            i = i + 1
            var tag:NSMutableString =  string.substringToIndex(i) as! NSMutableString
            
            
            
            
            print(tag)
            var     endtag = tag.substringToIndex(1)
            endtag.appendContentsOf("/")
            endtag.appendContentsOf(tag.substringFromIndex(1))
            
            print(endtag)
            
            
            print(tag)
            print(endtag)
            
            if tag.containsString("[COLOR=")
            {
                endtag = "[/COLOR]"
                return(tag as String,endtag,true,colorvalue as String)
            }
            return(tag as String,endtag,true,"")
            
        }
    func checkContainsTagForString(string:String)->Bool
    {
        
        if string.containsString("[URL]") || string.containsString("[B]") ||  string.containsString("[I]") || string.containsString("[COLOR=]") || string.containsString("[CENTER]")
            
        {
            
            return true
            
        }
        
        return false
        
    }
    func normalizeAString(var string:String,indexPath:NSIndexPath,firstTypeArray:[DPAParseBBCodeType])->NSAttributedString
    {
        var normalizedString = NSMutableAttributedString(string: string)
        
        var result = NSMutableArray()
        var structureResult = NSMutableArray()
        var tempString = string
        print(tempString)
        
        for firstType in firstTypeArray
        {
        structureResult.addObject(firstType.rawValue)
        }
        
        if string.containsString("[B]")
        {
            structureResult.addObject(DPAParseBBCodeType.BoldText.rawValue)
            string =  string.stringByReplacingOccurrencesOfString("[B]", withString: "")
            string =  string.stringByReplacingOccurrencesOfString("[/B]", withString: "")
            
        }
        if string.containsString("[COLOR")
        {
            /*
            let valueString =  string.sliceFrom("=#", to: "]")
            let removedString = "[COLOR=#" + valueString! + "]"
                        string =  string.stringByReplacingOccurrencesOfString(removedString, withString: "")
                                    string =  string.stringByReplacingOccurrencesOfString("[/COLOR]", withString: "")
            structureResult.addObject(DPAParseBBCodeType.Color.rawValue)
*/
            
        }
        if string.containsString("[U")
        {
            structureResult.addObject(DPAParseBBCodeType.Underline.rawValue)
            string =  string.stringByReplacingOccurrencesOfString("[U]", withString: "")
            string =  string.stringByReplacingOccurrencesOfString("[U]", withString: "")
        }

        normalizedString = NSMutableAttributedString(string: string as! String)
        
        for codeType in structureResult
        {
            
            if codeType as! Int == DPAParseBBCodeType.Underline.rawValue
            {
                
                normalizedString.addAttribute(NSUnderlineStyleAttributeName,  value : NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, normalizedString.length))
            }
            if codeType as! Int == DPAParseBBCodeType.BoldText.rawValue
            {
                
                
                let boldAttribute = [ NSFontAttributeName: UIFont.boldSystemFontOfSize(14.0) ]
                
                normalizedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(14.0), range: NSMakeRange(0, normalizedString.length))
                
                
              
                
            }
            if  codeType as! Int == DPAParseBBCodeType.Color.rawValue
            {
                
                
                let valueString =  string.sliceFrom("=#", to: "]")

                
                let removedString = "[COLOR=#" + valueString! + "]"
                string =  string.stringByReplacingOccurrencesOfString(removedString, withString: "")
                string =  string.stringByReplacingOccurrencesOfString("[/COLOR]", withString: "")
            
                normalizedString = NSMutableAttributedString(string: string as! String)
                
                                normalizedString.addAttribute(NSForegroundColorAttributeName, value: self.hexStringToUIColor(valueString!), range: NSMakeRange(0, normalizedString.length))

            }

        }
        
        var i = 0
        
        
        return normalizedString

    }
    func normalizeString(string:String,indexPath:NSIndexPath,firstType:DPAParseBBCodeType)->NSAttributedString
    {
        var normalizedString = NSMutableAttributedString(string: string)
        
        var result = NSMutableArray()
        var structureResult = NSMutableArray()
        var tempString = string
        print(tempString)
    
        
        structureResult.addObject(firstType.rawValue)
        
        
        
        let (startTag, endTag,ContainsTagOrNot,colorValue) =  self.getFirstTags(tempString as! NSMutableString)
       
        if ContainsTagOrNot != false || tempString.containsString("'")
        {

        
        while tempString.characters.count > 0
        {
            
            if tempString.containsString("'") && !tempString.containsString("[URL")
            {
                tempString = "[URL]" +  tempString + "[/URL]"
            }
            
         let (startTag, endTag,ContainsTagOrNot,colorValue) =  self.getFirstTags(tempString as! NSMutableString)
            /*
            if startTag == "[URL]"
            {
                let linkValue = tempString.sliceFrom("'", to: "'")
                let removedString =  "'" + linkValue! + "'"
                
             tempString  = tempString.stringByReplacingOccurrencesOfString(removedString, withString: "")
             
             self.DPALinkDict.setObject(linkValue!, forKey: indexPath.row)
            }
            */
        
            if startTag == "[B]"
            {
                
            }
            var convertedbody =  tempString as! String
            let endindex =        tempString.indexOf(endTag as! String)
            let EndintValue = tempString.startIndex.distanceTo(endindex!)
            var  stringlengh = tempString.characters.count + EndintValue
            print(stringlengh)
            print(endTag.characters.count)

            let x = stringlengh - endTag.characters.count
            var checkString =   tempString.substringToIndex(endindex!)
            switch (true) {
            case (checkString.containsString("[ATTACH]")):
                structureResult.addObject(DPAParseBBCodeType.Attach.rawValue)
            case (checkString.containsString("[IMG]")):
                structureResult.addObject(DPAParseBBCodeType.Image.rawValue)
                
            case (checkString.containsString("[CENTER]")):
                structureResult.addObject(DPAParseBBCodeType.CenterText.rawValue)
                
            case (checkString.containsString("[B]")):
                structureResult.addObject(DPAParseBBCodeType.BoldText.rawValue)
            case (checkString.containsString("[URL]")):
                structureResult.addObject(DPAParseBBCodeType.URLLink.rawValue)
            default:
                structureResult.addObject(DPAParseBBCodeType.NormalText.rawValue)
            }
                checkString =  checkString.substringFromIndex(tempString.startIndex.advancedBy(startTag.characters.count))
          
            
            if stringlengh + 1 > convertedbody.characters.count
            {
                tempString = ""
            }
            else
            {
                tempString = convertedbody.substringFromIndex(convertedbody.startIndex.advancedBy(stringlengh + 1)) as! NSMutableString as String
            }
            print(tempString)
            result.addObject(checkString)
        }
        }
        else
        {
                result.addObject(string)
        }

        var i = 0
        normalizedString = NSMutableAttributedString(string: "")
        for string in result
        {
            print(i)
            var string =  string
            if self.checkContainsTagForString(string as! String) == true {
               
            }
            
           var myAttrString = NSMutableAttributedString(string: string as! String)
            if structureResult.objectAtIndex(i) as! Int == DPAParseBBCodeType.URLLink.rawValue
            {
                let linkAttribute = [ NSForegroundColorAttributeName: UIColor.blueColor() ]
               myAttrString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: NSMakeRange(0, myAttrString.length))
                
                result.replaceObjectAtIndex(i, withObject: myAttrString)
                    normalizedString.appendAttributedString(myAttrString)
            }
            if structureResult.objectAtIndex(i) as! Int == DPAParseBBCodeType.BoldText.rawValue
            {
                
                let boldAttribute = [ NSFontAttributeName: UIFont.boldSystemFontOfSize(14.0) ]
                
                   myAttrString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(14.0), range: NSMakeRange(0, myAttrString.length))
                
             
                result.replaceObjectAtIndex(i, withObject: myAttrString)
             print(myAttrString)
                
                 normalizedString.appendAttributedString(myAttrString)
                
            }
             if structureResult.objectAtIndex(i) as! Int != DPAParseBBCodeType.BoldText.rawValue && structureResult.objectAtIndex(i) as! Int != DPAParseBBCodeType.URLLink.rawValue
            
             {
                 myAttrString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(14.0), range: NSMakeRange(0, myAttrString.length))
                
                
                let attString = NSAttributedString(string: result.objectAtIndex(i) as! String)
                normalizedString.appendAttributedString(myAttrString)
            }
            i++
        }
        //right here
        
        
        for i in structureResult
        {
            print(i)
        }

        
        return normalizedString
    }
    
    func getBBCodeParserTag() -> NSArray
    {
        
        let array =  ["B","CENTER","SIZE","URL","ATTACH","LIST"]
        
        return array
    }
   
    func convertbbcodeToNSArray() -> NSArray
    {
        var body:NSMutableString =  exploringThread!.ThreadPosts?.PostBBCodeText as! NSMutableString
        
        var body2 =   body.stringByReplacingOccurrencesOfString("=full", withString: "")
      
        body2 = body2.stringByReplacingOccurrencesOfString("']", withString: "'")
        body2 = body2.stringByReplacingOccurrencesOfString("[URL='", withString: "[URL]'")
        
       //listnormalize
                body2 = body2.stringByReplacingOccurrencesOfString("[LIST]", withString: "")
        body2 = body2.stringByReplacingOccurrencesOfString("[/LIST]", withString: "")
        body2 = body2.stringByReplacingOccurrencesOfString("[*]", withString: "")
        
        var pat2 = "\\[LIST=[0-9]]"
        var regex = try! NSRegularExpression(pattern: pat2, options: [])
        // (4):
        var matches = regex.matchesInString(body2, options: [], range: NSRange(location: 0, length: body2.characters.count))
        
        var verback = 0
        
        for match in matches {
            for n in 0..<match.numberOfRanges {
                let range = match.rangeAtIndex(n)
                let r = body2.startIndex.advancedBy(range.location - verback) ..<
                    
                    body2.startIndex.advancedBy(range.location+range.length - verback)
                
                verback = body2.substringWithRange(r).characters.count
                body2.substringWithRange(r)
                
                body2 =   body2.stringByReplacingOccurrencesOfString(body2.substringWithRange(r)
                    , withString: "")
                
                
                
                
            }
        }
//size config
        var i = 0
        while i < 10
        {
            if body2.containsString(String(format: "[SIZE=%d]", i))
            {
                body2 =   body2.stringByReplacingOccurrencesOfString(String(format: "[SIZE=%d]", i), withString: "")

            }
            i++
        }
        
  body2 = body2.stringByReplacingOccurrencesOfString("[/SIZE]", withString: "")
        print(body2)
        body2 = body2.stringByReplacingOccurrencesOfString("[LEFT]", withString: "")
                body2 = body2.stringByReplacingOccurrencesOfString("[/LEFT]", withString: "")
        body2 = body2.stringByReplacingOccurrencesOfString("[/EMAIL]", withString: "")
        
        body2 = body2.stringByReplacingOccurrencesOfString("[EMAIL]", withString: "")
        
                body2 = body2.stringByReplacingOccurrencesOfString("[media=dieuphapam]", withString: "[media]")


        

        

        //email Normalize
        var pat = "\\[EMAIL='[a-z,0-9]+@[a-z]+.[a-z]+']"
        //pat =
        //"^(\\w+\\s+ID:\\s+)(\\d{3})-(\\d{4})$"
        
         regex = try! NSRegularExpression(pattern: pat,
            options: [])
        // (4):
        
         matches = regex.matchesInString(body2, options: [], range: NSRange(location: 0, length: body2.characters.count))
        // (2):
        
        
         verback = 0
        
        for match in matches {
            for n in 0..<match.numberOfRanges {
                let range = match.rangeAtIndex(n)
                let r = body2.startIndex.advancedBy(range.location - verback) ..<
                    
                    body2.startIndex.advancedBy(range.location+range.length - verback)
                
                verback = body2.substringWithRange(r).characters.count
                body2.substringWithRange(r)
                
                body2 =   body2.stringByReplacingOccurrencesOfString(body2.substringWithRange(r)
                    , withString: "")
                
                
                
            }
        }
        
        
        
        body2 = body2.stringByReplacingOccurrencesOfString("\n\n", withString: "\n")
        
        
       body = body2 as! NSMutableString
        var result = NSMutableArray()
        print(body2)
        
        
        
        while (body.length > 0)
        {
            
            //reloaddata
            
            let firstletter =  body.substringToIndex(1) as! String
            print(firstletter)
            if firstletter == "["
            {
                var i  = 0
                
                while String(body.substringWithRange(NSMakeRange(i, 1))) != "]"
                {
                    i++
                }
                i = i + 1
                var tag:NSMutableString =  body.substringToIndex(i) as! NSMutableString
                
                
                
                
                print(tag)
                var     endtag = tag.substringToIndex(1)
                endtag.appendContentsOf("/")
                endtag.appendContentsOf(tag.substringFromIndex(1))
                
                print(endtag)
                
                
                print(tag)
                print(endtag)
                
                if tag.containsString("[COLOR=")
                {
                    endtag = "[/COLOR]"
                }
                if tag.containsString("[media=")
                {
                    endtag = "[/media]"
                    tag = "[media]"
                }
                
                
                /// at this point
                var convertedbody =  body as! String
                
                let endindex =        convertedbody.indexOf(endtag as! String)
                
                let EndintValue = convertedbody.startIndex.distanceTo(endindex!)
                var  stringlengh = endtag.characters.count + EndintValue
                
                print(stringlengh)
                print(endtag.characters.count)
                print(body)
                let x = stringlengh - endtag.characters.count
                
                
                var checkString =   convertedbody.substringToIndex(endindex!)
                
                
                checkString = checkString.substringFromIndex(checkString.startIndex.advancedBy(tag.length)) as! NSMutableString as String
                print(checkString)
                
                var  array = NSMutableArray()
               
                switch (true) {
                case (tag.containsString("[ATTACH]")):
                        array.addObject(DPAParseBBCodeType.Attach.rawValue)
                      self.bbcodeStrureTypeArray.addObject(array)
                case (tag.containsString("[IMG]")):
                                array.addObject(DPAParseBBCodeType.Image.rawValue)
                     self.bbcodeStrureTypeArray.addObject(array)
                case (tag.containsString("[CENTER]")):
                            array.addObject(DPAParseBBCodeType.CenterText.rawValue)
                     self.bbcodeStrureTypeArray.addObject(array)
                case (tag.containsString("[B]")):
                            array.addObject(DPAParseBBCodeType.BoldText.rawValue)
                     self.bbcodeStrureTypeArray.addObject(array)
                case (tag.containsString("[URL]")):
                    array.addObject(DPAParseBBCodeType.URLLink.rawValue)
                    self.bbcodeStrureTypeArray.addObject(array)
                case (tag.containsString("[U]")):
                    array.addObject(DPAParseBBCodeType.Underline.rawValue)
                    self.bbcodeStrureTypeArray.addObject(array)
                case (tag.containsString("[media]")):
                    array.addObject(DPAParseBBCodeType.Media.rawValue)
                    self.bbcodeStrureTypeArray.addObject(array)

                default:
                        array.addObject(DPAParseBBCodeType.NormalText.rawValue)
                     self.bbcodeStrureTypeArray.addObject(array)
                }

                    var checkBool = false
               
                
                if checkString.containsString("ATTACH") || checkString.containsString("IMG")
                {
                  checkBool =  true
                    var converted =  checkString as! String
                    var removedstring  = ""
                    
                    
                    if checkString.containsString("ATTACH")
                    {
                        converted =   converted.sliceFrom("[ATTACH]", to: "[/ATTACH]")!
                        
                        removedstring  = "[ATTACH]" + converted + "[/ATTACH]"
                        array.addObject(DPAParseBBCodeType.Attach.rawValue)
                        self.bbcodeStrureTypeArray.replaceObjectAtIndex(self.bbcodeStrureTypeArray.count - 1, withObject: array)
                         converted = "[ATTACH]" + converted + "[/ATTACH]"
                        
                    }
                    if checkString.containsString("[IMG]")
                   
                    {
                        converted =   converted.sliceFrom("[IMG]", to: "[/IMG]")!
                        removedstring  = "[IMG]" + converted + "[/IMG]"
                        
                        array.addObject(DPAParseBBCodeType.Image.rawValue)
                     self.bbcodeStrureTypeArray.replaceObjectAtIndex(self.bbcodeStrureTypeArray.count - 1, withObject: array)
                        converted = "[IMG]" + converted + "[/IMG]"
                    }
                    
                    print("------------------------")
                    
                    print(converted)
                    
                    
                    result.addObject(converted)
                    
                    
                    
                    
                    let body2 =   body.stringByReplacingOccurrencesOfString(removedstring, withString: "")
                    body  = body2 as! NSMutableString
                    
                    convertedbody = body2
                    stringlengh = stringlengh - removedstring.characters.count
                    checkString = checkString.stringByReplacingOccurrencesOfString(removedstring, withString: "")
                }
                
            
                
                
                var addedString =  convertedbody.substringToIndex(convertedbody.startIndex.advancedBy(stringlengh))
                
               
                addedString = checkString
                
                print(addedString)
                if tag.containsString("[URL]")
                { checkBool =  true
                    if addedString.containsString("'")
                    {
                   let urlString  =  addedString.sliceFrom("'" as String, to: "'")!
                    let removedString = ("''" as String) + urlString + "''"
                    self.DPALinkDict.setValue(removedString, forKey: String(self.bbcodeStrureTypeArray.count - 1))
                    addedString = addedString.stringByReplacingOccurrencesOfString(removedString, withString: "")
                     self.bbcodeStrureTypeArray.lastObject!.addObject(DPAParseBBCodeType.URLLink.rawValue)
                    
                    
                    }
                    self.DPALinkDict.setValue(addedString, forKey: String(self.bbcodeStrureTypeArray.count - 1))
                    result.addObject(addedString)
                    addedString = ""
                    
                }
                
                
                while self.checkContainsTagForString(addedString)
                {
                  checkBool =  true
                  
                    let convertedaddedString = addedString as! NSMutableString
                    
                    
                    var i  = addedString.startIndex.distanceTo(addedString.indexOf("[")!)
               
                    while String(convertedaddedString.substringWithRange(NSMakeRange(i, 1))) != "]"
                    {
                        i++
                    }
                    i = i + 1
                    var tag:NSMutableString =  convertedaddedString.substringWithRange(NSMakeRange(addedString.startIndex.distanceTo(addedString.indexOf("[")!), i-addedString.startIndex.distanceTo(addedString.indexOf("[")!))) as! NSMutableString
                    
                    
                    
                    
                    print(tag)
                    var     endtag = tag.substringToIndex(1)
                    endtag.appendContentsOf("/")
                    endtag.appendContentsOf(tag.substringFromIndex(1))
                    
                    print(endtag)
                    
                 
                    
                    print(tag)
                    print(endtag)
                    
                    if tag.containsString("[COLOR=")
                    {
                        endtag = "[/COLOR]"
                    }
                    
                 let subaddedSTring =    addedString.sliceFrom(tag as String, to: endtag)
                   
                   let endIndexOfEndTag =  endtag.characters.count +  addedString.startIndex.distanceTo(addedString.indexOf(endtag)!)
                    
                    
                    if endIndexOfEndTag == convertedaddedString.length
                    {
                        addedString =  addedString.sliceFrom(tag as String, to: endtag)!
                       if self.checkContainsTagForString(addedString) == false
                       {
                        result.addObject(addedString)
                        addedString = ""

                        }
                        switch (true) {
                        case (tag.containsString("[ATTACH]")):
                            array.addObject(DPAParseBBCodeType.Attach.rawValue)
                          // self.bbcodeStrureTypeArray.lastObject!.addObject(DPAParseBBCodeType.Attach.rawValue)
                        case (tag.containsString("[IMG]")):
                            array.addObject(DPAParseBBCodeType.Image.rawValue)
                         //   self.bbcodeStrureTypeArray.lastObject!.addObject(DPAParseBBCodeType.Image.rawValue)
                        case (tag.containsString("[CENTER]")):
                            array.addObject(DPAParseBBCodeType.CenterText.rawValue)
                           // self.bbcodeStrureTypeArray.lastObject!.addObject(DPAParseBBCodeType.CenterText.rawValue)
                        case (tag.containsString("[B]")):
                            array.addObject(DPAParseBBCodeType.BoldText.rawValue)
                          //  self.bbcodeStrureTypeArray.lastObject!.addObject(DPAParseBBCodeType.BoldText.rawValue)
                            
                        case (tag.containsString("[COLOR")):
                            array.addObject(DPAParseBBCodeType.Color.rawValue)
                        case (tag.containsString("[URL]")):
                            array.addObject(DPAParseBBCodeType.URLLink.rawValue)
                        case (tag.containsString("[media]")):
                            array.addObject(DPAParseBBCodeType.Media.rawValue)
                            

                        case (tag.containsString("[U]")):
                            array.addObject(DPAParseBBCodeType.Underline.rawValue)
                            self.bbcodeStrureTypeArray.addObject(array)

                        default:
                            array.addObject(DPAParseBBCodeType.NormalText.rawValue)
                            //self.bbcodeStrureTypeArray.lastObject!.addObject(DPAParseBBCodeType.NormalText.rawValue)
                        }
                        
                        
                    }
                    else
                    {
                        
                         result.addObject(subaddedSTring!)
                        
                        switch (true) {
                        case (addedString.containsString("[ATTACH]")):
                            
                            self.bbcodeStrureTypeArray.addObject(array)
                            self.bbcodeStrureTypeArray.lastObject!.addObject(DPAParseBBCodeType.Attach.rawValue)

                        case (addedString.containsString("[IMG]")):
                            self.bbcodeStrureTypeArray.addObject(array)
                            self.bbcodeStrureTypeArray.lastObject!.addObject(DPAParseBBCodeType.Image.rawValue)

                            
                        case (addedString.containsString("[CENTER]")):
                            self.bbcodeStrureTypeArray.addObject(array)
                            self.bbcodeStrureTypeArray.lastObject!.addObject(DPAParseBBCodeType.CenterText.rawValue)
                            
                        case (addedString.containsString("[B]")):
                            self.bbcodeStrureTypeArray.addObject(array)
                            self.bbcodeStrureTypeArray.lastObject!.addObject(DPAParseBBCodeType.BoldText.rawValue)
                        case (tag.containsString("[U]")):
                            array.addObject(DPAParseBBCodeType.Underline.rawValue)
                            self.bbcodeStrureTypeArray.addObject(array)
                        case (tag.containsString("[media]")):
                            array.addObject(DPAParseBBCodeType.Media.rawValue)
                            self.bbcodeStrureTypeArray.addObject(array)


                        default:
                            self.bbcodeStrureTypeArray.addObject(array)
                            self.bbcodeStrureTypeArray.lastObject!.addObject(DPAParseBBCodeType.NormalText.rawValue)
                            
                        }
                        let removedString = (tag as String) + subaddedSTring! + endtag
                        
                                addedString = addedString.stringByReplacingOccurrencesOfString(removedString, withString: "")
                    }
                    
                  
                }
                
                
                
                if stringlengh + 1 > convertedbody.characters.count
                    
                {
                    
                    body = ""
                }
                else
                {
                body = convertedbody.substringFromIndex(convertedbody.startIndex.advancedBy(stringlengh + 1)) as! NSMutableString
                }
                print(body)
                
                                result.addObject(addedString)
                
                
                if checkBool ==  true
                {
                switch (true) {
                case (addedString.containsString("[ATTACH]")):
                    
                    self.bbcodeStrureTypeArray.addObject(NSMutableArray(array: [DPAParseBBCodeType.Attach.rawValue]))
                    
                case (addedString.containsString("[IMG]")):
           self.bbcodeStrureTypeArray.addObject(NSMutableArray(array: [DPAParseBBCodeType.Image.rawValue]))
                case (addedString.containsString("[media]")):
                    self.bbcodeStrureTypeArray.addObject(NSMutableArray(array: [DPAParseBBCodeType.Media.rawValue]))
                case (addedString.containsString("[CENTER]")):
                    self.bbcodeStrureTypeArray.addObject(NSMutableArray(array: [DPAParseBBCodeType.CenterText.rawValue]))
                    
                case (addedString.containsString("[B]")):
                self.bbcodeStrureTypeArray.addObject(NSMutableArray(array: [DPAParseBBCodeType.BoldText.rawValue]))
                case (tag.containsString("[U]")):
                    array.addObject(DPAParseBBCodeType.Underline.rawValue)
                    self.bbcodeStrureTypeArray.addObject(array)

                default:
                    self.bbcodeStrureTypeArray.addObject(NSMutableArray(array: [DPAParseBBCodeType.NormalText.rawValue]))

            
                    }
                
                }
                
            }
            else
            {
                var i  = 0
                while String(body.substringWithRange(NSMakeRange(i, 1))) != "[" && i < body.length - 1
                {
                    i++
                    
                }
                
                let addedString =    body.substringToIndex(i)
                result.addObject(addedString)
                if i + 1 >= body.length
                {
                    i = i + 1
                    result.replaceObjectAtIndex(result.count - 1, withObject: body.substringToIndex(i))
                }
         
                body = body.substringFromIndex(i) as! NSMutableString
                self.bbcodeStrureTypeArray.addObject(NSMutableArray(array: [DPAParseBBCodeType.NormalText.rawValue]))
                
                
                
                
                
                
            }
            
        }
        return result
        
        
    }
    
    func selfAssignAString()
        
    {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    

    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}
extension String {
    func sliceFrom(start: String, to: String) -> String? {
        return (rangeOfString(start)?.endIndex).flatMap { sInd in
            (rangeOfString(to, range: sInd..<endIndex)?.startIndex).map { eInd in
                substringWithRange(sInd..<eInd)
            }
        }
    }
}

