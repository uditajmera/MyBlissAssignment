//
//  ViewController.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 14/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import UIKit

class EpisodesViewController: UIViewController {

    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var episodesCollectionView: UICollectionView!
    
    var viewModel: EpisodesViewModel!
    let pageTitle = "Episodes"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.startAnimating()
        self.navigationItem.title = pageTitle
        // Do any additional setup after loading the view, typically from a nib.
        self.viewModel = EpisodesViewModel.init(delegate: self)
        self.viewModel.fetchEpisodes()
        
    }
}

extension EpisodesViewController:EpisodesViewModelDelegate{
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
       
        indicatorView.stopAnimating()
        indicatorView.alpha = 0
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            
            episodesCollectionView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        
        
        episodesCollectionView.performBatchUpdates({
            
            if viewModel.currentCount < viewModel.totalCount{
                episodesCollectionView.insertItems(at: (viewModel.currentCount..<viewModel.totalCount).map{(NSIndexPath(row: $0, section: 0) as IndexPath)})
            }
            
            episodesCollectionView.reloadItems(at: indexPathsToReload)
            
        }) { (loaded) in
            
            
        }
        
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
    }
    
    
}


