//
//  APIService.swift
//  DemoApp
//
//  Created by sumeet mourya on 23/03/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation
import Reachability

enum ApiStatusType: Int {
    
    case apiSucceed = 0
    case netWorkIssue = -1
    case apiIssue = -2
    case apiParsingIssue = -3
    case apiEncodingIssue = -4
    case Invalid_service = 2// : Invalid service - This service does not exist
    case Invalid_Method = 3//- No method with that name in this package
    case Authentication_Failed = 4// - You do not have permissions to access the service
    case Invalid_format = 5// - This service doesn't exist in that format
    case Invalid_parameters = 6// - Your request is missing a required parameter
    case Invalid_resource_specified = 7
    case Operation_failed = 8// - Something else went wrong
    case Invalid_session_key = 9// - Please re-authenticate
    case Invalid_API_key = 10// - You must be granted a valid key by last.fm
    case Service_Offline = 11// - This service is temporarily offline. Try again later.
    case Invalid_method_signature_supplied = 13
    case There_was_a_temporary_error_processing_your_request = 16//. Please try again
    case Suspended_API_key = 26// - Access for your account has been suspended, please contact Last.fm
    case Rate_limit_exceeded = 29// - Your IP has made too many requests in a short period
    case none

}

struct ErrorDescriptionKeys {
    
    static let titleKey = "title"
    static let subTitleKey = "subtitle"
    static let statusCodeKey = "statusCode"
    
}

struct API {
    
    static let secreateKeyValue = "3dc096c88ceb7bf7f4b56a26e98bb001"
    static let baseUrlValue = "http://ws.audioscrobbler.com/"
    static let apiPath = "2.0/?"
    static let jsonFormat = "json"


    //Search Artist for Given Artist name: URL..... SAMPLE
//    http://ws.audioscrobbler.com/2.0/?method=artist.search&artist=cher&api_key=3dc096c88ceb7bf7f4b56a26e98bb001&page=2&limit=10&format=json
    static func urlSearchArtistRequestWith(artistName: String, pageIndex: Int, pageLimit: Int) -> String {
        return API.baseUrlValue + API.apiPath + "method=artist.search&artist=\(artistName)&api_key=\(API.secreateKeyValue)&page=\(pageIndex)&limit=\(pageLimit)&format=\(API.jsonFormat)"
    }

    //Search albums of Artist for Given Artist name: URL..... SAMPLE
//    http://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums&artist=cher&api_key=3dc096c88ceb7bf7f4b56a26e98bb001&page=2&limit=10&format=json
    static func urlSearchAlbumForArtistRequest(artistName: String, pageIndex: Int, pageLimit: Int) -> String {
        return API.baseUrlValue + API.apiPath + "method=artist.gettopalbums&artist=\(artistName)&api_key=\(API.secreateKeyValue)&page=\(pageIndex)&limit=\(pageLimit)&format=\(API.jsonFormat)"
    }

    //Get Album Data for Given Artist name and Album Name: URL..... SAMPLE
//    http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=3dc096c88ceb7bf7f4b56a26e98bb001&artist=Cher&album=Believe&page=1&limit=20&format=json
    static func urlArtistsAlbumDataRequest(artistName: String, albumName: String) -> String {
        return API.baseUrlValue + API.apiPath + "method=album.getinfo&api_key=\(API.secreateKeyValue)&artist=\(artistName)&album=\(albumName)&format=\(API.jsonFormat)"
    }

    
}



class APIService {
    
    let reachability = Reachability()
    
    init() { }
    
    func loadDataWith(urlString: String, onSuccess success: @escaping (_ data: Data, _ apiStatusCode: ApiStatusType) -> Void, onFailure failure: @escaping (_ error: Error?, _ apiStatusCode: ApiStatusType) -> Void) {
        
        if (reachability?.connection == .cellular || reachability?.connection == .wifi) {
            
            let urlStringWithEncoding = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

            guard let url = URL(string: urlStringWithEncoding ?? "") else {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let errorValue = error {
                    failure(errorValue, ApiStatusType.apiIssue)
                } else if let data = data {
                    success(data, ApiStatusType.apiSucceed)
                } else {
                    failure(nil, ApiStatusType.netWorkIssue)
                }
                
            }
            task.resume()
            
        } else {
            failure(nil, ApiStatusType.netWorkIssue)
        }
        
    }
    
}

