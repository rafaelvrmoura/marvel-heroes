//
//  HeroDAO.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 08/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import CoreData

class HeroDAO: DataAccessObject {
    
    func favorite(_ hero: Hero) throws {
        _ = try self.insert(hero)
    }
    
    private func insert(_ hero: Hero) throws -> NSManagedObject{
        let heroObject = NSEntityDescription.insertNewObject(forEntityName: "FavoriteHero", into: context)
        
        let thumbnail = NSEntityDescription.insertNewObject(forEntityName: "Thumbnail", into: context)
        thumbnail.setValue(hero.thumbnail?.path, forKey: "path")
        thumbnail.setValue(hero.thumbnail?.pictureExtension, forKey: "pictureExtension")
        thumbnail.setValue(heroObject, forKey: "hero")
        
        heroObject.setValue(hero.id, forKey: "id")
        heroObject.setValue(hero.name, forKey: "name")
        heroObject.setValue(hero.description, forKey: "characterDescription")
        heroObject.setValue(thumbnail, forKey: "thumbnail")
        
        // Insert comic summaries
        if let comics = hero.comics {
            let comicDAO = ComicDAO(with: context)
            let comicObjects = try comicDAO.insert(comics, for: heroObject)
            heroObject.setValue(NSSet(array: comicObjects), forKey: "comics")
        }
        
        // Insert story summaries
        if let stories = hero.stories {
            let storyDAO = StoryDAO(with: context)
            let storyObjects = try storyDAO.insert(stories, for: heroObject)
            heroObject.setValue(NSSet(array: storyObjects), forKey: "stories")
        }
        
        // Insert event summaries
        if let events = hero.events {
            let eventDAO = EventDAO(with: context)
            let eventObjects = try eventDAO.insert(events, for: heroObject)
            heroObject.setValue(NSSet(array: eventObjects), forKey: "events")
        }
        
        // Insert serie summaries
        if let series = hero.series {
            let serieDAO = SerieDAO(with: context)
            let serieObjects = try serieDAO.insert(series, for: heroObject)
            heroObject.setValue(NSSet(array: serieObjects), forKey: "series")
        }
        
        try context.save()
        
        return heroObject
    }
    
    func unFavorite(_ hero: Hero) throws {
        
        guard let object = try self.managedObject(for: hero) else { return }
        context.delete(object)
        
        try context.save()
    }
    
    func isFavorite(_ hero: Hero) throws -> Bool {
        
        let object = try self.managedObject(for: hero)
        return object != nil
    }
    
    private func managedObject(for hero: Hero) throws -> NSManagedObject? {
        
        guard let heroID = hero.id else { return nil }
        
        let predicate = NSPredicate(format: "id == %d", heroID)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteHero")
        request.predicate = predicate
        
        let result = try context.fetch(request).first as? NSManagedObject
        
        return result
    }
    
    func fetch(whereNameStartsWith characters: String? = nil, from offset: Int, to limit: Int) throws -> [Hero]? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteHero")
        request.fetchOffset = offset
        request.fetchLimit = limit
        
        if let characters = characters {
            request.predicate = NSPredicate(format: "(name BEGINSWITH[c] %@)", characters)
        }
        
        let results = try context.fetch(request) as? [NSManagedObject]
        
        return results?.map{ Hero(with: $0) }
    }
}


// MARK: Model extensions to init with managed objects

extension Hero {
    init(with managedObject: NSManagedObject) {
        self.id = managedObject.value(forKey: "id") as? Int
        self.name = managedObject.value(forKey: "name") as? String
        self.description = managedObject.value(forKey: "characterDescription") as? String
        
        if let thumbnailObject = managedObject.value(forKey: "thumbnail") as? NSManagedObject {
            self.thumbnail = MarvelThumbnail(with: thumbnailObject)
        }else {
            self.thumbnail = nil
        }
        
        if let comicSummaries = managedObject.value(forKey: "comics") as? Set<NSManagedObject> {
            self.comics = comicSummaries.map{ ComicSummary(with: $0) }
        }else {
            self.comics = nil
        }
        
        if let storySummaries = managedObject.value(forKey: "stories") as? Set<NSManagedObject> {
            self.stories = storySummaries.map{ StorySummary(with: $0) }
        }else {
            self.stories = nil
        }
        
        if let eventSummaries = managedObject.value(forKey: "events") as? Set<NSManagedObject> {
            self.events = eventSummaries.map{ EventSummary(with: $0) }
        }else {
            self.events = nil
        }
        
        if let serieSummaries = managedObject.value(forKey: "series") as? Set<NSManagedObject> {
            self.series = serieSummaries.map{ SerieSummary(with: $0) }
        }else {
            self.series = nil
        }
    }
}

extension MarvelThumbnail {
    
    init(with managedObject: NSManagedObject) {
        self.path = managedObject.value(forKey: "path") as? String
        self.pictureExtension = managedObject.value(forKey: "pictureExtension") as? String
    }
}

extension ComicSummary {
    init(with managedObject: NSManagedObject) {
        self.resourceURI = managedObject.value(forKey: "resourceURI") as? String
        self.name = managedObject.value(forKey: "name") as? String
    }
}

extension StorySummary {
    init(with managedObject: NSManagedObject) {
        self.resourceURI = managedObject.value(forKey: "resourceURI") as? String
        self.name = managedObject.value(forKey: "name") as? String
        self.type = managedObject.value(forKey: "type") as? String
    }
}

extension EventSummary {
    init(with managedObject: NSManagedObject) {
        self.resourceURI = managedObject.value(forKey: "resourceURI") as? String
        self.name = managedObject.value(forKey: "name") as? String
    }
}

extension SerieSummary {
    init(with managedObject: NSManagedObject) {
        self.resourceURI = managedObject.value(forKey: "resourceURI") as? String
        self.name = managedObject.value(forKey: "name") as? String
    }
}


