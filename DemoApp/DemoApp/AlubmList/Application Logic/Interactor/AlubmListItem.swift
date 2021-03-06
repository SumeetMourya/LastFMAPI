//
//  AlubmListItem.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

struct AlbumInfoRequestParam {
    
    let artistName: String
    let albumName: String
    let albumStatus: Bool
    let artistMBID: String

}

struct AlbumImageData: Decodable {
    
    var artistImageURL: String? = nil
    var artistImageSize: String? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case url = "#text"
        case type = "size"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        artistImageURL = try? container.decode(String.self, forKey: .url)
        artistImageSize = try? container.decode(String.self, forKey: .type)
        
    }
}

struct SearchAlbumArtistDataItem: Decodable {
    
    let albumName : String?
    let albumPlayCount : Int?
    let albumURL : String?
    let albumMBID : String?
    var albumCoverSmallImageURL: String? = nil
    var albumCoverLargeImageURL: String? = nil
    var albumSaved: Bool = false

    enum CodingKeys: String, CodingKey {
        
        case name
        case playcount
        case url
        case artist
        case image
        case mbid
    }
    
    let artistName : String?
    let artistMBID : String?
    let artistProfileURL : String?
    
    enum ArtistDataCodingKeys: String, CodingKey {
        
        case name
        case mbid
        case url
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.albumName = try? container.decode(String.self, forKey: .name)
        
        self.albumPlayCount = try? container.decode(Int.self, forKey: .playcount)
        self.albumURL = try? container.decode(String.self, forKey: .url)
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
        
        if let albumArtistData = try? container.nestedContainer(keyedBy: ArtistDataCodingKeys.self, forKey: .artist) {
            
            self.artistName = try? albumArtistData.decode(String.self, forKey: SearchAlbumArtistDataItem.ArtistDataCodingKeys.name)
            self.artistMBID = try? albumArtistData.decode(String.self, forKey: SearchAlbumArtistDataItem.ArtistDataCodingKeys.mbid)
            self.artistProfileURL = try? albumArtistData.decode(String.self, forKey: SearchAlbumArtistDataItem.ArtistDataCodingKeys.url)
            
        } else {
            self.artistName = nil
            self.artistMBID = nil
            self.artistProfileURL = nil
        }
    }
    
    mutating func updateSaved(status: Bool) {
        self.albumSaved = status
    }
    
}

struct SearchAlbumPageDataItem: Decodable {
    
    let artistName : String?
    let currentPageIndex : String?
    let totalNumberPages : String?
    let perPageItem : String?
    let totalNumberOfItems : String?
    
    enum CodingKeys: String, CodingKey {
        
        case artist
        case page
        case perPage
        case totalPages
        case total
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.artistName = try? container.decode(String.self, forKey: .artist)
        self.currentPageIndex = try? container.decode(String.self, forKey: .page)
        self.totalNumberPages = try? container.decode(String.self, forKey: .perPage)
        self.perPageItem = try? container.decode(String.self, forKey: .totalPages)
        self.totalNumberOfItems = try? container.decode(String.self, forKey: .total)
        
    }
}

struct SearchAlbumListData: Decodable {
    
    var listOfArtistAlbum: [SearchAlbumArtistDataItem] = [SearchAlbumArtistDataItem]()
    var pageObject: SearchAlbumPageDataItem?
    
    enum AlbumDataKeys: String, CodingKey {
        case topalbums
    }
    
    enum CodingKeys: String, CodingKey {
        case attr = "@attr"
        case album
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: AlbumDataKeys.self)
        if let albumData = try? values.nestedContainer(keyedBy: CodingKeys.self, forKey: .topalbums) {
            if let listOfAlbums = try? albumData.decode([SearchAlbumArtistDataItem].self, forKey: .album) {
                listOfArtistAlbum = listOfAlbums.filter({ $0.albumName !=  "(null)"})
            }
            
            pageObject = try? albumData.decode(SearchAlbumPageDataItem.self, forKey: .attr)
        } else {
            listOfArtistAlbum = [SearchAlbumArtistDataItem]()
            pageObject = nil
        }
        
    }
    
    mutating func appendData(needToUpdate: SearchAlbumListData) {
        
        self.pageObject = needToUpdate.pageObject
        
        for listOfAlbums in needToUpdate.listOfArtistAlbum {
            self.listOfArtistAlbum.append(listOfAlbums)
        }
    }

    mutating func appendDataStatus(listOfAlbums: [SearchAlbumArtistDataItem]) {
        self.listOfArtistAlbum = listOfAlbums
    }

    mutating func appendDataStatus(indexOfAlbum: Int) {
        
        var valueOfAlbum = self.listOfArtistAlbum[indexOfAlbum]
        let statusValue = !valueOfAlbum.albumSaved
        valueOfAlbum.updateSaved(status: statusValue)
        self.listOfArtistAlbum.remove(at: indexOfAlbum)
        self.listOfArtistAlbum.insert(valueOfAlbum, at: indexOfAlbum)
    }

}

