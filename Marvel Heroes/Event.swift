//
//  Event.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation

struct EventSummary {
    
    var eventID: Int? {
        guard let stringID = resourceURI?.components(separatedBy: "/").last else { return nil }
        let id = Int(stringID)
        return id
    }
    
    var resourceURI: String?
    var name: String?
}

extension EventSummary: JSONSerializable {
    init(with json: [String : Any]) {
        self.resourceURI = json["resourceURI"] as? String
        self.name = json["name"] as? String
    }
}

struct Event {
    
    var id: Int?
    var title: String?
    var description: String?
    var start: Date?
    var end: Date?
    var thumbnail: MarvelThumbnail?
    
    var comics: [ComicSummary]?
    var stories: [StorySummary]?
    var series: [SerieSummary]?
    var characters: [CharacterSummary]?
    var creators: [CreatorSummary]?
    
    var next: EventSummary?
    var previous: EventSummary?
}

extension Event: JSONSerializable {
    init(with json: [String : Any]) {
        
        self.id = json["id"] as? Int
        self.title = json["title"] as? String
        self.description = json["description"] as? String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-DD hh:mm:ss"
        
        if let startDateString = json["start"] as? String {
            self.start = dateFormatter.date(from: startDateString)
        }
        
        if let endDateString = json["end"] as? String {
            self.end = dateFormatter.date(from: endDateString)
        }
        
        if let thumbnailJSON = json["thumbnail"] as? [String: Any] {
            self.thumbnail = MarvelThumbnail(with: thumbnailJSON)
        }
        
        if let comicsJSON = json["comics"] as? [String: Any] {
            self.comics = MarvelList<ComicSummary>(with: comicsJSON).items
        }
        
        if let storiesJSON = json["stories"] as? [String: Any] {
            self.stories = MarvelList<StorySummary>(with: storiesJSON).items
        }
        
        if let seriesJSON = json["series"] as? [String: Any] {
            self.series = MarvelList<SerieSummary>(with: seriesJSON).items
        }
        
        if let charactersJSON = json["characters"] as? [String: Any] {
            self.characters = MarvelList<CharacterSummary>(with: charactersJSON).items
        }
        
        if let creatorsJSON = json["creators"] as? [String: Any] {
            self.creators = MarvelList<CreatorSummary>(with: creatorsJSON).items
        }
        
        if let nextJSON = json["next"] as? [String: Any] {
            self.next = EventSummary(with: nextJSON)
        }
        
        if let previousJSON = json["previous"] as? [String: Any] {
            self.previous = EventSummary(with: previousJSON)
        }
    }
}
