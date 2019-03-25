//
//  SavedAlbumListWireFrame.swift
//  Demo
//
//  Created by sumeet mourya on 03/24/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit

class SavedAlbumListWireFrame: SavedAlbumListWireFrameProtocol {

    class func presentSavedAlbumListModule(fromView: AnyObject) {

        // Generating module components
        guard let view: SavedAlbumListViewProtocol = UIStoryboard(name:"Main",bundle: Bundle.main).instantiateViewController(withIdentifier: "SavedAlbumListViewControllerID") as? SavedAlbumListViewController else {
            return
        }
        
        guard let navViews = fromView as? UINavigationController else {
            return
        }
        navViews.viewControllers = [view] as! [UIViewController]
        
        let presenter: SavedAlbumListPresenterProtocol & SavedAlbumListInteractorOutputProtocol = SavedAlbumListPresenter()
        let interactor: SavedAlbumListInteractorInputProtocol = SavedAlbumListInteractor()
        let APIDataManager: SavedAlbumListAPIDataManagerInputProtocol = SavedAlbumListAPIDataManager()
        let localDataManager: SavedAlbumListLocalDataManagerInputProtocol = SavedAlbumListLocalDataManager()
        let wireFrame: SavedAlbumListWireFrameProtocol = SavedAlbumListWireFrame()

        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.APIDataManager = APIDataManager
        interactor.localDatamanager = localDataManager
    }
    
    func openSearchForArtists(fromView view: AnyObject) {
        SearchListWireFrame.presentSearchListModule(fromView: view)
    }
    
    func goToSearchForAlbums(fromView view: AnyObject, selectedArtistData: SearchArtistDataItem) {
       
        AlubmListWireFrame.presentAlubmListModule(fromView: view, selectedArtist: selectedArtistData)

//        guard let previousView = view as? UIViewController else {
//            return
//        }
//
//        previousView.dismiss(animated: true) {
//            print("need to check")
//
//            AlubmListWireFrame.presentAlubmListModule(fromView: view, selectedArtist: selectedArtistData)
//        }
    }
    
}
