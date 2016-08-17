//
//  DPAViewController.swift
//  DiepPhapAm
//
//  Created by Mac on 8/16/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation
import UIKit



class DPAViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    
    @IBOutlet weak var ResourceCollectionView: UICollectionView!
    
    let link = "http://dieuphapam.net/appforo/index.php?resource-categories"
    var currentCat = 0
    var currentPage = 1
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    var resourceArray:NSMutableArray?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //self.ResourceCollectionView.registerClass(ResourceCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.ResourceCollectionView.registerNib(UINib(nibName: "ResourceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.ResourceCollectionView.delegate = self
        self.ResourceCollectionView.dataSource = self
        
        DpaAPI.shareInstance.requestForResource({
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
      return  10.0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        /*CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        float cellWidth = screenWidth / 3.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
        CGSize size = CGSizeMake(cellWidth, cellWidth);
        
        return size;
        
*/
        
        var screenRect = UIScreen.mainScreen().bounds
        var screenWidth =  screenRect.size.width
        var cellWidth =  screenWidth/2.0 - 20.0
        
        
        
        let size = CGSizeMake(cellWidth, cellWidth + 50.0)
        return size
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }

     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
     {
        
      let cell =  collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ResourceCollectionViewCell
        
        let resouce =  self.resourceArray?.objectAtIndex(indexPath.row) as! DPAResource
        print(resouce.resourceTitle)
        
        cell.ResourceTitle.text =  resouce.resourceTitle
        
        
    cell.ResourceBookName.text =  resouce.resourceDescription
        print(resouce.resourceDescription)
        
        return cell

    }

}


