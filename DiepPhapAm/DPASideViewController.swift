//
//  DPASideViewController.swift
//  DiepPhapAm
//
//  Created by Mac on 8/18/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation
import UIKit
import SWRevealViewController
class DPASideViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    

    @IBOutlet weak var TableView: UITableView!
    var currentSelected = 0
    var menuArray =  ["Thư Viện","Đăng Nhập","Yêu Thích","Cài Đặt"]
    var menuImaname = ["home.png","login.png","favorite.png","setting.png"]
    var tapGesture:UITapGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TableView.registerNib(UINib(nibName: "DPASideMenuTableViewCell", bundle: nil) , forCellReuseIdentifier: "Cell")
        //self.TableView.registerNib(UINib(nibName: "ResourceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.TableView.delegate = self
        
        self.TableView.dataSource = self
               
        
    }
    func presentVCWithIndex(index:Int)
    {
        if index == 1
        {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let rootVC  =
            
            storyboard.instantiateViewControllerWithIdentifier("UIViewController") as! UIViewController
            self.revealViewController().pushFrontViewController(rootVC, animated: true)
            return
        }
        
        if index == 2
        {
            
            self.revealViewController().pushFrontViewController(AppDelegate.sharedInstance.DPAFavoriteVC, animated: true)
            
            
            
            return
            
        }
            
        else
        {
            
            self.revealViewController().pushFrontViewController(AppDelegate.sharedInstance.DPATabbarVC, animated: true)
            
            return
            
        }
        

    }
    
    //tapGesture
    func handleTap(sender: UITapGestureRecognizer)
    {
        self.RemoveTapGestureForcurrentSelectedVC()
        self.presentVCWithIndex(self.currentSelected)
        
    }
    func addTapGestureForcurrentSelectedVC()
    {
        
       
        
        
        
        
        self.tapGesture = UITapGestureRecognizer(target: self, action : "handleTap:")
        tapGesture!.numberOfTapsRequired = 1
        
 
     
        
        
        if currentSelected == 0
        {
           AppDelegate.sharedInstance.DPAViewVC.view.addGestureRecognizer(tapGesture!)
        }
        if currentSelected == 2
        {
            AppDelegate.sharedInstance.DPAFavoriteVC.view.addGestureRecognizer(tapGesture!)
        }
    }
    func RemoveTapGestureForcurrentSelectedVC()
    {
        if currentSelected == 0
        {
            AppDelegate.sharedInstance.DPAViewVC.view.removeGestureRecognizer(self.tapGesture!)
        }
        if self.currentSelected == 2
        {
            AppDelegate.sharedInstance.DPAFavoriteVC.view.removeGestureRecognizer(self.tapGesture!)
            
        }

    }
    override func viewWillAppear(animated: Bool) {
        self.TableView.reloadData()
        self.addTapGestureForcurrentSelectedVC()
    }
    override func viewWillDisappear(animated: Bool) {
        
    }
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int {

    return 4
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.TableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        /*
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SecondViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        [navController setViewControllers: @[rootViewController] animated: YES];
        
        [self.revealViewController setFrontViewController:navController];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        */
       
         self.RemoveTapGestureForcurrentSelectedVC()
        self.currentSelected = indexPath.row
        
        self.presentVCWithIndex(indexPath.row)
        return
        
        if indexPath.row == 1
        {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let rootVC  =
            
            storyboard.instantiateViewControllerWithIdentifier("UIViewController") as! UIViewController
                        self.revealViewController().pushFrontViewController(rootVC, animated: true)
            return
        }
            
        if indexPath.row == 2
        {
            
            self.revealViewController().pushFrontViewController(AppDelegate.sharedInstance.DPAFavoriteVC, animated: true)
        
            

            return

        }
            
        else
        {
            
            self.revealViewController().pushFrontViewController(AppDelegate.sharedInstance.DPATabbarVC, animated: true)
           
            return
            
        }
        

       
   
        

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCellWithIdentifier("Cell") as! DPASideMenuTableViewCell
        cell.DPASideMenuTableViewCellTitleLabel.text = self.menuArray[indexPath.row]
        cell.DPASideMenuTableViewCellTitleLabel.textColor = UIColor.darkGrayColor()
        cell.DPASideMenuTableViewCellMenuImgView.image = UIImage(named: self.menuImaname[indexPath.row])?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        cell.DPASideMenuTableViewCellMenuImgView.tintColor = UIColor.darkGrayColor()
        
        if indexPath.row ==  self.currentSelected
        {
                    cell.DPASideMenuTableViewCellTitleLabel.textColor = AppDelegate.sharedInstance.DPARed
            
                                   cell.DPASideMenuTableViewCellMenuImgView.tintColor         = AppDelegate.sharedInstance.DPARed
        }
        return cell
        

        
    }
    
}
