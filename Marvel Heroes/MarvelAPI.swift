//
//  MarvelAPI.swift
//  Marvel Heroes
//
//  Created by Rafael Moura on 06/09/17.
//  Copyright © 2017 Rafael Moura. All rights reserved.
//

import Foundation
import Moya

enum MarvelError: Swift.Error {
    /// Indicates a response failed to map to an image.
    case imageMapping(Response)
    
    /// Indicates a response failed to map to a JSON structure.
    case jsonMapping(Response)
    
    /// Indicates a response failed to map to a String.
    case stringMapping(Response)
    
    /// Indicates a response failed with an invalid HTTP status code.
    case statusCode(Response)
    
    /// Indicates a response failed due to an underlying `Error`.
    case underlying(Swift.Error)
    
    /// Indicates that an `Endpoint` failed to map to a `URLRequest`.
    case requestMapping(String)
    
    init(with error: MoyaError) {
        switch error {
        case .imageMapping(let response):
            self = .imageMapping(response)
        case .jsonMapping(let response):
            self = .jsonMapping(response)
        case .requestMapping(let string):
            self = .requestMapping(string)
        case .statusCode(let response):
            self = .statusCode(response)
        case .stringMapping(let response):
            self = .statusCode(response)
        case .underlying(let error):
            self = .underlying(error)
        }
    }
}

enum Marvel {
    case characters(limit: Int, offset: Int, name: String?, nameStartsWith: String?)
    case comic(id: Int)
    case serie(id: Int)
    case story(id: Int)
    case event(id: Int)
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
        case .comic(let id):
            return "/comics/\(id)"
        case .event(let id):
            return "/events/\(id)"
        case .serie(let id):
            return "/series/\(id)"
        case .story(let id):
            return "/stories/\(id)"
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
        case .comic(_):
            return params
        case .serie:
            return params
        case .event:
            return params
        case .story:
            return params
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
