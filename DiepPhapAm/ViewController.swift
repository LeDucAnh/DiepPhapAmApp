//
//  ViewController.swift
//  DiepPhapAm
//
//  Created by Mac on 8/16/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sidebarbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let revealVC = self.revealViewController()
            self.sidebarbutton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: UIControlEvents.TouchUpInside)
            
                

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

