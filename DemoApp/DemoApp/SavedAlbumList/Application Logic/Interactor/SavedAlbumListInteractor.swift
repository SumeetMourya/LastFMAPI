//
//  SavedAlbumListInteractor.swift
//  Demo
//
//  Created by sumeet mourya on 03/24/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

class SavedAlbumListInteractor: SavedAlbumListInteractorInputProtocol {
    

    weak var presenter: SavedAlbumListInteractorOutputProtocol?
    var APIDataManager: SavedAlbumListAPIDataManagerInputProtocol?
    var localDatamanager: SavedAlbumListLocalDataManagerInputProtocol?
   
    private var oneRequestAlreadyExecuting: Bool = false

    init() {    }


    func getSavedAlbum() {
        
        if (self.oneRequestAlreadyExecuting) {
            return
        }
        
        self.presenter?.showActivityIndicator()

        self.oneRequestAlreadyExecuting = true
       
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async { [weak self] in
            
            guard let wealSelf = self else {
                return
            }
            
            guard let listOfAlbums = wealSelf.localDatamanager?.getSavedAlbum() else {
                wealSelf.oneRequestAlreadyExecuting = false
                wealSelf.presenter?.hideActivityIndicator()
                return
            }
            
            wealSelf.oneRequestAlreadyExecuting = false
            wealSelf.presenter?.hideActivityIndicator()
            wealSelf.presenter?.showSavedAlbum(listOfAlbums: listOfAlbums)
        }
    }

    func setCurrentSelectedAlbumWith(album: SearchAlbumArtistDataItem) {
        
        if let dataForNextScreen = self.localDatamanager?.getAlbumDecoded(objectNeedtoConvert: album) {
            self.presenter?.goToAlbumsDetailInformation(albumData: dataForNextScreen)
        }

    }
}
