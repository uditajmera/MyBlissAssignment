//
//  EpisodesViewController+CollectionViewDelegates.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 16/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import UIKit

extension EpisodesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of items->\(self.viewModel.totalCount)")
        return self.viewModel.totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.episode, for: indexPath) as! EpisodeCollectionViewCell
        // 2
        print("Loading->\(indexPath.row)")
        print("CurrentCount->\(viewModel.currentCount)")
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none, withRow: indexPath.row)
        } else {
            cell.configure(with: viewModel.episode(at: indexPath.row), withRow: indexPath.row)
        }
        return cell
    }
}

extension EpisodesViewController:UICollectionViewDataSourcePrefetching{
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchEpisodes()
        }
    }
}

 extension EpisodesViewController {
    
    private enum CellIdentifiers {
        static let episode = "EpisodeCollectionCell"
    }
    
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = episodesCollectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

