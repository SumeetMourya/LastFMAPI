//
//  TableCellLayer.swift
//  DemoApp
//
//  Created by sumeet mourya on 23/03/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class TableCellUtils {
    
    class func createShadow(cardLayer: CALayer, contentLayer: CALayer, shadowOffset: CGSize = CGSize(width: 0, height: 1), shadowRadius: CGFloat = 3, shadowOpacity: Float = 0.2, cornerRadiusValue: CGFloat = 12) {
        
        cardLayer.shadowColor = UIColor.black.cgColor;
        cardLayer.masksToBounds = false;
        cardLayer.shadowOffset = shadowOffset
        cardLayer.shadowRadius = shadowRadius;
        cardLayer.shadowOpacity = shadowOpacity;
        cardLayer.cornerRadius = cornerRadiusValue;
        cardLayer.shouldRasterize = true;
        cardLayer.rasterizationScale = UIScreen.main.scale;
        
        contentLayer.masksToBounds = true;
        contentLayer.cornerRadius = cornerRadiusValue;
        contentLayer.shouldRasterize = true;
        contentLayer.rasterizationScale = UIScreen.main.scale;
        
    }
    
}
