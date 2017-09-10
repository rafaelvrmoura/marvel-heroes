//
//  Storie.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation

struct StorySummary {
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
    // TODO: Add properties and methods
}


extension Story: JSONSerializable {
    init(with json: [String : Any]) {
        // TODO: init implementation
    }
}
