
//
//  AppDelegate.swift
//  DiepPhapAm
//
//  Created by Mac on 8/16/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate , NSXMLParserDelegate{

    public enum  DPAParseBBCodeType: Int {
        case Image
        case Attach
        case BoldText
        case CenterText
        case  NormalText// iPhone and iPod touch style UI
        
    }
    var  bbcodeStrureTypeArray = NSMutableArray()
    var resultArray = NSMutableArray()

    
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
    var date = NSMutableString()
  
    
    
    static let sharedInstance = AppDelegate()
    var DPARed = UIColor(red: 99/255, green: 2/255, blue: 8/255, alpha: 1.0)
    var window: UIWindow?
    var DPATabbarVC:UITabBarController?
    var DPAViewVC:DPAViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DPAViewController") as! DPAViewController
    var DPAFavoriteVC:DPAFavoriteViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DPAFavoriteViewController") as! DPAFavoriteViewController
    
    
    var DPAMainTabbarVC:UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DPAMainUITabbarController") as! UITabBarController

    
    
    func beginParsing(string:String)
    {
        print(string)
        
        posts = []
    parser =    NSXMLParser(data: string.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        //parser = NSXMLParser(contentsOfURL:(NSURL(string:"http://images.apple.com/main/rss/hotnews/hotnews.rss"))!)!
        parser.delegate = self
        parser.parse()
        //     tbData!.reloadData()
        
        
        for x in self.posts
        {
            print(x)
        }
    }
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        element = elementName
        if (elementName as NSString).isEqualToString("CENTER")
        {
            elements = NSMutableDictionary()
            elements = [:]
            title1 = NSMutableString()
            title1 = ""
            date = NSMutableString()
            date = ""
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!)
    {
        if element.isEqualToString("title") {
            title1.appendString(string)
        } else if element.isEqualToString("pubDate") {
            date.appendString(string)
        }
    }
    func convertbbcodeToNSArray() -> NSArray
    {
        var body:NSMutableString = "[CENTER]Đã lợp ngói- Nhìn từ cổng tam quan vào[/CENTER]"
        
        
        let body2 =   body.stringByReplacingOccurrencesOfString("=full", withString: "")
        body = body2 as! NSMutableString
        var result = NSMutableArray()
        print(body2)
        
        
        
        while (body.length > 0)
        {
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
                
                /*
                if tag == "[ATTACH]" && endtag == "[/ATTACH]"
                {
                
                }*/
                /// at this point
                let convertedbody =  body as! String
                
                let endindex =        convertedbody.indexOf(endtag as! String)
                
                let EndintValue = convertedbody.startIndex.distanceTo(endindex!)
                var  stringlengh = endtag.characters.count + EndintValue
                
                
                var checkString =  body.substringToIndex(stringlengh - endtag.characters.count) as! NSMutableString
                checkString = checkString.substringFromIndex(tag.length) as! NSMutableString
                print(checkString)
                if checkString.containsString("ATTACH") || checkString.containsString("IMG")
                {
                    var converted =  checkString as! String
                    var removedstring  = ""
                    
                    
                    if checkString.containsString("ATTACH")
                    {
                        converted =   converted.sliceFrom("[ATTACH]", to: "[/ATTACH]")!
                        removedstring  = "[ATTACH]" + converted + "[/ATTACH]"
                      
                        self.bbcodeStrureTypeArray.addObject(NSMutableArray(array: [DPAParseBBCodeType.Attach.rawValue]))

                    }
                    else
                    {
                        converted =   converted.sliceFrom("[IMG]", to: "[/IMG]")!
                        removedstring  = "[IMG]" + converted + "[/IMG]"
                        self.bbcodeStrureTypeArray.addObject(NSMutableArray(array: [DPAParseBBCodeType.Image.rawValue]))
                        

                       
                    }
                    
                    print("------------------------")
                    
                    print(converted)
                    
                    result.addObject(converted)
                    
                    
                    
                    
                    let body2 =   body.stringByReplacingOccurrencesOfString(removedstring, withString: "")
                    body  = body2 as! NSMutableString
                    stringlengh = stringlengh - removedstring.characters.count
                }
                
               
                let addedString =    body.substringToIndex(stringlengh)
                
                print(addedString)
                
                
                body = body.substringFromIndex(stringlengh + 1) as! NSMutableString
                print(body)
                result.addObject(addedString)
                
                
                switch (true) {
                case (addedString.containsString("[ATTACH]")):
                    self.bbcodeStrureTypeArray.addObject(DPAParseBBCodeType.Attach.rawValue)
                case (addedString.containsString("[IMG]")):
                    self.bbcodeStrureTypeArray.addObject(DPAParseBBCodeType.Image.rawValue)
                    
                case (addedString.containsString("[CENTER]")):
                    self.bbcodeStrureTypeArray.addObject(DPAParseBBCodeType.CenterText.rawValue)
                case (addedString.containsString("[B]")):
                    self.bbcodeStrureTypeArray.addObject(DPAParseBBCodeType.BoldText.rawValue)
                    
                default:
                    self.bbcodeStrureTypeArray.addObject(DPAParseBBCodeType.NormalText.rawValue)
                }
                
                
                if checkString.containsString("ATTACH")
                {
                    
                }
                if checkString.containsString("IMG")
                {
                    
                }
                if checkString.containsString("CENTER")
                {
                    
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
                }
                body = body.substringFromIndex(i) as! NSMutableString
                self.bbcodeStrureTypeArray.addObject(DPAParseBBCodeType.NormalText.rawValue)
                
                
                
                
                
            }
            
        }
        return result
        
        
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        // Override point for customization after application launch.
      
        
        var x = "[CENTER]Đã lợp ngói- Nhìn từ cổng tam quan vào[/CENTER]\n" as! NSMutableString
        
        
        
    print(x.substringToIndex(55 - 9))
        
        self.resultArray =     self.convertbbcodeToNSArray() as! NSMutableArray
        for element  in resultArray
        {
            print(element)
            
        }
        for element  in self.bbcodeStrureTypeArray
        {
            print(element)
        }
        

        
        var body = "Nam Mô Bổn Sư Thích Ca Mâu Ni Phật\n\nNhờ Tam Bảo, Quý Thầy, Quí Sư Cô, Quí Phật tử phát lòng ủng hộ công trình kiến tạo ngôi Chánh điện và Trường quay nên tiến độ xây dựng diễn ra thuận lợi và nhanh chóng.\n\nTính đến nay 12/8/2016, Trung tâm đã nhận tịnh tài đóng góp của Phật tử trong và ngoài nước là [B]1,068,304,200 VND và 164 bao xi măng, Trung tâm đã mua vật liệu và tạm ứng cho nhà Thầu  là 1,423,390,000 VND (một tỷ bốn trăm hai mươi ba triệu ba trăm chín mươi nghìn đồng).[/B]\n\nSau đây, xin chia sẻ những hình ảnh diễn tiến xây dựng Chánh Điện và Trường quay DPA:\n[ATTACH=full]324[/ATTACH]\n[CENTER]Đã lợp ngói- Nhìn từ cổng tam quan vào[/CENTER]\n[ATTACH=full]325[/ATTACH]\n[CENTER]Từ cổng tam quan nhìn bên trái[/CENTER]\n[ATTACH=full]326[/ATTACH]\n[CENTER]Nhìn từ ngoài cổng bên phải\nThưa Quí vị Hữu duyên, công trình khi hoàn thành sẽ là nơi sản xuất, nơi làm ra những chương trình phổ biến lời Phật dạy, cải hóa lòng người, làm đường hướng tu tập cho bao chúng sinh.[/CENTER]\n\nThưa quí vị, đồng tâm nguyện cao quí đó, cho đến thời điểm hiện tại, quý Thầy đã nhận được sự phát tâm đóng góp tịnh tài của Phật tử trong và ngoài nước.\n\nNhờ vậy đã tiến hành xây dựng được gần 2 phần 3 công trình. Quý Thầy rất mong công trình Phật sự quan trọng và cần thiết cho việc hoằng dương Phật pháp này  được hoàn thành. Quý Thầy Trung Tâm tiếp tục kêu gọi quí Phật tử, quí vị hảo tâm phát lòng ủng hộ.\n\n[B]Nơi tiếp nhận cúng dường:[/B]\nGởi trực tiếp: Trung Tâm\nChùa Khuông Việt 1355 Hoàng Sa, P5, Tân Bình, TPHCM\nĐT: 08.39934238 gặp Thầy Minh Thiền.\n\n[B]Hoặc chuyển khoản:[/B]\nGhi rõ Ủng hộ xây dựng\n\nTên tài khoản: Lê Minh Quý\nSố tài khoản: 6480205059030\nNgân hàng: Agribank, Chi Nhánh 11, TP.HCM\n\nTên tài khoản: Lê Minh Quý\nSố tài khoản: 0331000441094\nNgân hàng: Vietcombank, PGD Lạc Long Quân, TP.HCM\n\n[B]Hay qua Tài khoản Paypal:[/B]\nPaypal ID: [EMAIL]paypal@dieuphapam.net[/EMAIL]\n\nThay mặt Trung Tâm chân thành niệm ân và kêu gọi các vị cùng góp tay với Quý Thầy để Phật pháp đến với nhiều người hơn.\n\nNam Mô Công Đức Lâm Bồ Tát Ma Ha Tát\nTrung tâm DPA"


        
        body =  body.stringByReplacingOccurrencesOfString("[CENTER]", withString: "<CENTER><CENTER")
     
        body =  body.stringByReplacingOccurrencesOfString("</CENTER]", withString: "></CENTER></CENTER>")
        self.beginParsing(body)
        
       
               print(body)
        print(body.indexOf("[CENTER]"))
        
        
        

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        /*
        if self.DPAFavoriteVC == nil
        {
            self.DPAFavoriteVC = storyboard.instantiateViewControllerWithIdentifier("DPAFavoriteViewController") as! DPAFavoriteViewController
            DPAFavoriteViewController
            
        }
*/
        
        /*
        if self.DPAViewVC == nil
        {
            self.DPAViewVC = storyboard.instantiateViewControllerWithIdentifier("DPAViewController") as! DPAViewController
            
            
            
        }
        */

        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "LeDucAnh.DiepPhapAm" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("DiepPhapAm", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    public  func heightForComment(font: UIFont, width: CGFloat,comment :String) -> CGFloat {
        
        let rect = NSString(string: comment).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
    
 
    
    func heightForView(var text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }

  


}

