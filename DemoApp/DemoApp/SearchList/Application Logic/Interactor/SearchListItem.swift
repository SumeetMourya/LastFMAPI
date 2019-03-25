//
//  SearchListItem.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

struct ArtistImageData: Decodable {
    
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

        /*
        let urlValue = try? container.decode(String.self, forKey: .url)
        if let typeValue = try? container.decode(String.self, forKey: .type) {
            
            if ( artistSmallImageURL == nil && typeValue == "small") {
                artistSmallImageURL = urlValue
            } else {
                artistSmallImageURL = nil
            }

            if ( artistLargeImageURL == nil && typeValue == "large") {
                artistLargeImageURL = urlValue
            } else {
                artistLargeImageURL = nil
            }
        }
        */
    }
}

struct SearchArtistDataItem: Decodable{
    
    let artistName : String?
    let artistMBID : String?
    let artistProfileURL : String?
    let artistListenersCount: String?
    var artistSmallImageURL: String? = nil
    var artistLargeImageURL: String? = nil

    enum CodingKeys: String, CodingKey {
        
        case name
        case mbid
        case url
        case listeners
        case image
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.artistName = try? container.decode(String.self, forKey: .name)
        self.artistMBID = try? container.decode(String.self, forKey: .mbid)
        self.artistProfileURL = try? container.decode(String.self, forKey: .url)
        self.artistListenersCount = try? container.decode(String.self, forKey: .listeners)

        if let imagesArrayData = try? container.decode([ArtistImageData].self, forKey: .image) {
            
            for image in imagesArrayData {
                if image.artistImageSize == "medium" {
                    artistSmallImageURL = image.artistImageURL
                }
                
                if image.artistImageSize == "extralarge" {
                    artistLargeImageURL = image.artistImageURL
                }
            }
        }
    }
    
}

struct SearchPageDataItem {
    
    let currentPageIndex : String?
    let currentPageStartingIndex : String?
    let perPageItem : String?
    let totalNumberOfItems : String?
    
}

struct GetSearchData: Decodable {
    
    var listOfArtists: [SearchArtistDataItem] = [SearchArtistDataItem]()
    var pageObject: SearchPageDataItem?
    
    enum ResultKey: String, CodingKey {
        case results
    }
    
    enum CodingKeys: String, CodingKey {
        
        case startIndex = "opensearch:startIndex"
        case itemPerPage = "opensearch:itemsPerPage"
        case totalResultCount = "opensearch:totalResults"
        case searchQuery = "opensearch:Query"
        case artistmatches

    }

    enum SearchQueryKeys: String, CodingKey {
        case startPage
    }

    enum ArtistDataKeys: String, CodingKey {
        case artist
    }
    
    init(from decoder: Decoder) throws {
        
        let dataOfDecoded = try decoder.container(keyedBy: ResultKey.self)
        
        if let resultValues = try? dataOfDecoded.nestedContainer(keyedBy: CodingKeys.self, forKey: .results) {

            
            if let artistData = try? resultValues.nestedContainer(keyedBy: ArtistDataKeys.self, forKey: .artistmatches), let artistListData = try? artistData.decode([SearchArtistDataItem].self, forKey: .artist) {
                listOfArtists = artistListData
            }

            if let queryData = try? resultValues.nestedContainer(keyedBy: SearchQueryKeys.self, forKey: .searchQuery) {
                
                pageObject = SearchPageDataItem(currentPageIndex: (try? queryData.decode(String.self, forKey: .startPage)), currentPageStartingIndex: (try? resultValues.decode(String.self, forKey: CodingKeys.startIndex)), perPageItem: (try? resultValues.decode(String.self, forKey: CodingKeys.itemPerPage)), totalNumberOfItems: (try? resultValues.decode(String.self, forKey: CodingKeys.totalResultCount)))
            }
            
        } else {
            listOfArtists = [SearchArtistDataItem]()
            pageObject = nil
        }

    }
    
    mutating func appendData(needToUpdate: GetSearchData) {
        
        self.pageObject = needToUpdate.pageObject
        
        for listOfArtists in needToUpdate.listOfArtists {
            self.listOfArtists.append(listOfArtists)
        }
    }
    
}

