//
//  AlbumCell.swift
//  DemoApp
//
//  Created by sumeet mourya on 23/03/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import AlamofireImage

class AlbumCell: BaseCollectionCell {
    
    static let identifier = "AlbumCellID"
    
    @IBOutlet var shadowContainer: UIView!
    @IBOutlet var nameOfAlbum: UILabel!
    @IBOutlet var nameOfArtist: UILabel!
    @IBOutlet var coverImageOfAlbum: UIImageView!
    @IBOutlet var addedIcon: UIImageView!
//    @IBOutlet var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        TableCellUtils.createShadow(cardLayer: layer, contentLayer: shadowContainer.layer, shadowOffset: CGSize(width: 0, height: 5), shadowRadius: 5.0)
        
//        let screenWidth = UIScreen.main.bounds.size.width
//        widthConstraint.constant = (screenWidth - 45) / 2
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
            coverImageOfAlbum.image = UIImage(named: "albumPlaceHolder")
        }
        
        addedIcon.isHidden = !data.albumSaved
    }

}
