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
    
    private var selectedAlbumValue: Int = -1
    private let pageSize: Int = 25
    private var searchAlbumDataObject: SearchAlbumListData?
    private var selectedArtistData: SearchArtistDataItem
    private var oneRequestAlreadyExecuting: Bool = false

    init(artistData: SearchArtistDataItem) {
        self.selectedArtistData = artistData
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getRefreshData),
                                               name: CoreDataManager.AlbumStoringModifiedNotification,
                                               object: nil)
        
    }
    
    @objc private func getRefreshData(notification: Notification) {
        
        DispatchQueue.main.async() {
            
            guard var searchResultAlbumData = self.searchAlbumDataObject, (self.selectedAlbumValue != -1) else {
                return
            }
            searchResultAlbumData.appendDataStatus(indexOfAlbum: self.selectedAlbumValue)
            self.searchAlbumDataObject = searchResultAlbumData
            self.presenter?.updateAlbumSearchList(searchAlbumData: searchResultAlbumData.listOfArtistAlbum, needToUpdate: true, needToShowEmpty: false)
        }
    }
    
    
    //MARK: AlubmListInteractorInputProtocol Methods
        
    func getData(refreshData: Bool) {
        
        if (self.oneRequestAlreadyExecuting) {
            return
        }

        if (refreshData) {
            self.searchAlbumDataObject = nil
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { [weak self] in
            
            guard let wealSelf = self else {
                return
            }
            
            guard let artistName = wealSelf.selectedArtistData.artistName else {
                return
            }
            
            var storedAlbumData = [Albums]()
            if let locatDataManager = wealSelf.localDatamanager {
                storedAlbumData = locatDataManager.getSavedAlbum(for: artistName)
            }
            
            var requestURLValue = API.urlSearchAlbumForArtistRequest(artistName: artistName, pageIndex: 1, pageLimit: wealSelf.pageSize)
                        
            if let data = wealSelf.searchAlbumDataObject, let pageObjectData = data.pageObject, let currentLoadedPageIndex = Int(pageObjectData.currentPageIndex ?? "0"), let totalNumberOfResults = Int(pageObjectData.totalNumberOfItems ?? "0"), let itemsParPage = Int(pageObjectData.perPageItem ?? "0") {
                
                if ((currentLoadedPageIndex * itemsParPage) >= totalNumberOfResults) {
                    self?.presenter?.updateAlbumSearchList(searchAlbumData: [SearchAlbumArtistDataItem](), needToUpdate: false, needToShowEmpty: false)
                    return
                }
                
                requestURLValue = API.urlSearchAlbumForArtistRequest(artistName: artistName, pageIndex: (currentLoadedPageIndex + 1), pageLimit: wealSelf.pageSize)
            }
            
            wealSelf.oneRequestAlreadyExecuting = true
            wealSelf.APIDataManager?.loadDataForURL(url: requestURLValue, onSuccess: { (searchAlbumDataFound, succeedCode) in
                
                var searchAlbumData = searchAlbumDataFound
               
                if storedAlbumData.count > 0 {
                    
                    for index in 0..<searchAlbumData.listOfArtistAlbum.count {
                        if (wealSelf.getAlbumSaveOrNot(albums: storedAlbumData, albumNeedToCheck: searchAlbumData.listOfArtistAlbum[index])) {
                            searchAlbumData.appendDataStatus(indexOfAlbum: index)
                        }
                    }
                    
                }
                
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
                    wealSelf.oneRequestAlreadyExecuting = false
                    wealSelf.presenter?.updateAlbumSearchList(searchAlbumData: [SearchAlbumArtistDataItem](), needToUpdate: false, needToShowEmpty: false)
                    return
                }
                
                wealSelf.oneRequestAlreadyExecuting = false
                wealSelf.presenter?.updateAlbumSearchList(searchAlbumData: getListOfAlbum, needToUpdate: (searchAlbumData.listOfArtistAlbum.count > 0) ? true : false, needToShowEmpty: searchListIsEmpty)
                
            }, onFailure: { (error, errorcodeData) in
                wealSelf.oneRequestAlreadyExecuting = false
                wealSelf.presenter?.errorInLoadingDataWith(error: error, errorCode: errorcodeData)
            })
        }
        
    }

    func getArtistName() -> String? {
        return self.selectedArtistData.artistName
    }
    
    func setCurrentSelectedAlbumWith(albumIndex: Int) {
        self.selectedAlbumValue = albumIndex
        
        guard var searchResultAlbumData = self.searchAlbumDataObject, (self.selectedAlbumValue != -1) else {
            return
        }

        let dataOfSelectedAlbum = searchResultAlbumData.listOfArtistAlbum[self.selectedAlbumValue]
        let albumInfoRequest = AlbumInfoRequestParam(artistName: dataOfSelectedAlbum.artistName!, albumName: dataOfSelectedAlbum.albumName!, albumStatus: dataOfSelectedAlbum.albumSaved, artistMBID: dataOfSelectedAlbum.artistMBID!)
        self.presenter?.goToSearchAlbumsInformation(requestParam: albumInfoRequest)

    }

    func getAlbumSaveOrNot(albums: [Albums], albumNeedToCheck: SearchAlbumArtistDataItem) -> Bool {
        
        let commonAlbum = albums.filter { (($0.artistName == albumNeedToCheck.artistName) && $0.albumName == albumNeedToCheck.albumName) }
        if (commonAlbum.count > 0) {
            return true
        }
        return false
    }
    
    
}
