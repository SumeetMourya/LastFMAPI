//
//  SavedAlbumCell.swift
//  DemoApp
//
//  Created by sumeet mourya on 24/03/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import AlamofireImage

class SavedAlbumCell: BaseCollectionCell {
    
    static let identifier = "SavedAlbumCellID"
    
    @IBOutlet var shadowContainer: UIView!
    @IBOutlet var nameOfAlbum: UILabel!
    @IBOutlet var nameOfArtist: UILabel!
    @IBOutlet var coverImageOfAlbum: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        TableCellUtils.createShadow(cardLayer: layer, contentLayer: shadowContainer.layer, shadowOffset: CGSize(width: 0, height: 4), shadowRadius: 4.0)
    }
    
    func bindDataToUI() {
        nameOfAlbum.text = "asdfsdaf "
        nameOfArtist.text = "sdaf sdf df "
        
        //        coverImageOfAlbum.af_setImage(withURL: URL() imageTransition = .crossDissolve(50))
    }
    
}
