//
//  MarvelAPI.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation
import Moya

enum Marvel {
    
    case characters(limit: Int, offset: Int, name: String?, nameStartsWith: String?)
    case comics(heroID: Int)
    case series
    case stories
    case events
}

// MARK: - Marvel implementation for Moya's TargetType protocol

extension Marvel: TargetType {
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "https://gateway.marvel.com:443/v1/public/")!
    }

    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
    
        switch self {
        case .characters(_,_,_,_):
            return "/characters"
        case .comics(let heroID):
            return "/characters/\(heroID)/comics"
        case .events:
            return ""
        case .series:
            return ""
        case .stories:
            return ""
        }
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return .get
    }
    
    
    var parameters: [String: Any]? {
        
        
        let hash = Marvel.hash
        let md5 = hash.md5
        let timestamp = hash.ts
        
        var params: [String: Any] = ["apikey" : Marvel.apiKey ?? "",
                                    "hash": md5 ?? "",
                                    "ts": timestamp ?? ""]
        
        switch self {
        case .characters(let limit, let offset, let name, let nameStartsWith):
            params["limit"] = limit
            params["offset"] = offset
            params["name"] = name
            params["nameStartsWith"] = nameStartsWith
            
            return params
        case .comics(_):
            return nil
        case .series:
            return nil
        case .events:
            return nil
        case .stories:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        return Data() // Mocked data that will be used for testing
    }
    
    var task: Task {
        return .request
    }
    
    var validate: Bool {
        return false
    }
}

// MARK: - Marvel extension that provides lazy static attributes to API keys.
extension Marvel {
    fileprivate static var keysDict: NSDictionary = {
        guard let keysPlistPath = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),    let keysDict = NSDictionary(contentsOfFile: keysPlistPath) else {
            fatalError("Missing APIKeys.plist file")
        }
        
        return keysDict
    }()
    
    static var apiKey: String? = {
        return keysDict["public_key"] as? String
    }()
    
    static var secret: String? = {
        return keysDict["private_key"] as? String
    }()
    
    static var hash: (ts: String?, md5: String?) = {
        
        guard let secret = secret, let apiKey = apiKey else {return (ts: nil, md5: nil)}
        
        let timestamp = "\(Date().timeIntervalSince1970)"
        let token = timestamp + secret + apiKey
        
        return (ts: timestamp, md5: token.md5)
    }()
}

// MARK: - Operators overloading for dictionaries.
func + <K,V>(left: Dictionary<K,V>, right: Dictionary<K,V>) -> Dictionary<K,V> {
    
    var map = Dictionary<K,V>()
    
    for (k, v) in left {
        map[k] = v
    }
    
    for (k, v) in right {
        map[k] = v
    }
    
    return map
}

func += <K,V>(left: inout Dictionary<K,V>, right: Dictionary<K,V>) {
    
    right.forEach { (key, value) in
        left[key] = value
    }
}
