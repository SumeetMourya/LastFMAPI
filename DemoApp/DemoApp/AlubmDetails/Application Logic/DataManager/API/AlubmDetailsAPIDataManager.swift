//
//  AlubmDetailsAPIDataManager.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import Alamofire
import Reachability

class AlubmDetailsAPIDataManager: AlubmDetailsAPIDataManagerInputProtocol {
    
    private let reachability = Reachability()

    init() {}
    
    
    // MARK: AlubmDetailsAPIDataManagerInputProtocol Methods
    
    func loadDataForURL(url: String, onSuccess success: @escaping (_ data: AlbumInfoItem, _ apiStatusCode: ApiStatusType) -> Void, onFailure failure: @escaping (_ error: Error?, _ apiStatusCode: ApiStatusType) -> Void) {
        
        
        if (reachability?.connection == .cellular || reachability?.connection == .wifi) {
            
            guard let urlStringWithEncoding = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                failure(nil, ApiStatusType.apiEncodingIssue)
                return
            }
            
            Alamofire.request(urlStringWithEncoding).response { response in

                guard let data = response.data else {
                    failure(nil, ApiStatusType.apiEncodingIssue)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let albumInformationData = try decoder.decode(AlbumInfoItem.self, from: data)
                    success(albumInformationData, ApiStatusType.apiSucceed)
                    
                } catch let error {
                    print(error)
                    failure(error, ApiStatusType.apiParsingIssue)
                }
            }
            
        } else {
            failure(nil, ApiStatusType.netWorkIssue)
        }
        
    }

}
