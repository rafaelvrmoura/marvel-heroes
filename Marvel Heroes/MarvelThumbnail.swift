//
//  HeroThumbnail.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation

enum PictureResolution: String {
    case portraitSmall = "portrait_small"           // 50x75px
    case portraitMedium = "portrait_medium"         // 100x150px
    case portraitXLarge = "portrait_xlarge"         // 150x225px
    case portraitFantastic = "portrait_fantastic"   // 168x252px
    case portraitUncanny = "portrait_uncanny"       // 300x450px
    case portraitIncredible = "portrait_incredible" // 216x324px
}

struct MarvelThumbnail {
    
    var path: String?
    var pictureExtension: String?
    
    func url(with resolution: PictureResolution) -> URL? {
    
        guard let path = self.path, let pictureExtension = self.pictureExtension else {return nil}
        
        let url = URL(string: path)?.appendingPathComponent(resolution.rawValue).appendingPathExtension(pictureExtension)
        
        return url
    }
}

extension MarvelThumbnail: JSONSerializable {
    init(with json: [String : Any]) {
        self.path = json["path"] as? String
        self.pictureExtension = json["extension"] as? String
    }
}
