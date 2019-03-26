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
        cvSavedAlbumList.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
        
         cvSavedAlbumList.es.addPullToRefresh { [unowned self] in
            self.presenter?.getSavedAlbum()
         }

        self.presenter?.getSavedAlbum()
        self.cvSavedAlbumList.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }

    //MARK: ArtistSearchScreenDelegate Methods

    func ArtistSearchDismissed() {
        
    }
    
    func ArtistSearchSelected(selectedArtistData: SearchArtistDataItem) {
        self.presenter?.goToSearchForAlbums(fromView: self, selectedArtistData: selectedArtistData)
    }


    //MARK: SavedAlbumListViewProtocol Methods
    
    func showSavedAlbum(listOfAlbums: [SearchAlbumArtistDataItem]) {
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

// MARK: UICollectionViewDelegateFlowLayout methods

extension SavedAlbumListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width - 45) / 2, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
}


