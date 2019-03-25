//
//  SavedAlbumListProtocols.swift
//  Demo
//
//  Created by sumeet mourya on 03/24/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

protocol SavedAlbumListViewProtocol: class {
    var presenter: SavedAlbumListPresenterProtocol? { get set }
    
    //here your methods for communication PRESENTER -> VIEW

}

protocol SavedAlbumListWireFrameProtocol: class {
    static func presentSavedAlbumListModule(fromView view: AnyObject)
    
    //here your methods for communication PRESENTER -> WIREFRAME
    func openSearchForArtists(fromView view: AnyObject)
    func goToSearchForAlbums(fromView view: AnyObject, selectedArtistData: SearchArtistDataItem)

}

protocol SavedAlbumListPresenterProtocol: class {
    var view: SavedAlbumListViewProtocol? { get set }
    var interactor: SavedAlbumListInteractorInputProtocol? { get set }
    var wireFrame: SavedAlbumListWireFrameProtocol? { get set }
    
    //here your methods for communication VIEW -> PRESENTER
    func openSearchForArtists(fromView view: AnyObject)
    func goToSearchForAlbums(fromView view: AnyObject, selectedArtistData: SearchArtistDataItem)
}

protocol SavedAlbumListInteractorOutputProtocol: class {
    
    //here your methods for communication INTERACTOR -> PRESENTER

}

protocol SavedAlbumListInteractorInputProtocol: class {
    
    var presenter: SavedAlbumListInteractorOutputProtocol? { get set }
    var APIDataManager: SavedAlbumListAPIDataManagerInputProtocol? { get set }
    var localDatamanager: SavedAlbumListLocalDataManagerInputProtocol? { get set }
    
    //here your methods for communication PRESENTER -> INTERACTOR

}

protocol SavedAlbumListDataManagerInputProtocol: class {
    
    //here your methods for communication INTERACTOR -> DATAMANAGER

}

protocol SavedAlbumListAPIDataManagerInputProtocol: class {
    
    //here your methods for communication INTERACTOR -> APIDATAMANAGER

}

protocol SavedAlbumListLocalDataManagerInputProtocol: class {
    
    //here your methods for communication INTERACTOR -> LOCALDATAMANAGER

}
