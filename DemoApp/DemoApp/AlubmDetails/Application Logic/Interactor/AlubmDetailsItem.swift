//
//  AlubmDetailsItem.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation


struct AlbumTrackItem: Decodable {
    
    let trackName : String?
    let trackURL : String?
    let trackDuration : String?
    let trackOrder : Int?

    enum TrackRankKeys: String, CodingKey {
        case rank
    }

    enum TrackDataKeys: String, CodingKey {
        
        case name
        case url
        case duration
        case attr = "@attr"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: TrackDataKeys.self)
        
        self.trackName = try? container.decode(String.self, forKey: .name)
        self.trackURL = try? container.decode(String.self, forKey: .url)
        self.trackDuration = try? container.decode(String.self, forKey: .duration)
        
        
        if let trackRankData = try? container.nestedContainer(keyedBy: TrackRankKeys.self, forKey: .attr) {
            
            if let trackRankDataValue = try? trackRankData.decode(String.self, forKey: AlbumTrackItem.TrackRankKeys.rank), let rankValue = Int(trackRankDataValue) {
                trackOrder = rankValue
            } else {
                trackOrder = 0
            }
        } else {
            trackOrder = 0
        }

    }
}


struct AlbumInfoItem: Decodable {

    let albumSaved: Bool = false
    let albumName: String?
    let artistName: String?
    let albumPlayCount: String?
    let albumListenersCount: String?
    let albumMBID: String?
    var tracks: [AlbumTrackItem] = [AlbumTrackItem]()
    var albumCoverSmallImageURL: String? = nil
    var albumCoverLargeImageURL: String? = nil
    
    enum AlbumDataKeys: String, CodingKey {
        case album
    }

    enum CodingKeys: String, CodingKey {
        
        case name
        case artist
        case playcount
        case listeners
        case mbid
        case image
        case tracks
    }
    
    enum TrackDataKeys: String, CodingKey {
        case track
    }

    init(from decoder: Decoder) throws {
        
        let albumDataContainer = try decoder.container(keyedBy: AlbumDataKeys.self)
        
        if let container = try? albumDataContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .album) {
            
            self.albumName = try? container.decode(String.self, forKey: .name)
            self.artistName = try? container.decode(String.self, forKey: .artist)
            self.albumPlayCount = try? container.decode(String.self, forKey: .playcount)
            self.albumListenersCount = try? container.decode(String.self, forKey: .listeners)
            self.albumMBID = try? container.decode(String.self, forKey: .mbid)
            
            if let imagesArrayData = try? container.decode([AlbumImageData].self, forKey: .image) {
                
                for image in imagesArrayData {
                    if image.artistImageSize == "medium" {
                        albumCoverSmallImageURL = image.artistImageURL
                    }
                    
                    if image.artistImageSize == "extralarge" {
                        albumCoverLargeImageURL = image.artistImageURL
                    }
                }
            }
            
            if let trackDataValues = try? container.nestedContainer(keyedBy: TrackDataKeys.self, forKey: .tracks) {
                
                if let tracksValue  = try? trackDataValues.decode([AlbumTrackItem].self, forKey: AlbumInfoItem.TrackDataKeys.track) {
                    tracks = tracksValue
                }
            }
        } else {
            self.albumName = nil
            self.artistName = nil
            self.albumPlayCount = nil
            self.albumListenersCount = nil
            self.albumMBID = nil

        }
        
    }
}


