//
//  LoaderView.swift
//  DemoApp
//
//  Created by sumeet mourya on 24/03/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation
import PKHUD

protocol LoaderView: class {
    func showActivityIndicator()
    func hideActivityIndicator()
    func hideActivityIndicatorWithError(title: String?, subtitle: String?)
}

extension LoaderView where Self: UIViewController {
    
    func showActivityIndicator() {
        DispatchQueue.main.async() {
            HUD.show(.progress)
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async() {
            HUD.hide()
        }
    }
    
    func hideActivityIndicatorWithError(title: String?, subtitle: String?) {
        DispatchQueue.main.async() {
            HUD.flash(.labeledError(title: title, subtitle: subtitle), delay: 3.0)
        }
    }
    
}
