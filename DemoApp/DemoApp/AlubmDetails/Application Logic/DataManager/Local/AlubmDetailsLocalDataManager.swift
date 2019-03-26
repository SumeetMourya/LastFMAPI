//
//  AlubmDetailsLocalDataManager.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import CoreData

class AlubmDetailsLocalDataManager: AlubmDetailsLocalDataManagerInputProtocol {
    
    private let coreDataManagerObj: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        coreDataManagerObj = coreDataManager
    }
    
    func saveAlbumData(albumInforData: AlbumInfoItem) -> Bool  {
        
        if let context = coreDataManagerObj.managedObjectContext {
            
            let album = Albums(context: context)
            album.albumName = albumInforData.albumName
            album.albumCoverLargeImageURL = albumInforData.albumCoverLargeImageURL
            album.albumCoverSmallImageURL = albumInforData.albumCoverSmallImageURL
            album.albumListenersCount = albumInforData.albumListenersCount
            if let albumPlayCountInString = albumInforData.albumPlayCount, let albumPlayCount = Int32(albumPlayCountInString) {
                album.albumPlayCount = albumPlayCount
            }
            
            album.albumMBID = albumInforData.albumMBID
            album.albumURL = albumInforData.albumURL
            album.artistName = albumInforData.artistName
            
            for albumTrack in albumInforData.tracks {
                let track = Tracks(context: context)
                track.trackDuration = albumTrack.trackDuration
                track.trackName = albumTrack.trackName
                if let trackOrder = albumTrack.trackOrder {
                    track.trackOrder = Int32(trackOrder)
                }
                track.trackURL = albumTrack.trackURL
                track.albumMBID = albumInforData.albumMBID
                track.artistName = albumInforData.artistName
                track.albumName = albumInforData.albumName
                
            }

            return coreDataManagerObj.save()
        }
        return false
    }
    
    func deleteAlbumData(albumInforData: AlbumInfoItem) -> Bool {

        // This will directly operat on the Context
        /*
        guard let context = coreDataManagerObj.managedObjectContext, let albumIDValue = albumInforData.albumMBID  else {
            return false
        }

        if let result = try? context.fetch(Albums.fetchRequestWith(albumID: albumIDValue)) {
            for object in result {
                context.delete(object)
            }
        }

        if let result = try? context.fetch(Tracks.fetchRequestWith(albumID: albumIDValue)) {
            for object in result {
                context.delete(object)
            }
        }
        return coreDataManagerObj.save()
         
        */
        
        // This will operate on private instance of CoreDataManager and delete operation will be one by one after fetching the data
        /*
        guard let albumIDValue = albumInforData.albumMBID  else {
            return false
        }

        let albumFound = coreDataManagerObj.fetchData(Albums.fetchRequestWith(albumID: albumIDValue))
        for album in albumFound {
            coreDataManagerObj.delete(album)
        }

        let albumTracksFound = coreDataManagerObj.fetchData(Tracks.fetchRequestWith(albumID: albumIDValue))
        for track in albumTracksFound {
            coreDataManagerObj.delete(track)
        }
        */

        // This will operate on private instance of CoreDataManager and call method for delete Batch request
        
        /*
        guard let albumIDValue = albumInforData.albumMBID  else {
            return false
        }
        
        var albumDeleted = false
        var allTracksDeleted = false
        if coreDataManagerObj.deleteRecords(Albums.fetchRequestResultWith(albumID: albumIDValue)) {
            albumDeleted = true
        }
        
        if coreDataManagerObj.deleteRecords(Tracks.fetchRequestResultWith(albumID: albumIDValue)) {
            allTracksDeleted = true
        }

        return albumDeleted && allTracksDeleted
        */
        
        var albumDeleted = false
        var allTracksDeleted = false

        if let albumIDValue = albumInforData.albumMBID {
            
            if coreDataManagerObj.deleteRecords(Albums.fetchRequestResultWith(albumID: albumIDValue)) {
                albumDeleted = true
            }
            
            if coreDataManagerObj.deleteRecords(Tracks.fetchRequestResultWith(albumID: albumIDValue)) {
                allTracksDeleted = true
            }
            
            return albumDeleted && allTracksDeleted
            
        } else {
            
            if coreDataManagerObj.deleteRecords(Albums.fetchRequestResultWith(artistName: albumInforData.artistName ?? "", albumName: albumInforData.albumName ?? "")) {
                albumDeleted = true
            }
            
            if coreDataManagerObj.deleteRecords(Tracks.fetchRequestResultWith(artistName: albumInforData.artistName ?? "", albumName: albumInforData.albumName ?? "")) {
                allTracksDeleted = true
            }
            
            return albumDeleted && allTracksDeleted
        }
        
    }
    
}
