//
//  SavedAlbumListProtocols.swift
//  Demo
//
//  Created by sumeet mourya on 03/24/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

protocol SavedAlbumListViewProtocol: LoaderView {
    var presenter: SavedAlbumListPresenterProtocol? { get set }
    
    //here your methods for communication PRESENTER -> VIEW
    func showSavedAlbum(listOfAlbums: [SearchAlbumArtistDataItem])

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
    func getSavedAlbum()

}

protocol SavedAlbumListInteractorOutputProtocol: class {
    
    //here your methods for communication INTERACTOR -> PRESENTER
    func showSavedAlbum(listOfAlbums: [SearchAlbumArtistDataItem])
    func showActivityIndicator()
    func hideActivityIndicator()
    func hideActivityIndicatorWithError(title: String?, subtitle: String?)

}

protocol SavedAlbumListInteractorInputProtocol: class {
    
    var presenter: SavedAlbumListInteractorOutputProtocol? { get set }
    var APIDataManager: SavedAlbumListAPIDataManagerInputProtocol? { get set }
    var localDatamanager: SavedAlbumListLocalDataManagerInputProtocol? { get set }
    
    //here your methods for communication PRESENTER -> INTERACTOR
    func getSavedAlbum()
    
}

protocol SavedAlbumListDataManagerInputProtocol: class {
    
    //here your methods for communication INTERACTOR -> DATAMANAGER

}

protocol SavedAlbumListAPIDataManagerInputProtocol: class {
    
    //here your methods for communication INTERACTOR -> APIDATAMANAGER

}

protocol SavedAlbumListLocalDataManagerInputProtocol: class {
    
    //here your methods for communication INTERACTOR -> LOCALDATAMANAGER
    func getSavedAlbum() -> [SearchAlbumArtistDataItem]
    
}
