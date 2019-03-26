//
//  SavedAlbumListLocalDataManager.swift
//  Demo
//
//  Created by sumeet mourya on 03/24/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

class SavedAlbumListLocalDataManager: SavedAlbumListLocalDataManagerInputProtocol {
    
    private let coreDataManagerObj: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        coreDataManagerObj = coreDataManager
    }
    
    func getSavedAlbum() -> [SearchAlbumArtistDataItem] {
        
        let getSavedAlbums = coreDataManagerObj.fetchEntireDataData(Albums.self)
        var albums = [SearchAlbumArtistDataItem]()
        
        for album in getSavedAlbums {
            
            let albumJSON = """
                {
                "name": "\(album.albumName ?? "")",
                "playcount": \(album.albumPlayCount),
                "url": "\(album.albumURL ?? "")",
                "albumMBID": "\(album.albumMBID ?? "")",
                "artist": {
                    "name": "\(album.artistName ?? "")",
                    "mbid": "\(album.artistMBID ?? "")",
                    "url": ""
                },
                "image": [
                    {
                        "#text": "\(album.albumCoverSmallImageURL ?? "")",
                        "size": "medium"
                    },
                    {
                        "#text": "\(album.albumCoverLargeImageURL ?? "")",
                        "size": "extralarge"
                    }
                ]
                }
                """
                        
            let albumJSONValue = albumJSON.data(using: .utf8)!
            let decoder = JSONDecoder()
            if var albumDecoder = try? decoder.decode(SearchAlbumArtistDataItem.self, from: albumJSONValue) {
                albumDecoder.updateSaved(status: true)
                albums.append(albumDecoder)
            }
        }
        
        return albums
    }
    
    
}
