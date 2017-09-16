//
//  MarvelProvider.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 08/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation
import Moya

class MarvelProvider<Model: JSONSerializable> {
    
    private var provider: MoyaProvider<Marvel>
    
    init(with provider: MoyaProvider<Marvel> = MoyaProvider<Marvel>()) {
        self.provider = provider
    }
    
    func request(target: Marvel, completionHandler: @escaping ([Model]?, MarvelError?)->()) {
        
        provider.request(target) { (result) in
            
            switch result {
            case .success(let response):
                
                do {
                    let marvelResponse = try MarvelResponse<Model>(with: response.data)
                    
                    guard let dataContainer = marvelResponse.data else {
                        completionHandler(nil, nil)
                        return
                    }
                    
                    guard let results = dataContainer.results else {
                        completionHandler(nil, nil)
                        return
                    }
                    
                    completionHandler(results, nil)
                    
                } catch {
                    completionHandler(nil, MarvelError.underlying(error))
                }
                
            case .failure(let error):
                
                let marvelError = MarvelError(with: error)
                completionHandler(nil, marvelError)
            }
        }
    }
}
