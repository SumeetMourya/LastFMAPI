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
        
        TableCellUtils.createShadow(cardLayer: layer, contentLayer: shadowContainer.layer, shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 5.0)
    }
    
    func bindDataToUI(data: SearchAlbumArtistDataItem) {

        if let albumName = data.albumName {
            nameOfAlbum.text = albumName
        } else {
            nameOfAlbum.text = ""
        }
        
        if let artistName = data.artistName {
            nameOfArtist.text = "By - \(artistName)"
        } else {
            nameOfArtist.text = ""
        }
        
        if let urlStringValue = data.albumCoverLargeImageURL, let urlObject = URL(string: urlStringValue) {
            coverImageOfAlbum.af_setImage(withURL: urlObject, placeholderImage: UIImage(named: "albumPlaceHolder")!)
        } else {
            coverImageOfAlbum.image = UIImage(named: "albumPlaceHolder")!
        }
                
    }
    
}
