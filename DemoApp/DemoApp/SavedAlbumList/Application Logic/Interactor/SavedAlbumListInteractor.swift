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

    init() {}
}
