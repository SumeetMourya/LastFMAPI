//
//  SearchListInteractor.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

class SearchListInteractor: SearchListInteractorInputProtocol {

    weak var presenter: SearchListInteractorOutputProtocol?
    var APIDataManager: SearchListAPIDataManagerInputProtocol?
    var localDatamanager: SearchListLocalDataManagerInputProtocol?

    private let pageSize: Int = 25
    private var searchArtistDataObject: GetSearchData?
    private var oneRequestAlreadyExecuting: Bool = false

    init() {}
    
    
    //MARK: SearchListInteractorInputProtocol Methods
    
    func getData(refreshData: Bool, artistName: String) {
        
        if (self.oneRequestAlreadyExecuting) {
            return
        }
        
        guard (artistName.count > 0) else {
            self.presenter?.updateArtistSearchList(searchArtistData: [SearchArtistDataItem](), needToUpdate: false, needToShowEmpty: true)
            return
        }
        
        if (refreshData) {
            self.searchArtistDataObject = nil
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { [weak self] in
            
            guard let wealSelf = self else {
                return
            }
            
            var requestURLValue = API.urlSearchArtistRequestWith(artistName: artistName, pageIndex: 1, pageLimit: wealSelf.pageSize)
            
            if let data = wealSelf.searchArtistDataObject, let pageObjectData = data.pageObject, let currentLoadedPageIndex = Int(pageObjectData.currentPageIndex ?? "0"), let totalNumberOfResults = Int(pageObjectData.totalNumberOfItems ?? "0"), let itemsParPage = Int(pageObjectData.perPageItem ?? "0") {
                
                if ((currentLoadedPageIndex * itemsParPage) >= totalNumberOfResults) {
                    self?.presenter?.updateArtistSearchList(searchArtistData: [SearchArtistDataItem](), needToUpdate: false, needToShowEmpty: false)
                    return
                }
                
                requestURLValue = API.urlSearchArtistRequestWith(artistName: artistName, pageIndex: (currentLoadedPageIndex + 1), pageLimit: wealSelf.pageSize)

            }
            
            wealSelf.oneRequestAlreadyExecuting = true
            wealSelf.APIDataManager?.loadDataForURL(url: requestURLValue, onSuccess: { (searchArtistData, succeedCode) in
                
                if searchArtistData.pageObject?.currentPageIndex == "1" {
                    wealSelf.searchArtistDataObject = searchArtistData
                } else {
                    wealSelf.searchArtistDataObject?.appendData(needToUpdate: searchArtistData)
                }
                
                var searchListIsEmpty: Bool = true
                if let existingData = wealSelf.searchArtistDataObject, existingData.listOfArtists.count > 0 {
                    searchListIsEmpty = false
                }
                
                guard let getListOfSeasrchArtists = wealSelf.searchArtistDataObject?.listOfArtists else {
                    wealSelf.oneRequestAlreadyExecuting = false
                    wealSelf.presenter?.updateArtistSearchList(searchArtistData: [SearchArtistDataItem](), needToUpdate: false, needToShowEmpty: false)
                    return
                }
                
                wealSelf.oneRequestAlreadyExecuting = false
                wealSelf.presenter?.updateArtistSearchList(searchArtistData: getListOfSeasrchArtists, needToUpdate: (searchArtistData.listOfArtists.count > 0) ? true : false, needToShowEmpty: searchListIsEmpty)
                
            }, onFailure: { (error, errorcodeData) in
                wealSelf.oneRequestAlreadyExecuting = false
                wealSelf.presenter?.errorInLoadingDataWith(error: error, errorCode: errorcodeData)
            })
        }
    
    }

}
