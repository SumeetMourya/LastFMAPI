//
//  AlubmDetailsWireFrame.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit

class AlubmDetailsWireFrame: AlubmDetailsWireFrameProtocol {

    class func presentAlubmDetailsModule(fromView: AnyObject, requestParam: AlbumInfoRequestParam?, albumInfoData: SearchAlbumArtistDataItem?) {

        // Generating module components
        guard let view: AlubmDetailsViewProtocol & LoaderView = UIStoryboard(name:"Main",bundle: Bundle.main).instantiateViewController(withIdentifier: "AlubmDetailsViewControllerID") as? AlubmDetailsViewController else {
            return
        }
        
        guard let previousView = fromView as? UIViewController else {
            return
        }
                
        let presenter: AlubmDetailsPresenterProtocol & AlubmDetailsInteractorOutputProtocol = AlubmDetailsPresenter()
        let interactor: AlubmDetailsInteractorInputProtocol = AlubmDetailsInteractor(requestParamValue: requestParam)
        let APIDataManager: AlubmDetailsAPIDataManagerInputProtocol = AlubmDetailsAPIDataManager()
        let localDataManager: AlubmDetailsLocalDataManagerInputProtocol = AlubmDetailsLocalDataManager()
        let wireFrame: AlubmDetailsWireFrameProtocol = AlubmDetailsWireFrame()

        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.APIDataManager = APIDataManager
        interactor.localDatamanager = localDataManager
       
        previousView.navigationController?.pushViewController(view as! UIViewController, animated: true)
    }
}
