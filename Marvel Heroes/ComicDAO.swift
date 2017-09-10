//
//  ComicDAO.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 10/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import CoreData

class ComicDAO: DataAccessObject {

    func insert(_ comicSummary: ComicSummary, for heroObject: NSManagedObject) throws -> NSManagedObject {
        
        let comic = NSEntityDescription.insertNewObject(forEntityName: "StoredComicSummary", into: context)
        comic.setValue(comicSummary.resourceURI, forKey: "resourceURI")
        comic.setValue(comicSummary.name, forKey: "name")
        
        let comicHeroes = comic.value(forKey: "heroes") as? NSMutableSet
        comicHeroes?.add(heroObject)
        comic.setValue(comicHeroes, forKey: "heroes")
        
        try context.save()
        return comic
    }
    
    func insert(_ comicSummaries: [ComicSummary], for heroObject: NSManagedObject) throws -> [NSManagedObject] {
            
        var comicObjects = [NSManagedObject]()
        for comicSummary in comicSummaries {
            let comicObject = try insert(comicSummary, for: heroObject)
            comicObjects.append(comicObject)
        }
        
        try context.save()
        return comicObjects
    }
}
