//
//  Serie.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation

struct SerieSummary {
    var resourceURI: String?
    var name: String?
}

extension SerieSummary: JSONSerializable {
    
    init(with json: [String : Any]) {
        self.resourceURI = json["resourceURI"] as? String
        self.name = json["name"] as? String
    }
}

struct Serie {
    // TODO: Add properties and methods
}


extension Serie: JSONSerializable {
    init(with json: [String : Any]) {
        // TODO: init implementation
    }
}
