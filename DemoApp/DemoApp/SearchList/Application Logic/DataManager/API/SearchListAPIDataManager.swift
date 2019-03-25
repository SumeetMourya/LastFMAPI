//
//  SearchListAPIDataManager.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

class SearchListAPIDataManager: SearchListAPIDataManagerInputProtocol {
 
    init() {}
    
    
    //MARK: SearchListAPIDataManagerInputProtocol Method

    func loadDataForURL(url: String, onSuccess success: @escaping (_ data: GetSearchData, _ apiStatusCode: ApiStatusType) -> Void, onFailure failure: @escaping (_ error: Error?, _ apiStatusCode: ApiStatusType) -> Void) {
        
        let apisServiceStart = APIService()
        
        apisServiceStart.loadDataWith(urlString: url, onSuccess: { (parseData, succeedCode) in
            
            let responseStrInISOLatin = String(data: parseData, encoding: String.Encoding.isoLatin1)
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                print("could not convert data to UTF-8 format")
                
                failure(nil, ApiStatusType.apiEncodingIssue)
                return
            }
            
            do {
                let artistSearchData = try JSONDecoder().decode(GetSearchData.self, from: modifiedDataInUTF8Format)
                
                success(artistSearchData, ApiStatusType.apiSucceed)
                
            } catch let error as NSError {
                failure(error, ApiStatusType.apiParsingIssue)
            }
            
        }) { (error, errorData) in
            failure(error, errorData)
        }
        
    }
    
}
