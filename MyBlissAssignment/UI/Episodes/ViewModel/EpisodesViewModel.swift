//
//  EpisodesViewModel.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 16/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//
import Foundation


/// MARK:-EpisodesViewModelDelegate
protocol EpisodesViewModelDelegate: class {
    // this function will call on deleagte for success response from service for array of indexpath
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
   // this function will call on deleagte for  failed response with error
    func onFetchFailed(with reason: String)
}

/// EpisodesViewModel class provides presentable models to EpisodeViewController
class EpisodesViewModel: NSObject {
    //MARK:- private property
    /// EpisodeClient fetch request to the service layer and provide response as APIResult which contains the Episode feed model
    private let client = EpisodeClient()
    
    private weak var delegate: EpisodesViewModelDelegate?
    
    /// This array will hold all fetched episodes
    private var episodes: [Episode] = []
    /// current page for fetching next page from service layer
    private var currentPage = 1
    /// number of episodes fetched in last fetch service request for page
    private var fetchCount = 0
    /// can fetch next page
    private var hasMore = true
    private var isFetchInProgress = false
    
    //MARK:- Initialization
    init(delegate:EpisodesViewModelDelegate) {
        self.delegate = delegate
    }
    
    //MARK:- computed var
    
    var totalCount: Int {
        if hasMore{
            return episodes.count + fetchCount
        }
        return episodes.count
    }
    
    var currentCount: Int {
        return episodes.count
    }
    
    //MARK:- Fetching
    /// This function will interact with Episode client and get episode feed
    func fetchEpisodes() {
        
        guard !isFetchInProgress else {
            return
        }
        
       
        isFetchInProgress = true
        
        client.getFeed(from: .nowPlaying, forPage: currentPage) { result in
            
            switch result {
            case .success(let movieFeedResult):
                guard let result = movieFeedResult?.data else { return }
                DispatchQueue.main.async {
                    
                    self.currentPage += 1
                    self.isFetchInProgress = false
                    
                    self.fetchCount = result.count ?? 0
                    self.hasMore = result.more ?? false
                    self.episodes.append(contentsOf: result.episodes ?? [])
                    
                    
                    if let validPage = result.page, validPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: result.episodes ?? [])
                        self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: .none)
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.localizedDescription)
                }
                
            }
        }
        
    }
    
    
     //MARK:- Utility methods
    func episode(at index: Int) -> Episode {
        return episodes[index]
    }
    
    /// This function will return indexpath which needs to be update in collection based on the fetched Episode array
    ///
    /// - Parameter newEpisodes: Fetched Episode model
    /// - Returns: indexpath array needs to be reload
    private func calculateIndexPathsToReload(from newEpisodes: [Episode]) -> [IndexPath] {
        let startIndex = episodes.count - newEpisodes.count
        let endIndex = startIndex + newEpisodes.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    
}
