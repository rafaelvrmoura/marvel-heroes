//
//  Hero.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation

struct Hero {
    
    var id: Int?
    var name: String?
    var description: String?
    var thumbnail: MarvelThumbnail?
}

extension Hero: JSONSerializable {
    
    init(with json: [String : Any]) {
        
        self.id = json["id"] as? Int
        self.name = json["name"] as? String
        self.description = json["description"] as? String
        
        if let thumbnailJSON = json["thumbnail"] as? [String: Any] {
            self.thumbnail = MarvelThumbnail(with: thumbnailJSON)
        }
    }
}
