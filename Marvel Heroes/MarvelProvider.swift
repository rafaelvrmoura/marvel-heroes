//
//  MarvelProvider.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 08/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation
import Moya

class MarvelProvider<Target: TargetType, Model: JSONSerializable> {
    
    private var provider: MoyaProvider<Target>
    
    init(with provider: MoyaProvider<Target> = MoyaProvider<Target>()) {
        self.provider = provider
    }
    
    func request(target: Target, completionHandler: @escaping ([Model]?, MoyaError?)->()) {
        
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
                    completionHandler(nil, MoyaError.underlying(error))
                }
                
            case .failure(let error):
                // TODO: Handle the error
                completionHandler(nil, error)
            }
        }
    }
}
