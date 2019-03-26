//
//  AlubmListWireFrame.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit

class AlubmListWireFrame: AlubmListWireFrameProtocol {
    

    //MARK: AlubmListWireFrameProtocol Methdos
    
    static func presentAlubmListModule(fromView: AnyObject, selectedArtist: SearchArtistDataItem) {

        // Generating module components
        let view: AlubmListViewProtocol = UIStoryboard(name:"Main",bundle: Bundle.main).instantiateViewController(withIdentifier: "AlubmListViewControllerID") as! AlubmListViewController

        let presenter: AlubmListPresenterProtocol & AlubmListInteractorOutputProtocol = AlubmListPresenter()
        let interactor: AlubmListInteractorInputProtocol = AlubmListInteractor(artistData: selectedArtist)
        let APIDataManager: AlubmListAPIDataManagerInputProtocol = AlubmListAPIDataManager()
        let localDataManager: AlubmListLocalDataManagerInputProtocol = AlubmListLocalDataManager(coreDataManager: CoreDataManager.sharedDatabaseManager)
        let wireFrame: AlubmListWireFrameProtocol = AlubmListWireFrame()

        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.APIDataManager = APIDataManager
        interactor.localDatamanager = localDataManager

        guard let previousView = fromView as? UIViewController else {
            return
        }
        
        previousView.navigationController?.pushViewController(view as! UIViewController, animated: true)
    }    

    func goToSearchAlbumsDetail(fromView view: AnyObject, selectedAlbum: AlbumInfoRequestParam) {
        AlubmDetailsWireFrame.presentAlubmDetailsModule(fromView: view, requestParam: selectedAlbum, albumInfoData: nil)
    }

}
