//
//  BasePath.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 15/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import Foundation

/// This protocol defins the var to construct Basepath for services
protocol BasePath {
    var base: String { get }
    var path: String { get }
}


// MARK: - BasePath protocol oriented extension
extension BasePath {
    
    
    /// This function will create URLRequest from base path and params array which passes to the function
    ///
    /// - Parameter params: parameter array
    /// - Returns: URLRequest
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


/// Type of episode feed
///
/// - nowPlaying: defalut behavior
enum EpisodeFeed{
    case nowPlaying
}

// MARK: - EpisodeFeed
/// this extension provide the basePath info  to create service request to get Episodes Feed
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

