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
    
    //This methods will genrate the JSON string for creating the Decode data for AlbumInfoItem
    
    func getTracksDataInString(artistName: String, albumName: String) -> String {
        
        let albumTracks = coreDataManagerObj.fetchData(Tracks.fetchRequestWith(artistName: artistName, albumName: albumName))
        
        var trackStringValue: String = ""
        
        for index in 0..<albumTracks.count {
            
            let track = albumTracks[index]
            let trackStringValueUpdate = """
            {
            "name": "\(track.trackName ?? "")",
            "url": "\(track.trackURL ?? "")",
            "duration": "\(track.trackDuration ?? "")",
            "@attr": {
            "rank": "\(track.trackOrder)"
            }
            }
            """
            trackStringValue = trackStringValue + trackStringValueUpdate + (index == (albumTracks.count - 1) ? "" : ",")
        }
        
        return trackStringValue
        
    }

    //MARK: SavedAlbumListLocalDataManagerInputProtocol Methdos
    
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
    
    func getAlbumDecoded(objectNeedtoConvert: SearchAlbumArtistDataItem) -> AlbumInfoItem? {
        
        guard let albumNameValue = objectNeedtoConvert.albumName, let artistNameValue = objectNeedtoConvert.artistName else {
            return nil
        }

        let albumFound = coreDataManagerObj.fetchData(Albums.fetchRequestWith(artistName: artistNameValue, albumName: albumNameValue))
        let tracks = self.getTracksDataInString(artistName: artistNameValue, albumName: albumNameValue)
       
        if albumFound.count == 1 {
            let albumValue = albumFound[0]
            
            let albumJSON = """
            {
            "album": {
            "name": "\(albumValue.albumName ?? "")",
            "artist": "\(albumValue.artistName ?? "")",
            "url": "\(albumValue.albumURL ?? "")",
            "image": [
            {
            "#text": "\(albumValue.albumCoverSmallImageURL ?? "")",
            "size": "medium"
            },
            {
            "#text": "\(albumValue.albumCoverLargeImageURL ?? "")",
            "size": "extralarge"
            }
            ],
            "listeners": "\(albumValue.albumListenersCount ?? "")",
            "playcount": "\(albumValue.albumPlayCount)",
            "tracks": {
            "track":
            [
            \(tracks)
            ]
            }
            }
            }
            """

            if let albumJSONValue = albumJSON.replacingOccurrences(of: "\n", with: "").data(using: .utf8) {
                let decoder = JSONDecoder()
                if var albumDecoder = try? decoder.decode(AlbumInfoItem.self, from: albumJSONValue) {
                    albumDecoder.updateAlbumSaveStatus(value: true)
                    return albumDecoder
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }

    }
    
    
}
