//
//  EpisodesViewModel.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 16/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//
import Foundation

protocol EpisodesViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}
class EpisodesViewModel: NSObject {
    
    private let client = EpisodeClient()
    
    private weak var delegate: EpisodesViewModelDelegate?
    
    private var episodes: [Episode] = []
    private var currentPage = 1
    private var fetchCount = 0
    private var hasMore = true
    private var isFetchInProgress = false
    
    init(delegate:EpisodesViewModelDelegate) {
        self.delegate = delegate
    }
    
    var totalCount: Int {
        if hasMore{
            return episodes.count + fetchCount
        }
        return episodes.count
    }
    
    var currentCount: Int {
        return episodes.count
    }
    
    func episode(at index: Int) -> Episode {
        return episodes[index]
    }
    
    
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
                    
                    // 3
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
    
    private func calculateIndexPathsToReload(from newEpisodes: [Episode]) -> [IndexPath] {
        let startIndex = episodes.count - newEpisodes.count
        let endIndex = startIndex + newEpisodes.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    
}
