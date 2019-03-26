//
//  AlubmListLocalDataManager.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

class AlubmListLocalDataManager: AlubmListLocalDataManagerInputProtocol {
    
    private let coreDataManagerObj: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        coreDataManagerObj = coreDataManager
    }
    
    func getSavedAlbum(for artistName: String ) -> [Albums] {
        
        if let context = coreDataManagerObj.managedObjectContext {
        
            if let result = try? context.fetch(Albums.fetchRequestWith(artistName: artistName)) {
                return result
            } else {
                return [Albums]()
            }
        } else {
            return [Albums]()
        }
    }
    
    func getSavedAlbum(for artistName: String, artistMBID: String ) -> [Albums] {
        
        if let context = coreDataManagerObj.managedObjectContext {
            
            if let result = try? context.fetch(Albums.fetchRequestWith(artistMBID: artistName, artistName: artistMBID)) {
                return result
            } else {
                return [Albums]()
            }
        } else {
            return [Albums]()
        }

    }
    
}
