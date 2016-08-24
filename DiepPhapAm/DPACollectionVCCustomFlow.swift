//
//  DiepPhapAmCollectionVCCustomFlow.swift
//  DiepPhapAm
//
//  Created by Mac on 8/17/16.
//  Copyright © 2016 LeDucAnh. All rights reserved.
//

import Foundation
import UIKit
class  DDPACollectionVCCustomFlow:UICollectionViewFlowLayout
    
    
{


  
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 10.0
        scrollDirection = .Vertical
    }
   
    override var itemSize: CGSize {
        set {
            
        }
        get {
            
            
            var  numberOfColumns: CGFloat = 2.0


            if UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft || UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight
            {
            numberOfColumns = 3
            }
            

            let itemWidth = (CGRectGetWidth(self.collectionView!.frame) - (numberOfColumns - 1)) / numberOfColumns  - 15.0
            
            return CGSizeMake(itemWidth, itemWidth+60.0)
            
        }
    }

}