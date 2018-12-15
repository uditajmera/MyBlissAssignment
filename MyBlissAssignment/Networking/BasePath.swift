//
//  BasePath.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 15/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import Foundation

protocol BasePath {
    var base: String { get }
    var path: String { get }
}

extension BasePath {
    
    func getRequest(forParams params:[String:String])->URLRequest{
        var newUrlComponents = urlComponents
        let queryItems = params.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        newUrlComponents.queryItems = queryItems
        let url = newUrlComponents.url!
        return URLRequest(url: url)
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}

enum EpisodeFeed{
    case nowPlaying
}

extension EpisodeFeed: BasePath{
    
    var base: String {
        return "http://apidev.mybliss.ai"
    }
    
    var path: String {
        switch self {
        case .nowPlaying: return "/api/v1/dummy"
        }
    }
}

