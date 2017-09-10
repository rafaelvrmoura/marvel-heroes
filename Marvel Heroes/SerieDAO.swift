//
//  SerieDAO.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 10/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import CoreData

class SerieDAO: DataAccessObject {

    func insert(_ serieSummary: SerieSummary, for heroObject: NSManagedObject) throws -> NSManagedObject {
        
        let serie = NSEntityDescription.insertNewObject(forEntityName: "StoredSerieSummary", into: context)
        serie.setValue(serieSummary.resourceURI, forKey: "resourceURI")
        serie.setValue(serieSummary.name, forKey: "name")
        
        let serieHeroes = serie.value(forKey: "heroes") as? NSMutableSet
        serieHeroes?.add(heroObject)
        serie.setValue(serieHeroes, forKey: "heroes")
        
        try context.save()
        return serie
    }
    
    func insert(_ serieSummaries: [SerieSummary], for heroObject: NSManagedObject) throws -> [NSManagedObject] {
        
        var serieObjects = [NSManagedObject]()
        for serieSummary in serieSummaries {
            let serieObject = try insert(serieSummary, for: heroObject)
            serieObjects.append(serieObject)
        }
        
        try context.save()
        return serieObjects
    }
    
}
