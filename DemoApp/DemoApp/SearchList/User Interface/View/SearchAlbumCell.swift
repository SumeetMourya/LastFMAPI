//
//  SearchAlbumCell.swift
//  DemoApp
//
//  Created by sumeet mourya on 24/03/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation

import UIKit
import AlamofireImage

class SearchAlbumCell: BaseTableCell {
    
    static let identifier = "SearchAlbumCellID"
    
    @IBOutlet var shadowContainer: UIView!
    @IBOutlet var nameOfAlbum: UILabel!
    @IBOutlet var coverImageOfAlbum: UIImageView!
    @IBOutlet var layoutAddedImageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        TableCellUtils.createShadow(cardLayer: layer, contentLayer: shadowContainer.layer, shadowOffset: CGSize(width: 0, height: 4), shadowRadius: 4.0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindDataToUI(data: SearchArtistDataItem) {
        
        nameOfAlbum.text = data.artistName
        if let urlStringValue = data.artistLargeImageURL, let urlObject = URL(string: urlStringValue) {
            coverImageOfAlbum.af_setImage(withURL: urlObject, placeholderImage: UIImage(named: "profileicon")!)
        }
    }
    
}
