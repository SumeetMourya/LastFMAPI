//
//  StringExtension.swift
//  DemoApp
//
//  Created by sumeet mourya on 03/04/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation
import UIKit


public extension String {
    
    public func heightForWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let rect = NSString(string: self).boundingRect(
            with: CGSize(width: width, height: CGFloat(MAXFLOAT)),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        return ceil(rect.height)
    }
    
}
