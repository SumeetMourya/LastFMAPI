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

    init() {}
    
    //MARK: SavedAlbumListPresenterProtocol Methdos
    
    func openSearchForArtists(fromView view: AnyObject) {
        self.wireFrame?.openSearchForArtists(fromView: view)
    }

    func goToSearchForAlbums(fromView view: AnyObject, selectedArtistData: SearchArtistDataItem) {
        self.wireFrame?.goToSearchForAlbums(fromView: view, selectedArtistData: selectedArtistData)
    }
}
