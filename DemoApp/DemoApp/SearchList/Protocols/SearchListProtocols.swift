//
//  SearchListProtocols.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

protocol ArtistSearchScreenDelegate {
    
    //Add arguments if you need to send some information
    func ArtistSearchDismissed()
    func ArtistSearchSelected(selectedArtistData: SearchArtistDataItem)
}

protocol SearchListViewProtocol: class {
    
    var presenter: SearchListPresenterProtocol? { get set }
    
    //here your methods for communication PRESENTER -> VIEW
    func updateArtistSearchList(searchArtistData: [SearchArtistDataItem], needToUpdate: Bool, needToShowEmpty: Bool)
    func errorInLoadingDataWith(error: Error?, errorCode: ApiStatusType)

}

protocol SearchListWireFrameProtocol: class {
    
    static func presentSearchListModule(fromView view: AnyObject)
    
    //here your methods for communication PRESENTER -> WIREFRAME
    func goToSearchForAlbums(fromView view: AnyObject, selectedArtistData: SearchArtistDataItem)

}

protocol SearchListPresenterProtocol: class {
    var view: SearchListViewProtocol? { get set }
    var interactor: SearchListInteractorInputProtocol? { get set }
    var wireFrame: SearchListWireFrameProtocol? { get set }
    
    //here your methods for communication VIEW -> PRESENTER
    func getData(refreshData: Bool, artistName: String)
    func goToSearchForAlbums(fromView view: AnyObject, selectedArtistData: SearchArtistDataItem)
    func openSelectedArtistForAlbum(data: SearchArtistDataItem)
}

protocol SearchListInteractorOutputProtocol: class {
    
    //here your methods for communication INTERACTOR -> PRESENTER
    func updateArtistSearchList(searchArtistData: [SearchArtistDataItem], needToUpdate: Bool, needToShowEmpty: Bool)
    func errorInLoadingDataWith(error: Error?, errorCode: ApiStatusType)

}

protocol SearchListInteractorInputProtocol: class {
    
    var presenter: SearchListInteractorOutputProtocol? { get set }
    var APIDataManager: SearchListAPIDataManagerInputProtocol? { get set }
    var localDatamanager: SearchListLocalDataManagerInputProtocol? { get set }
    
    //here your methods for communication PRESENTER -> INTERACTOR
    func getData(refreshData: Bool, artistName: String)
    
}

protocol SearchListDataManagerInputProtocol: class {
    
    //here your methods for communication INTERACTOR -> DATAMANAGER

}

protocol SearchListAPIDataManagerInputProtocol: class {
    
    //here your methods for communication INTERACTOR -> APIDATAMANAGER
    func loadDataForURL(url: String, onSuccess success: @escaping (_ data: GetSearchData, _ apiStatusCode: ApiStatusType) -> Void, onFailure failure: @escaping (_ error: Error?, _ apiStatusCode: ApiStatusType) -> Void) ;

}

protocol SearchListLocalDataManagerInputProtocol: class {
    
    //here your methods for communication INTERACTOR -> LOCALDATAMANAGER

}
