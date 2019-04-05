//
//  SavedAlbumListView.swift
//  Demo
//
//  Created by sumeet mourya on 03/24/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit

class SavedAlbumListViewController: UIViewController, SavedAlbumListViewProtocol, ArtistSearchScreenDelegate {
    
    var presenter: SavedAlbumListPresenterProtocol?
    var listOfAlbumsData = [SearchAlbumArtistDataItem]()
    
    @IBOutlet var cvSavedAlbumList: UICollectionView!
    @IBOutlet var statusText: UILabel!
    
    @IBAction func actionOnSearch(_ sender: UIBarButtonItem) {
        self.presenter?.openSearchForArtists(fromView: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Saved Albums List"
        
        cvSavedAlbumList.delaysContentTouches = false
        if let layout = cvSavedAlbumList.collectionViewLayout as? AlbumCellLayout {
            layout.delegate = self
        }
        
        cvSavedAlbumList.es.addPullToRefresh { [unowned self] in
            self.presenter?.getSavedAlbum()
        }
        
        self.presenter?.getSavedAlbum()
        self.cvSavedAlbumList.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
    //MARK: ArtistSearchScreenDelegate Methods

    func ArtistSearchDismissed() {
        
    }
    
    func ArtistSearchSelected(selectedArtistData: SearchArtistDataItem) {
        self.presenter?.goToSearchForAlbums(fromView: self, selectedArtistData: selectedArtistData)
    }


    //MARK: SavedAlbumListViewProtocol Methods
    
    func showSavedAlbum(listOfAlbums: [SearchAlbumArtistDataItem]) {
        self.cvSavedAlbumList.es.stopPullToRefresh()
        listOfAlbumsData = listOfAlbums
        DispatchQueue.main.async() {
            self.statusText.isHidden = self.listOfAlbumsData.count > 0
            self.cvSavedAlbumList.isHidden = self.listOfAlbumsData.count <= 0
            self.cvSavedAlbumList.reloadData()
        }
    }

    func hideActivityIndicatorWithError(title: String?, subtitle: String?) {
        statusText.text = title
        statusText.isHidden = false
        cvSavedAlbumList.isHidden = true
    }

}

//MARK: UICollectionViewDelegate Methods

extension SavedAlbumListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter?.setCurrentSelectedAlbumWith(album: listOfAlbumsData[indexPath.row])
    }
    
}

// MARK: UICollectionViewDataSource methods

extension SavedAlbumListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfAlbumsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedAlbumCell.identifier, for: indexPath) as! SavedAlbumCell
        
        cell.bindDataToUI(data: listOfAlbumsData[indexPath.row])
        return cell
    }
    
}

// MARK: AlbumCellLayoutDelegate methods

extension SavedAlbumListViewController: AlbumCellLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        
        var height: CGFloat = 0
        if let albumName =  listOfAlbumsData[indexPath.row].albumName {
            height = height + albumName.heightForWidth(width: withWidth, font: UIFont(name: "HelveticaNeue", size: 13)!)
        }

        if let albumArtist =  listOfAlbumsData[indexPath.row].artistName {
            height = height + albumArtist.heightForWidth(width: withWidth, font: UIFont(name: "HelveticaNeue-Medium", size: 13)!)
        }
        
        return height
    }
    
    
}
