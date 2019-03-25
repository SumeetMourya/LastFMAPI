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
    
    @IBOutlet var cvSavedAlbumList: UICollectionView!
    @IBOutlet var statusText: UILabel!
    
    @IBAction func actionOnSearch(_ sender: UIBarButtonItem) {
        self.presenter?.openSearchForArtists(fromView: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Saved Album List"
        
        cvSavedAlbumList.delaysContentTouches = false
        cvSavedAlbumList.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
        
        /*
         cvSavedAlbumList.es.addPullToRefresh { [unowned self] in
         self.presenter?.getData(refreshData: true)
         }
         cvSavedAlbumList.es.addInfiniteScrolling { [unowned self] in
         self.presenter?.getData(refreshData: false)
         }
         self.presenter?.getData(refreshData: true)
         */
        
        //        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        ////        layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 10)
        //        let screenWidth = self.cvSavedAlbumList.frame.size.width - 100
        //        layout.itemSize = CGSize(width: screenWidth / 2, height: 220)
        //        layout.minimumInteritemSpacing = 10
        //        layout.minimumLineSpacing = 10
        //        self.cvSavedAlbumList.collectionViewLayout = layout
        
        
        self.cvSavedAlbumList.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
    }
    
    
    func ArtistSearchDismissed() {
        
    }
    
    func ArtistSearchSelected(selectedArtistData: SearchArtistDataItem) {
        self.presenter?.goToSearchForAlbums(fromView: self, selectedArtistData: selectedArtistData)
    }
    

}


// MARK: UICollectionViewDataSource methods

extension SavedAlbumListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedAlbumCell.identifier, for: indexPath) as! SavedAlbumCell
        
        cell.bindDataToUI()
        return cell
    }
    
    
}

// MARK: UICollectionViewDelegateFlowLayout methods

extension SavedAlbumListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width - 30) / 2, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    
}


