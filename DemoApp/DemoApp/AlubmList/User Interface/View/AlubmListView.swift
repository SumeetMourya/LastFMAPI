//
//  AlubmListView.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit
import ESPullToRefresh


class AlubmListViewController: UIViewController, AlubmListViewProtocol {
    
    var presenter: AlubmListPresenterProtocol?
    var listOfSearchAlbum: [SearchAlbumArtistDataItem] = [SearchAlbumArtistDataItem]()
    
    @IBOutlet var cvAlbumListForArtist: UICollectionView!
    @IBOutlet var statusText: UILabel!
    @IBOutlet var lblErrorText: UILabel!
    
    @IBOutlet var layoutiPhoneXBottomManageViewHeight: NSLayoutConstraint!
    @IBOutlet var layoutErrorViewHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let artistNameForAlbumSearching = self.presenter?.getArtistName() {
            self.title = "By: \(artistNameForAlbumSearching)"
        } else {
            self.title = "By: "
        }
        
        cvAlbumListForArtist.delaysContentTouches = false
        cvAlbumListForArtist.setCollectionViewLayout(UICollectionViewFlowLayout(), animated: false)
        
//        if let flowLayout = cvAlbumListForArtist.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
//        }
        
        cvAlbumListForArtist.es.addPullToRefresh { [unowned self] in
            self.presenter?.getData(refreshData: true)
        }
        cvAlbumListForArtist.es.addInfiniteScrolling { [unowned self] in
            self.presenter?.getData(refreshData: false)
        }
        self.presenter?.getData(refreshData: true)
        
        self.cvAlbumListForArtist.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    // MARK: Private Methods
    
    func showAlertView(msg: String, title: String) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action:UIAlertAction) in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
   
    
    //show the error when list is having some items
    
    func showErrorInBottomView(show: Bool) {
        
        layoutiPhoneXBottomManageViewHeight.constant = show ? (UIDevice.isHavingCurved ? 50 : 0) : 0
        layoutErrorViewHeight.constant = show ? 50 : 0
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: AlubmListViewProtocol Methods
    
    func updateAlbumSearchList(searchAlbumData: [SearchAlbumArtistDataItem], needToUpdate: Bool, needToShowEmpty: Bool) {
      
        DispatchQueue.main.async() {
            
            self.cvAlbumListForArtist.es.stopPullToRefresh()
            self.cvAlbumListForArtist.es.stopLoadingMore()
            
            if (needToUpdate) {
                self.listOfSearchAlbum = searchAlbumData
                self.cvAlbumListForArtist.reloadData()
            } else {
                self.cvAlbumListForArtist.es.noticeNoMoreData()
            }
            
            self.statusText.isHidden = !needToShowEmpty
            self.cvAlbumListForArtist.isHidden = needToShowEmpty
            
            if self.lblErrorText.text?.count ?? 0 > 0 {
                self.lblErrorText.text = ""
                self.showErrorInBottomView(show: false)
            }
            
        }
    }
    
    func errorInLoadingDataWith(error: Error?, errorCode: ApiStatusType) {
        
        var alertMSG: String = ""
        
        switch errorCode {
        case .apiSucceed:
            alertMSG = ""
            break
            
        case .netWorkIssue:
            alertMSG = "Please check your network connectivity."
            break
            
        case .apiIssue:
            alertMSG = "Server issue"
            break
            
        case .apiParsingIssue:
            alertMSG = "Server data parsing issue"
            break
            
        case .apiEncodingIssue:
            alertMSG = "Server decoding issue"
            break
            
        case .none:
            break
            
        default:
            break
            
        }
        
        print("alertMSG: \(alertMSG)")
        
        DispatchQueue.main.async() {
            //          showAlertView(msg: "Error", title: alertMSG)
            
            self.cvAlbumListForArtist.es.stopLoadingMore()
            self.cvAlbumListForArtist.es.stopPullToRefresh()
            self.lblErrorText.text = alertMSG
            self.showErrorInBottomView(show: true)
        }
        
    }

}
    

//MARK: UICollectionViewDelegate Methods

extension AlubmListViewController: UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter?.setCurrentSelectedAlbumWith(albumIndex: indexPath.row)
    }
    
}

// MARK: UICollectionViewDataSource methods

extension AlubmListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfSearchAlbum.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.identifier, for: indexPath) as! AlbumCell
        cell.bindDataToUI(data: listOfSearchAlbum[indexPath.row])
        return cell
    }
    
    
}

// MARK: UICollectionViewDelegateFlowLayout methods

extension AlubmListViewController: UICollectionViewDelegateFlowLayout {
   
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


