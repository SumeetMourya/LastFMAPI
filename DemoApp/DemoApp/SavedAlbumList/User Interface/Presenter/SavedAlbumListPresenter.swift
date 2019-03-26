//
//  SavedAlbumListPresenter.swift
//  Demo
//
//  Created by sumeet mourya on 03/24/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

class SavedAlbumListPresenter: SavedAlbumListPresenterProtocol, SavedAlbumListInteractorOutputProtocol {
    
    weak var view: SavedAlbumListViewProtocol?
    var interactor: SavedAlbumListInteractorInputProtocol?
    var wireFrame: SavedAlbumListWireFrameProtocol?

    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(getRefreshData),
                                               name: CoreDataManager.AlbumStoringModifiedNotification,
                                               object: nil)
        
    }
    
    @objc private func getRefreshData(notification: Notification) {
        self.interactor?.getSavedAlbum()
    }

    //MARK: SavedAlbumListPresenterProtocol Methdos
    
    func getSavedAlbum() {
        self.interactor?.getSavedAlbum()
    }
    
    //MARK : SavedAlbumListInteractorOutputProtocol Methods
    
    func showSavedAlbum(listOfAlbums: [SearchAlbumArtistDataItem]) {        
        self.view?.showSavedAlbum(listOfAlbums: listOfAlbums)
    }

    func openSearchForArtists(fromView view: AnyObject) {
        self.wireFrame?.openSearchForArtists(fromView: view)
    }

    func goToSearchForAlbums(fromView view: AnyObject, selectedArtistData: SearchArtistDataItem) {
        self.wireFrame?.goToSearchForAlbums(fromView: view, selectedArtistData: selectedArtistData)
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
