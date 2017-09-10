//
//  StoryDAO.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 10/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import CoreData

class StoryDAO: DataAccessObject {

    func insert(_ storySummary: StorySummary, for heroObject: NSManagedObject) throws -> NSManagedObject {
        
        let story = NSEntityDescription.insertNewObject(forEntityName: "StoredStorySummary", into: context)
        story.setValue(storySummary.resourceURI, forKey: "resourceURI")
        story.setValue(storySummary.name, forKey: "name")
        story.setValue(storySummary.type, forKey: "type")
        
        let storyHeroes = story.value(forKey: "heroes") as? NSMutableSet
        storyHeroes?.add(heroObject)
        story.setValue(storyHeroes, forKey: "heroes")
        
        try context.save()
        return story
    }
    
    func insert(_ storySummaries: [StorySummary], for heroObject: NSManagedObject) throws -> [NSManagedObject] {
        
        var storyObjects = [NSManagedObject]()
        for storySummary in storySummaries {
            let comicObject = try insert(storySummary, for: heroObject)
            storyObjects.append(comicObject)
        }
        
        try context.save()
        return storyObjects
    }
    
}
