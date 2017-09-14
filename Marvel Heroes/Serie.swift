//
//  Serie.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation

struct SerieSummary {
    
    var serieID: Int? {
        guard let stringID = resourceURI?.components(separatedBy: "/").last else { return nil }
        let id = Int(stringID)
        return id
    }
    
    var resourceURI: String?
    var name: String?
}

extension SerieSummary: JSONSerializable {
    
    init(with json: [String : Any]) {
        self.resourceURI = json["resourceURI"] as? String
        self.name = json["name"] as? String
    }
}

struct Serie {
    
    var id: Int?
    var title: String?
    var description: String?
    var startYear: Int?
    var endYear: Int?
    var rating: String?
    var thumbnail: MarvelThumbnail?
    
    var comics: [ComicSummary]?
    var stories: [StorySummary]?
    var events: [EventSummary]?
    var characters: [CharacterSummary]?
    var creators: [CreatorSummary]?

    var next: SerieSummary?
    var previous: SerieSummary?
}


extension Serie: JSONSerializable {
    init(with json: [String : Any]) {
        
        self.id = json["id"] as? Int
        self.title = json["title"] as? String
        self.description = json["description"] as? String
        self.startYear = json["startYear"] as? Int
        self.endYear = json["ednYear"] as? Int
        self.rating = json["rating"] as? String
        
        if let thumbnailJSON = json["thumbnail"] as? [String: Any] {
            self.thumbnail = MarvelThumbnail(with: thumbnailJSON)
        }
        
        if let comicsJSON = json["comics"] as? [String: Any] {
            self.comics = MarvelList<ComicSummary>(with: comicsJSON).items
        }
        
        if let eventsJSON = json["events"] as? [String: Any] {
            self.events = MarvelList<EventSummary>(with: eventsJSON).items
        }
        
        if let charactersJSON = json["characters"] as? [String: Any] {
            self.characters = MarvelList<CharacterSummary>(with: charactersJSON).items
        }
        
        if let creatorsJSON = json["creators"] as? [String: Any] {
            self.creators = MarvelList<CreatorSummary>(with: creatorsJSON).items
        }
        
        if let nextJSON = json["next"] as? [String: Any] {
            self.next = SerieSummary(with: nextJSON)
        }
        
        if let previousJSON = json["previous"] as? [String: Any] {
            self.previous = SerieSummary(with: previousJSON)
        }
    }
}
