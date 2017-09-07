//
//  Hero.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation

enum HeroPictureResolution: String {
    case portraitSmall = "portrait_small"           // 50x75px
    case portraitMedium = "portrait_medium"         // 100x150px
    case portraitXLarge = "portrait_xlarge"         // 150x225px
    case portraitFantastic = "portrait_fantastic"   // 168x252px
    case portraitUncanny = "portrait_uncanny"       // 300x450px
    case portraitIncredible = "portrait_incredible" // 216x324px
}

struct Hero {
    
    var name: String
    var description: String?
    var thumbnail: HeroThumbnail?
    
    var comics: [Comic]?
    var stories: [Storie]?
    var events: [Event]?
    var Series: [Serie]?
}
