//
//  AlubmListProtocols.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

protocol AlubmListViewProtocol: class {
    
    var presenter: AlubmListPresenterProtocol? { get set }
    
    //here your methods for communication PRESENTER -> VIEW
    func updateAlbumSearchList(searchAlbumData: [SearchAlbumArtistDataItem], needToUpdate: Bool, needToShowEmpty: Bool)
    func errorInLoadingDataWith(error: Error?, errorCode: ApiStatusType)

}

protocol AlubmListWireFrameProtocol: class {
    
    static func presentAlubmListModule(fromView: AnyObject, selectedArtist: SearchArtistDataItem)
    static func presentAlubmListModule(selectedArtist: SearchArtistDataItem) -> AlubmListViewProtocol
    
    //here your methods for communication PRESENTER -> WIREFRAME
    func goToSearchAlbumsDetail(fromView view: AnyObject, selectedAlbum: AlbumInfoRequestParam)

}

protocol AlubmListPresenterProtocol: class {
    
    var view: AlubmListViewProtocol? { get set }
    var interactor: AlubmListInteractorInputProtocol? { get set }
    var wireFrame: AlubmListWireFrameProtocol? { get set }
    
    //here your methods for communication VIEW -> PRESENTER
    func getData(refreshData: Bool)
    func getArtistName() -> String?
    func goToSearchAlbumsDetail(fromView: AnyObject, requestParam: AlbumInfoRequestParam) 

}

protocol AlubmListInteractorOutputProtocol: class {
    
    //here your methods for communication INTERACTOR -> PRESENTER
    func updateAlbumSearchList(searchAlbumData: [SearchAlbumArtistDataItem], needToUpdate: Bool, needToShowEmpty: Bool)
    func errorInLoadingDataWith(error: Error?, errorCode: ApiStatusType)

}

protocol AlubmListInteractorInputProtocol: class {
    
    var presenter: AlubmListInteractorOutputProtocol? { get set }
    var APIDataManager: AlubmListAPIDataManagerInputProtocol? { get set }
    var localDatamanager: AlubmListLocalDataManagerInputProtocol? { get set }
    
    //here your methods for communication PRESENTER -> INTERACTOR
    func getData(refreshData: Bool)
    func getArtistName() -> String?
}

protocol AlubmListDataManagerInputProtocol: class {
    
    //here your methods for communication INTERACTOR -> DATAMANAGER

}

protocol AlubmListAPIDataManagerInputProtocol: class {
    
    //here your methods for communication INTERACTOR -> APIDATAMANAGER
    func loadDataForURL(url: String, onSuccess success: @escaping (_ data: SearchAlbumListData, _ apiStatusCode: ApiStatusType) -> Void, onFailure failure: @escaping (_ error: Error?, _ apiStatusCode: ApiStatusType) -> Void)
}

protocol AlubmListLocalDataManagerInputProtocol: class {
    
    //here your methods for communication INTERACTOR -> LOCALDATAMANAGER

}
