//
//  SearchListAPIDataManager.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import Reachability
import Alamofire


class SearchListAPIDataManager: SearchListAPIDataManagerInputProtocol {
 
    let reachability = Reachability()

    init() {}
    
    
    //MARK: SearchListAPIDataManagerInputProtocol Method

    func loadDataForURL(url: String, onSuccess success: @escaping (_ data: GetSearchData, _ apiStatusCode: ApiStatusType) -> Void, onFailure failure: @escaping (_ error: Error?, _ apiStatusCode: ApiStatusType) -> Void) {
        
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
                    let artistSearchData = try decoder.decode(GetSearchData.self, from: data)
                    success(artistSearchData, ApiStatusType.apiSucceed)
                    
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
