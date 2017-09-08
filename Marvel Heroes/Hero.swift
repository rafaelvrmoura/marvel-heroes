//
//  Hero.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation
import CoreData

struct Hero: JSONSerializable {
    
    var id: Int?
    var name: String?
    var description: String?
    var thumbnail: MarvelThumbnail?
    
    var comics: [Comic]?
    var stories: [Storie]?
    var events: [Event]?
    var Series: [Serie]?
    
    init(with json: [String : Any]) {
        
        self.id = json["id"] as? Int
        self.name = json["name"] as? String
        self.description = json["description"] as? String
        
        if let thumbnailJSON = json["thumbnail"] as? [String: Any] {
            self.thumbnail = MarvelThumbnail(with: thumbnailJSON)
        }
    }
}
