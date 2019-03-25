//
//  AlubmListInteractor.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

class AlubmListInteractor: AlubmListInteractorInputProtocol {

    
    weak var presenter: AlubmListInteractorOutputProtocol?
    var APIDataManager: AlubmListAPIDataManagerInputProtocol?
    var localDatamanager: AlubmListLocalDataManagerInputProtocol?

    private let pageSize: Int = 25
    private var searchAlbumDataObject: SearchAlbumListData?

    private var selectedArtistData: SearchArtistDataItem
    
    init(artistData: SearchArtistDataItem) {
        self.selectedArtistData = artistData
    }
    
    //MARK: AlubmListInteractorInputProtocol Methods
        
    func getData(refreshData: Bool) {
        
        if (refreshData) {
            self.searchAlbumDataObject = nil
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async { [weak self] in
            
            guard let wealSelf = self else {
                return
            }
            
            guard let artistName = wealSelf.selectedArtistData.artistName else {
                return
            }
            
            var requestURLValue = API.urlSearchAlbumForArtistRequest(artistName: artistName, pageIndex: 1, pageLimit: wealSelf.pageSize)
                        
            if let data = wealSelf.searchAlbumDataObject, let pageObjectData = data.pageObject, let currentLoadedPageIndex = Int(pageObjectData.currentPageIndex ?? "0"), let totalNumberOfResults = Int(pageObjectData.totalNumberOfItems ?? "0"), let itemsParPage = Int(pageObjectData.perPageItem ?? "0") {
                
                if ((currentLoadedPageIndex * itemsParPage) >= totalNumberOfResults) {
                    self?.presenter?.updateAlbumSearchList(searchAlbumData: [SearchAlbumArtistDataItem](), needToUpdate: false, needToShowEmpty: false)
                    return
                }
                
                requestURLValue = API.urlSearchAlbumForArtistRequest(artistName: artistName, pageIndex: (currentLoadedPageIndex + 1), pageLimit: wealSelf.pageSize)
            }
            
            
            wealSelf.APIDataManager?.loadDataForURL(url: requestURLValue, onSuccess: { (searchAlbumData, succeedCode) in
                
                if searchAlbumData.pageObject?.currentPageIndex == "1" {
                    wealSelf.searchAlbumDataObject = searchAlbumData
                } else {
                    wealSelf.searchAlbumDataObject?.appendData(needToUpdate: searchAlbumData)
                }
                
                var searchListIsEmpty: Bool = true
                if let existingData = wealSelf.searchAlbumDataObject, existingData.listOfArtistAlbum.count > 0 {
                    searchListIsEmpty = false
                }
                
                guard let getListOfAlbum = wealSelf.searchAlbumDataObject?.listOfArtistAlbum else {
                    wealSelf.presenter?.updateAlbumSearchList(searchAlbumData: [SearchAlbumArtistDataItem](), needToUpdate: false, needToShowEmpty: false)
                    return
                }
                
                wealSelf.presenter?.updateAlbumSearchList(searchAlbumData: getListOfAlbum, needToUpdate: (searchAlbumData.listOfArtistAlbum.count > 0) ? true : false, needToShowEmpty: searchListIsEmpty)
                
            }, onFailure: { (error, errorcodeData) in
                wealSelf.presenter?.errorInLoadingDataWith(error: error, errorCode: errorcodeData)
            })
        }
        
    }

    func getArtistName() -> String? {
        return self.selectedArtistData.artistName
    }
}
