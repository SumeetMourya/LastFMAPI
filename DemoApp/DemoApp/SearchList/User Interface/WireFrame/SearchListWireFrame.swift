//
//  SearchListWireFrame.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit

class SearchListWireFrame: SearchListWireFrameProtocol {
    
    static func presentSearchListModule(fromView: AnyObject) {

        // Generating module components
        guard let view: SearchListViewProtocol & UISearchResultsUpdating = UIStoryboard(name:"Main",bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchListViewControllerID") as? SearchListViewController else {
            return
        }

        let searchViewController: UISearchController = UISearchController(searchResultsController: view as? UIViewController)
        searchViewController.searchResultsUpdater = view
        searchViewController.hidesNavigationBarDuringPresentation = false
        searchViewController.searchBar.keyboardType = UIKeyboardType.asciiCapable
        searchViewController.searchBar.placeholder = "Search for Artist name"

        
        guard let previousView = fromView as? SavedAlbumListViewController else {
            return
        }
        
        previousView.present(searchViewController, animated: true, completion: nil)
        
//        let presenter: SearchListPresenterProtocol & SearchListInteractorOutputProtocol = SearchListPresenter()
        let presenter = SearchListPresenter()
        let interactor: SearchListInteractorInputProtocol = SearchListInteractor()
        let APIDataManager: SearchListAPIDataManagerInputProtocol = SearchListAPIDataManager()
        let localDataManager: SearchListLocalDataManagerInputProtocol = SearchListLocalDataManager()
        let wireFrame: SearchListWireFrameProtocol = SearchListWireFrame()

        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        presenter.delegate = previousView
        interactor.presenter = presenter
        interactor.APIDataManager = APIDataManager
        interactor.localDatamanager = localDataManager
    }
    
    func goToSearchForAlbums(fromView view: AnyObject, selectedArtistData: SearchArtistDataItem) {
        
        guard let previousView = view as? SearchListViewController else {
            return
        }

        previousView.dismiss(animated: true) {
            print("need to check")
            previousView.presenter?.openSelectedArtistForAlbum(data: selectedArtistData)
        }
        
    }
    
    
}
