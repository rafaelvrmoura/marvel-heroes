//
//  MarvelTypeList.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 10/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation


struct MarvelList<Type: JSONSerializable> {
    
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [Type]?
}

extension MarvelList: JSONSerializable {
    
    init(with json: [String : Any]) {
        self.available = json["available"] as? Int
        self.returned = json["returned"] as? Int
        self.collectionURI = json["collectionURI"] as? String
        
        if let itemsJSON = json["items"] as? [[String: Any]] {
            self.items = itemsJSON.map{ Type(with: $0) }
        }
    }
}
