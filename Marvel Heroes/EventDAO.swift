//
//  EventDAO.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 10/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import CoreData

class EventDAO: DataAccessObject {

    func insert(_ eventSummary: EventSummary, for heroObject: NSManagedObject) throws -> NSManagedObject {
        
        let story = NSEntityDescription.insertNewObject(forEntityName: "StoredEventSummary", into: context)
        story.setValue(eventSummary.resourceURI, forKey: "resourceURI")
        story.setValue(eventSummary.name, forKey: "name")
        
        let storyHeroes = story.value(forKey: "heroes") as? NSMutableSet
        storyHeroes?.add(heroObject)
        story.setValue(storyHeroes, forKey: "heroes")
        
        try context.save()
        return story
    }
    
    func insert(_ eventSummaries: [EventSummary], for heroObject: NSManagedObject) throws -> [NSManagedObject] {
        
        var eventObjects = [NSManagedObject]()
        for eventSummary in eventSummaries {
            let eventObject = try insert(eventSummary, for: heroObject)
            eventObjects.append(eventObject)
        }
        
        try context.save()
        return eventObjects
    }
    
}
