//
//  SeriesClient.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 15/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import UIKit

class EpisodeClient: APIClient {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getFeed(from feedType: EpisodeFeed,
                 forPage currentPage:Int,
                 completion: @escaping (APIResult<EpisodeFeedResult?, APIError>) -> Void) {
        
        let request =  feedType.getRequest(forParams: ["page": "\(currentPage)"])
        
        fetch(with: request, decode: { (json) -> EpisodeFeedResult? in
            guard let episodeResults = json as? EpisodeFeedResult else {return nil}
            return episodeResults
        }, completion: completion)
        
    }
}
