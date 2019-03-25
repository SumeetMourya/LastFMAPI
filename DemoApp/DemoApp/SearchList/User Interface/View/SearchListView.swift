//
//  SearchListView.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit

class SearchListViewController: UIViewController, SearchListViewProtocol {
   
    let addInfiniteScrollingViaESPullToRefresh: Bool = true

    var presenter: SearchListPresenterProtocol?
    var listOfSearchArtists: [SearchArtistDataItem] = [SearchArtistDataItem]()
    var artistNameForSearch: String = ""

    @IBOutlet var layoutiPhoneXBottomManageViewHeight: NSLayoutConstraint!
    @IBOutlet var layoutErrorViewHeight: NSLayoutConstraint!
    @IBOutlet var layoutListViewTopPin: NSLayoutConstraint!
    
    @IBOutlet var tblvResultOfSearchAlbumList: UITableView!
    @IBOutlet var statusText: UILabel!
    @IBOutlet var lblErrorText: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblvResultOfSearchAlbumList.tableFooterView = UIView(frame: .zero)
        tblvResultOfSearchAlbumList.rowHeight = UITableView.automaticDimension
        tblvResultOfSearchAlbumList.estimatedRowHeight = 80
        tblvResultOfSearchAlbumList.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 30, right: 0)
        tblvResultOfSearchAlbumList.delaysContentTouches = false

        tblvResultOfSearchAlbumList.es.addPullToRefresh {
            self.presenter?.getData(refreshData: true, artistName: self.artistNameForSearch)
        }
        
        tblvResultOfSearchAlbumList.es.addInfiniteScrolling {
            self.tblvResultOfSearchAlbumList.es.addInfiniteScrolling {
                self.presenter?.getData(refreshData: false, artistName: self.artistNameForSearch)
            }
        }
        
        self.showErrorInBottomView(show: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let statusHeight = UIApplication.shared.statusBarFrame.height
//        self.layoutHeaderViewTopPin.constant = statusHeight > 20 ? 0.0 : statusHeight
//        layoutListHeight.constant = modeOfViewArticleList ? CGFloat(20 + (60 * chapterData.articles.count)) : 0
        
        layoutListViewTopPin.constant = self.topbarHeight

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
    
    // MARK: ManufacturerViewProtocol methods
    
    func updateArtistSearchList(searchArtistData: [SearchArtistDataItem], needToUpdate: Bool, needToShowEmpty: Bool) {
        
        DispatchQueue.main.async() {
            
            self.tblvResultOfSearchAlbumList.es.stopPullToRefresh()
            self.tblvResultOfSearchAlbumList.es.stopLoadingMore()
            
            if (needToUpdate) {
                self.listOfSearchArtists = searchArtistData
                self.tblvResultOfSearchAlbumList.reloadData()
            } else {
                self.tblvResultOfSearchAlbumList.es.noticeNoMoreData()
            }
            
            self.statusText.isHidden = !needToShowEmpty
            self.tblvResultOfSearchAlbumList.isHidden = needToShowEmpty
            
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
            
            self.tblvResultOfSearchAlbumList.es.stopLoadingMore()
            self.tblvResultOfSearchAlbumList.es.stopPullToRefresh()
            self.lblErrorText.text = alertMSG
            self.showErrorInBottomView(show: true)
        }
        
    }
    

}


// MARK: UITableViewDelegate methods

extension SearchListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.presenter?.openSelectedArtistForAlbum(data: listOfSearchArtists[indexPath.row])
        self.presenter?.goToSearchForAlbums(fromView: self, selectedArtistData: listOfSearchArtists[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
}

// MARK: UITableViewDataSource methods

extension SearchListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfSearchArtists.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:SearchAlbumCell? = tableView.dequeueReusableCell(withIdentifier: SearchAlbumCell.identifier) as? SearchAlbumCell
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: SearchAlbumCell.identifier) as? SearchAlbumCell
        }
        cell?.selectionStyle = .none
        cell?.contentView.backgroundColor = UIColor.clear
        cell?.backgroundColor = UIColor.clear
        
        cell?.bindDataToUI(data: listOfSearchArtists[indexPath.row])
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //We can use this code for loading the data for page page without using third party library
        if (!addInfiniteScrollingViaESPullToRefresh) {
            if (indexPath.row == (self.listOfSearchArtists.count - 1)) {
                self.presenter?.getData(refreshData: false, artistName: self.artistNameForSearch)
            }
        }
    }

}


extension SearchListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let text = searchController.searchBar.text {
            self.artistNameForSearch = text
            self.presenter?.getData(refreshData: true, artistName: text)
        }
    }
    
}



extension UIViewController {
    
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
