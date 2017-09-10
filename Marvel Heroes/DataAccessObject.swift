//
//  DataAccessObject.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 10/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import UIKit
import CoreData

class DataAccessObject: NSObject {

    var context: NSManagedObjectContext
    
    init(with context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
}
