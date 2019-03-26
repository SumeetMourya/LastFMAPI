//
//  AlubmDetailsPresenter.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

class AlubmDetailsPresenter: AlubmDetailsPresenterProtocol, AlubmDetailsInteractorOutputProtocol {
    
    weak var view: AlubmDetailsViewProtocol?
    var interactor: AlubmDetailsInteractorInputProtocol?
    var wireFrame: AlubmDetailsWireFrameProtocol?

    init() {}
    
    
    //MARK: AlubmDetailsPresenterProtocol methods
    
    func getAlbumInformationWithAPI() {
        self.interactor?.getAlbumInformationWithAPI()
    }

    func getAlbumName() -> String {
        return self.interactor?.getAlbumName() ?? ""
    }

    func getArtistName() -> String {
        return self.interactor?.getArtistName() ?? ""
    }
        
    func saveAlbumData(albumInforData: AlbumInfoItem) -> Bool  {
        return self.interactor?.saveAlbumData(albumInforData: albumInforData) ?? false
    }
    
    func deleteAlbumData(albumInforData: AlbumInfoItem) -> Bool  {
        return self.interactor?.deleteAlbumData(albumInforData: albumInforData) ?? false
    }

    
    //MARK: AlubmDetailsInteractorOutputProtocol methods

    func errorInLoadingDataWith(error: Error?, errorCode: ApiStatusType) {
        self.view?.errorInLoadingDataWith(error: error, errorCode: errorCode)
    }
    
    func updateAlbumInfoDetailView(albumInforData: AlbumInfoItem) {
        self.view?.updateAlbumInfoDetailView(albumInforData: albumInforData)
    }

    func showActivityIndicator() {
        self.view?.showActivityIndicator()
    }
    
    func hideActivityIndicator() {
        self.view?.hideActivityIndicator()
    }
    
    func hideActivityIndicatorWithError(title: String?, subtitle: String?) {
        self.view?.hideActivityIndicatorWithError(title: title, subtitle: subtitle)
    }
    
}
