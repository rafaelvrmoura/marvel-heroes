//
//  MarvelResponse.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation

struct MarvelResponse<T: JSONSerializable> {
    
    var code: Int?
    var status: String?
    var copyright: String?
    var etag: String?
    var data: MarvelDataContainer<T>?
    
    init(with data: Data) throws {
        
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        
        self.code = jsonObject["code"] as? Int
        self.status = jsonObject["status"] as? String
        self.copyright = jsonObject["copyright"] as? String
        self.etag = jsonObject["etag"] as? String
        
        if let responseData = jsonObject["data"] as? [String: Any] {
            self.data = MarvelDataContainer(with: responseData)
        }
    }
}

struct MarvelDataContainer<T: JSONSerializable> {
    
    var offset: Int?
    var limit: Int?
    var total: Int?   // The total number of resources available given the request filter set.
    var count: Int?   // The total number of results returned by the call.
    var results: [T]? // The list of elements returned by the call
    
    init(with json: [String: Any]) {
        
        self.offset = json["offset"] as? Int
        self.limit = json["limit"] as? Int
        self.total = json["total"] as? Int
        self.count = json["count"] as? Int
        
        self.results = (json["results"] as? [[String: Any]])?.map{T(with: $0)}
    }
}

protocol JSONSerializable {
    init(with json: [String: Any])
}

