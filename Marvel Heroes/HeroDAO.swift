//
//  HeroDAO.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 08/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import CoreData

class HeroDAO: NSObject {

    private var context: NSManagedObjectContext
    
    init(with context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    func favorite(_ hero: Hero) throws {
        
        let heroObject = NSEntityDescription.insertNewObject(forEntityName: "FavoriteHero", into: context)
        
        let thumbnail = NSEntityDescription.insertNewObject(forEntityName: "Thumbnail", into: context)
        
        thumbnail.setValue(hero.thumbnail?.path, forKey: "path")
        thumbnail.setValue(hero.thumbnail?.pictureExtension, forKey: "pictureExtension")
        
        heroObject.setValue(hero.id, forKey: "id")
        heroObject.setValue(hero.name, forKey: "name")
        heroObject.setValue(hero.description, forKey: "characterDescription")
        heroObject.setValue(thumbnail, forKey: "thumbnail")
        
        try context.save()
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
    
    func fetch(from offset: Int, to limit: Int) throws -> [Hero]? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteHero")
        request.fetchOffset = offset
        request.fetchLimit = limit
        
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
    }
}

extension MarvelThumbnail {
    
    init(with managedObject: NSManagedObject) {
        self.path = managedObject.value(forKey: "path") as? String
        self.pictureExtension = managedObject.value(forKey: "pictureExtension") as? String
    }
}



