//
//  SearchListPresenter.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

class SearchListPresenter: SearchListPresenterProtocol, SearchListInteractorOutputProtocol {
    
    weak var view: SearchListViewProtocol?
    var interactor: SearchListInteractorInputProtocol?
    var wireFrame: SearchListWireFrameProtocol?
    var delegate: ArtistSearchScreenDelegate?

    init() {}
    
    
    // MARK: SearchListInteractorInputProtocol Methods
    
    func getData(refreshData: Bool, artistName: String) {
        self.interactor?.getData(refreshData: refreshData, artistName: artistName)
    }
    
    func goToSearchForAlbums(selectedArtistData: SearchArtistDataItem) {
        guard let baseView = self.view else {
            return
        }
        self.wireFrame?.goToSearchForAlbums(fromView: baseView, selectedArtistData: selectedArtistData)
    }
    
    func openSelectedArtistForAlbum(data: SearchArtistDataItem) {
        delegate?.ArtistSearchSelected(selectedArtistData: data)
    }

    //MARK: SearchListInteractorOutputProtocol Methods
    
    func updateArtistSearchList(searchArtistData: [SearchArtistDataItem], needToUpdate: Bool, needToShowEmpty: Bool) {
        self.view?.updateArtistSearchList(searchArtistData: searchArtistData, needToUpdate: needToUpdate, needToShowEmpty: needToShowEmpty)
    }

    func errorInLoadingDataWith(error: Error?, errorCode: ApiStatusType) {
        self.view?.errorInLoadingDataWith(error: error, errorCode: errorCode)
    }

    

}
