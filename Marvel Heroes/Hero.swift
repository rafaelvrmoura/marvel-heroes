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
    
    var comics: [ComicSummary]?
    var stories: [StorySummary]?
    var events: [EventSummary]?
    var series: [SerieSummary]?
}

extension Hero: JSONSerializable {
    
    init(with json: [String : Any]) {
        
        self.id = json["id"] as? Int
        self.name = json["name"] as? String
        self.description = json["description"] as? String
        
        if let thumbnailJSON = json["thumbnail"] as? [String: Any] {
            self.thumbnail = MarvelThumbnail(with: thumbnailJSON)
        }
        
        if let comicsJSON = json["comics"] as? [String: Any] {
            self.comics = MarvelList<ComicSummary>(with: comicsJSON).items
        }
        
        if let storiesJSON = json["stories"] as? [String: Any] {
            self.stories = MarvelList<StorySummary>(with: storiesJSON).items
        }
        
        if let eventsJSON = json["events"] as? [String: Any] {
            self.events = MarvelList<EventSummary>(with: eventsJSON).items
        }
        
        if let seriesJSON = json["series"] as? [String: Any] {
            self.series = MarvelList<SerieSummary>(with: seriesJSON).items
        }
    }
}


struct CharacterSummary {
    
    var comicID: Int? {
        guard let stringID = resourceURI?.components(separatedBy: "/").last else { return nil }
        let id = Int(stringID)
        return id
    }
    
    var resourceURI: String?
    var name: String?
}

extension CharacterSummary: JSONSerializable {
    init(with json: [String : Any]) {
        self.resourceURI = json["resourceURI"] as? String
        self.name = json["name"] as? String
    }
}
