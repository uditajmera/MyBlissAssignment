//
//  EpisodesViewController+CollectionViewDelegates.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 16/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewDelegate
extension EpisodesViewController:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        
        self.performSegue(withIdentifier: episodeDetailIdentifier,
                          sender: self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isLoadingCell(for: indexPath) {
            self.viewModel.fetchEpisodes()
        }
    }
}


// MARK: - UICollectionViewDataSource
extension EpisodesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.episode, for: indexPath) as! EpisodeCollectionViewCell
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none, withRow: indexPath.row)
        } else {
            cell.configure(with: viewModel.episode(at: indexPath.row), withRow: indexPath.row)
        }
        return cell
    }
}


// MARK: - UICollectionViewDataSourcePrefetching
extension EpisodesViewController:UICollectionViewDataSourcePrefetching{
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchEpisodes()
        }
    }
}


// MARK: - Utiltiy function extension
 extension EpisodesViewController {
    
    private enum CellIdentifiers {
        static let episode = "EpisodeCollectionCell"
    }
    
    
    /// function returns if passing indexPath is loading or loaded
    /// returns YES if loading
    /// returns NO if loaded
    ///
    /// - Parameter indexPath: IndexPath of cell
    /// - Returns: Bool
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    
    /// This function will return set of indexpath which are displaying and needs to reload from passing array of Indexpath
    ///
    /// - Parameter indexPaths: IndexPath array which needs to be intersect with the visible indexpath
    /// - Returns: indexpath which are visible from passing indexPath array
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = episodesCollectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

