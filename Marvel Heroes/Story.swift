//
//  Storie.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation

struct StorySummary {
    
    var storyID: Int? {
        guard let stringID = resourceURI?.components(separatedBy: "/").last else { return nil }
        let id = Int(stringID)
        return id
    }
    
    var resourceURI: String?
    var name: String?
    var type: String?
}

extension StorySummary: JSONSerializable {
    init(with json: [String : Any]) {
        self.resourceURI = json["resourceURI"] as? String
        self.name = json["name"] as? String
        self.type = json["type"] as? String
    }
}

struct Story {
    
    var id: Int?
    var title: String?
    var description: String?
    var type: String?
    var originalIssue: ComicSummary? // A summary representation of the issue in which this story was originally published.
    
    var thumbnail: MarvelThumbnail?
    var comics: [ComicSummary]?
    var series: [SerieSummary]?
    var events: [EventSummary]?
    var characters: [CharacterSummary]?
    var creators: [CreatorSummary]?   
}


extension Story: JSONSerializable {
    init(with json: [String : Any]) {
        
        self.id = json["id"] as? Int
        self.title = json["title"] as? String
        self.description = json["description"] as? String
        self.type = json["type"] as? String
        
        if let issueJSON = json["originalIssue"] as? [String: Any] {
            self.originalIssue = ComicSummary(with: issueJSON)
        }
        
        if let thumbnailJSON = json["thumbnail"] as? [String: Any] {
            self.thumbnail = MarvelThumbnail(with: thumbnailJSON)
        }
        
        if let comicsJSON = json["comics"] as? [String: Any] {
            self.comics = MarvelList<ComicSummary>(with: comicsJSON).items
        }
        
        if let seriesJSON = json["series"] as? [String: Any] {
            self.series = MarvelList<SerieSummary>(with: seriesJSON).items
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
    }
}
