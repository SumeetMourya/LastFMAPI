//
//  AlubmDetailsProtocols.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

protocol AlubmDetailsViewProtocol: LoaderView {
    
    var presenter: AlubmDetailsPresenterProtocol? { get set }
    
    //here your methods for communication PRESENTER -> VIEW
    func errorInLoadingDataWith(error: Error?, errorCode: ApiStatusType)
    func updateAlbumInfoDetailView(albumInforData: AlbumInfoItem)

}

protocol AlubmDetailsWireFrameProtocol: class {
    
    static func presentAlubmDetailsModule(fromView: AnyObject, requestParam: AlbumInfoRequestParam?, albumInfoData: AlbumInfoItem?)
    
    //here your methods for communication PRESENTER -> WIREFRAME

}

protocol AlubmDetailsPresenterProtocol: class {
    
    var view: AlubmDetailsViewProtocol? { get set }
    var interactor: AlubmDetailsInteractorInputProtocol? { get set }
    var wireFrame: AlubmDetailsWireFrameProtocol? { get set }
    
    //here your methods for communication VIEW -> PRESENTER
    func getAlbumInformationWithAPI()
    func getAlbumName() -> String
    func getArtistName() -> String
    func saveAlbumData(albumInforData: AlbumInfoItem) -> Bool 
    func deleteAlbumData(albumInforData: AlbumInfoItem) -> Bool 

}

protocol AlubmDetailsInteractorOutputProtocol: class {
    
    //here your methods for communication INTERACTOR -> PRESENTER
    func showActivityIndicator()
    func hideActivityIndicator()
    func hideActivityIndicatorWithError(title: String?, subtitle: String?)
    func errorInLoadingDataWith(error: Error?, errorCode: ApiStatusType)
    func updateAlbumInfoDetailView(albumInforData: AlbumInfoItem)

    
}

protocol AlubmDetailsInteractorInputProtocol: class {
    
    var presenter: AlubmDetailsInteractorOutputProtocol? { get set }
    var APIDataManager: AlubmDetailsAPIDataManagerInputProtocol? { get set }
    var localDatamanager: AlubmDetailsLocalDataManagerInputProtocol? { get set }
    
    //here your methods for communication PRESENTER -> INTERACTOR
    func getAlbumInformationWithAPI()
    func getAlbumName() -> String
    func getArtistName() -> String
    func saveAlbumData(albumInforData: AlbumInfoItem) -> Bool 
    func deleteAlbumData(albumInforData: AlbumInfoItem) -> Bool 

}

protocol AlubmDetailsDataManagerInputProtocol: class {
    
    //here your methods for communication INTERACTOR -> DATAMANAGER

}

protocol AlubmDetailsAPIDataManagerInputProtocol: class {
    
    
    //here your methods for communication INTERACTOR -> APIDATAMANAGER
    func loadDataForURL(url: String, onSuccess success: @escaping (_ data: AlbumInfoItem, _ apiStatusCode: ApiStatusType) -> Void, onFailure failure: @escaping (_ error: Error?, _ apiStatusCode: ApiStatusType) -> Void)
    

}

protocol AlubmDetailsLocalDataManagerInputProtocol: class {
    
    //here your methods for communication INTERACTOR -> LOCALDATAMANAGER
    func saveAlbumData(albumInforData: AlbumInfoItem) -> Bool 
    func deleteAlbumData(albumInforData: AlbumInfoItem) -> Bool 

}
