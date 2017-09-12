//
//  Comic.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation

struct ComicSummary {
    
    var comicID: Int? {
        guard let stringID = resourceURI?.components(separatedBy: "/").last else { return nil }
        let id = Int(stringID)
        return id
    }
    
    var resourceURI: String?
    var name: String?
}

extension ComicSummary: JSONSerializable {
    init(with json: [String : Any]) {
        self.resourceURI = json["resourceURI"] as? String
        self.name = json["name"] as? String
    }
}

struct Comic {
    
    var id: Int?
    var title: String?
    var description: String?
    var format: String?
    var pageCount: Int?
    var thumbnail: MarvelThumbnail?
    
    var prices: [ComicPrice]?
    var series: SerieSummary?
    var creators: [CreatorSummary]?
    var characters: [CharacterSummary]?
}

extension Comic: JSONSerializable {
    
    init(with json: [String : Any]) {
        
        self.id = json["id"] as? Int
        self.title = json["title"] as? String
        self.description = json["description"] as? String
        self.format = json["format"] as? String
        self.pageCount = json["pageCount"] as? Int
        
        if let thumbnailJSON = json["thumbnail"] as? [String: Any] {
            self.thumbnail = MarvelThumbnail(with: thumbnailJSON)
        }
        
        if let pricesJSON = json["prices"] as? [[String: Any]] {
            self.prices = pricesJSON.map { ComicPrice(with: $0) }
        }
        
        if let seriesJSON = json["series"] as? [String: Any] {
            self.series = SerieSummary(with: seriesJSON)
        }
        
        if let creatorsJSON = json["creators"] as? [String: Any] {
            self.creators = MarvelList<CreatorSummary>(with: creatorsJSON).items
        }
        
        if let charactersJSON = json["characters"] as? [String: Any] {
            self.characters = MarvelList<CharacterSummary>(with: charactersJSON).items
        }
    }
}

struct ComicPrice {
    
    enum PriceType: String {
        case digitalPurchasePrice
        case printPrice
        
        var string: String {
            switch self {
            case .digitalPurchasePrice:
                return  "Digital Purchase Price"
            case .printPrice:
                return "Print Price"
            }
        }
    }
    
    var formatedPrice: String {
        guard let price = self.price else { return  "No information" }
        let formatedString = NumberFormatter.localizedString(from: NSNumber(value: price), number: .currency)
        return formatedString
    }
    
    var type: PriceType?
    var price: Double?
    
}

extension ComicPrice: JSONSerializable {
    init(with json: [String : Any]) {
        
        if let priceTypeString = json["type"] as? String {
            self.type = PriceType(rawValue: priceTypeString)
        }
        
        self.price = json["price"] as? Double
    }
}

