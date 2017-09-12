//
//  Creator.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 12/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation

struct CreatorSummary {
    
    var creatorID: Int? {
        guard let stringID = resourceURI?.components(separatedBy: "/").last else { return nil }
        let id = Int(stringID)
        return id
    }
    
    var resourceURI: String?
    var name: String?
    var role: String?
}

extension CreatorSummary: JSONSerializable {
    init(with json: [String : Any]) {
        self.resourceURI = json["resourceURI"] as? String
        self.name = json["name"] as? String
        self.role = json["role"] as? String
    }
}
