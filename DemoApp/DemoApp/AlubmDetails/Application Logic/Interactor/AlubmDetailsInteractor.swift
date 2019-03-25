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
    var requestParam: AlbumInfoRequestParam?
    
    init(requestParamValue: AlbumInfoRequestParam? = nil ) {
        requestParam = requestParamValue
    }
    
    
    //MARK: AlubmDetailsInteractorInputProtocol
    
    func getAlbumName() -> String {
        return requestParam?.albumName ?? ""
    }

    func getArtistName() -> String {
        return requestParam?.artistName ?? ""
    }

    func getAlbumInformationWithAPI() {
        
//        func showActivityIndicator()
//        func hideActivityIndicator()
//        func hideActivityIndicatorWithError(title: String?, subtitle: String?)

        self.presenter?.showActivityIndicator()
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async { [weak self] in
            
            guard let wealSelf = self, let requestParamData = self?.requestParam else {
                self?.presenter?.hideActivityIndicatorWithError(title: "Technical issue", subtitle: "")
                return
            }
            
            let requestURLValue = API.urlArtistsAlbumDataRequest(artistName: requestParamData.artistName, albumName: requestParamData.albumName)
            
            wealSelf.APIDataManager?.loadDataForURL(url: requestURLValue, onSuccess: { (albumInfoDataFound, succeedCode) in
                wealSelf.presenter?.hideActivityIndicator()
                wealSelf.presenter?.updateAlbumInfoDetailView(albumInforData: albumInfoDataFound)
                                
            }, onFailure: { (error, errorcodeData) in
                wealSelf.presenter?.errorInLoadingDataWith(error: error, errorCode: errorcodeData)
                wealSelf.presenter?.hideActivityIndicatorWithError(title: "Technical issue", subtitle: "")
            })
        }
        
    }

}
