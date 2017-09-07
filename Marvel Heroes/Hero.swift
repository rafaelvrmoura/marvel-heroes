//
//  Hero.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct Hero: JSONSerializable {
    
    var id: Int?
    var name: String?
    var description: String?
    var thumbnail: MarvelThumbnail?
    
    var comics: [Comic]?
    var stories: [Storie]?
    var events: [Event]?
    var Series: [Serie]?
    
    var isFavorite: Bool {
        get {
            return self.managedObject != nil
        }
        
        set{
            
            guard let heroID = self.id else {return}
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            if newValue == true {
                let object = NSEntityDescription.insertNewObject(forEntityName: "FavoriteHero", into: context)
                object.setValue(heroID, forKey: "id")
                
            }else {
                guard let managedObject = self.managedObject else {
                    return
                }
                
                context.delete(managedObject)
            }
            try? context.save()
        }
    }
    
    private var managedObject: NSManagedObject? {
        
        guard let heroID = self.id else { return nil }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "id == %d", heroID)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteHero")
        request.predicate = predicate
        
        return (try? context.fetch(request))?.first as? NSManagedObject
    }
    
    init(with json: [String : Any]) {
        
        self.id = json["id"] as? Int
        self.name = json["name"] as? String
        self.description = json["description"] as? String
        
        if let thumbnailJSON = json["thumbnail"] as? [String: Any] {
            self.thumbnail = MarvelThumbnail(with: thumbnailJSON)
        }
    }
}
