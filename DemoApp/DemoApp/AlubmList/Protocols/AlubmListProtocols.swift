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
    func setCurrentSelectedAlbumWith(albumIndex: Int)
    
}

protocol AlubmListInteractorOutputProtocol: class {
    
    //here your methods for communication INTERACTOR -> PRESENTER
    func updateAlbumSearchList(searchAlbumData: [SearchAlbumArtistDataItem], needToUpdate: Bool, needToShowEmpty: Bool)
    func errorInLoadingDataWith(error: Error?, errorCode: ApiStatusType)
    func goToSearchAlbumsInformation(requestParam: AlbumInfoRequestParam)

}

protocol AlubmListInteractorInputProtocol: class {
    
    var presenter: AlubmListInteractorOutputProtocol? { get set }
    var APIDataManager: AlubmListAPIDataManagerInputProtocol? { get set }
    var localDatamanager: AlubmListLocalDataManagerInputProtocol? { get set }
    
    //here your methods for communication PRESENTER -> INTERACTOR
    func getData(refreshData: Bool)
    func getArtistName() -> String?
    func setCurrentSelectedAlbumWith(albumIndex: Int)
    
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
    func getSavedAlbum(for artistName: String ) -> [Albums]
    func getSavedAlbum(for artistName: String, artistMBID: String ) -> [Albums]

}
