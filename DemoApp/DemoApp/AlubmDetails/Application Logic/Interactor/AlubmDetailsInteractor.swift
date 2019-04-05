//
//  AlubmDetailsInteractor.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

class AlubmDetailsInteractor: AlubmDetailsInteractorInputProtocol {
    

    weak var presenter: AlubmDetailsInteractorOutputProtocol?
    var APIDataManager: AlubmDetailsAPIDataManagerInputProtocol?
    var localDatamanager: AlubmDetailsLocalDataManagerInputProtocol?
    
    private var requestParam: AlbumInfoRequestParam?
    private var albumDataFromPreviewView: AlbumInfoItem?
    
    
    init(requestParamValue: AlbumInfoRequestParam? = nil, albumInfoData: AlbumInfoItem? = nil) {
        requestParam = requestParamValue
        albumDataFromPreviewView = albumInfoData
    }
    
    
    //MARK: AlubmDetailsInteractorInputProtocol
    
    func getAlbumName() -> String {
        return requestParam?.albumName ?? (albumDataFromPreviewView?.albumName ?? "")
    }

    func getArtistName() -> String {
        return requestParam?.artistName ?? (albumDataFromPreviewView?.artistName ?? "")
    }

    func getAlbumInformationWithAPI() {
        
        if let albumDataAvailable = albumDataFromPreviewView {
            self.presenter?.updateAlbumInfoDetailView(albumInforData: albumDataAvailable)
        } else {
            self.presenter?.showActivityIndicator()
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { [weak self] in
                
                guard let wealSelf = self, let requestParamData = self?.requestParam else {
                    self?.presenter?.hideActivityIndicatorWithError(title: "Technical issue", subtitle: "")
                    return
                }
                
                let requestURLValue = API.urlArtistsAlbumDataRequest(artistName: requestParamData.artistName, albumName: requestParamData.albumName)
                
                wealSelf.APIDataManager?.loadDataForURL(url: requestURLValue, onSuccess: { (albumInfoDataFound, succeedCode) in
                    wealSelf.presenter?.hideActivityIndicator()
                    
                    var albumInfoData = albumInfoDataFound
                    if let albumRequestParam = wealSelf.requestParam {
                        albumInfoData.updateAlbumSaveStatus(value: albumRequestParam.albumStatus)
                    }
                    wealSelf.presenter?.updateAlbumInfoDetailView(albumInforData: albumInfoData)
                    
                }, onFailure: { (error, errorcodeData) in
                    wealSelf.presenter?.errorInLoadingDataWith(error: error, errorCode: errorcodeData)
                    wealSelf.presenter?.hideActivityIndicatorWithError(title: "Technical issue", subtitle: "")
                })
            }
        }
        
    }

    func saveAlbumData(albumInforData: AlbumInfoItem) -> Bool {
        return self.localDatamanager?.saveAlbumData(albumInforData: albumInforData) ?? false
    }
    
    func deleteAlbumData(albumInforData: AlbumInfoItem) -> Bool  {
        return self.localDatamanager?.deleteAlbumData(albumInforData: albumInforData) ?? false
    }

}
