//
//  AlubmListAPIDataManager.swift
//  Demo
//
//  Created by sumeet mourya on 03/23/2019.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation

class AlubmListAPIDataManager: AlubmListAPIDataManagerInputProtocol {
    init() {}

    
    //MARK: AlubmListAPIDataManagerInputProtocol methods
    
    func loadDataForURL(url: String, onSuccess success: @escaping (_ data: SearchAlbumListData, _ apiStatusCode: ApiStatusType) -> Void, onFailure failure: @escaping (_ error: Error?, _ apiStatusCode: ApiStatusType) -> Void) {
        
        let apisServiceStart = APIService()
        
        apisServiceStart.loadDataWith(urlString: url, onSuccess: { (parseData, succeedCode) in
            
            let responseStrInISOLatin = String(data: parseData, encoding: String.Encoding.isoLatin1)
            guard let modifiedDataInUTF8Format = responseStrInISOLatin?.data(using: String.Encoding.utf8) else {
                print("could not convert data to UTF-8 format")
                
                failure(nil, ApiStatusType.apiEncodingIssue)
                return
            }
            
            do {
                let searchAlbumData = try JSONDecoder().decode(SearchAlbumListData.self, from: modifiedDataInUTF8Format)
                
                success(searchAlbumData, ApiStatusType.apiSucceed)
                
            } catch let error as NSError {
                failure(error, ApiStatusType.apiParsingIssue)
            }
            
        }) { (error, errorData) in
            failure(error, errorData)
        }
        
    }
    
}
