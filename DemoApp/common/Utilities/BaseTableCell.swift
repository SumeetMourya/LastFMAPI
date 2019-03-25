//
//  BaseTableCell.swift
//  DemoApp
//
//  Created by sumeet mourya on 23/03/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class BaseTableCell: UITableViewCell {
    
    var isPressed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(pressed: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(pressed: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(pressed: false)
    }
    
    internal func animate(pressed isPressed: Bool) {
        if isPressed {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: [.beginFromCurrentState],
                           animations: {
                            self.transform = .init(scaleX: 0.95, y: 0.95)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: [.allowUserInteraction],
                           animations: {
                            self.transform = .identity
            }, completion: nil)
        }
    }
}

class BaseCollectionCell: UICollectionViewCell {
    
    var isPressed = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(pressed: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(pressed: false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(pressed: false)
    }
    
    internal func animate(pressed isPressed: Bool) {
        if isPressed {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: [.beginFromCurrentState],
                           animations: {
                            self.transform = .init(scaleX: 0.95, y: 0.95)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: [.allowUserInteraction],
                           animations: {
                            self.transform = .identity
            }, completion: nil)
        }
    }
}
