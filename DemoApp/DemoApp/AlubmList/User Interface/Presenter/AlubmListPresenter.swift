//
//  AlubmListPresenter.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

class AlubmListPresenter: AlubmListPresenterProtocol, AlubmListInteractorOutputProtocol {    
    
    weak var view: AlubmListViewProtocol?
    var interactor: AlubmListInteractorInputProtocol?
    var wireFrame: AlubmListWireFrameProtocol?

    init() {}

    
    //MARK: AlubmListPresenterProtocol methods
    
    func getData(refreshData: Bool) {
        self.interactor?.getData(refreshData: refreshData)
    }
    
    func getArtistName() -> String? {
        return self.interactor?.getArtistName()
    }
    
    func setCurrentSelectedWith(albumIndex: Int) {
        self.interactor?.setCurrentSelectedWith(albumIndex: albumIndex)
    }
    
    
    //MARK: AlubmListInteractorOutputProtocol methods
    
    func updateAlbumSearchList(searchAlbumData: [SearchAlbumArtistDataItem], needToUpdate: Bool, needToShowEmpty: Bool) {
        self.view?.updateAlbumSearchList(searchAlbumData: searchAlbumData, needToUpdate: needToUpdate, needToShowEmpty: needToShowEmpty)
    }
    
    func errorInLoadingDataWith(error: Error?, errorCode: ApiStatusType) {
        self.view?.errorInLoadingDataWith(error: error, errorCode: errorCode)
    }

    func goToSearchAlbumsInformation(requestParam: AlbumInfoRequestParam) {        
        self.wireFrame?.goToSearchAlbumsDetail(fromView: self.view!, selectedAlbum: requestParam)
    }

}

