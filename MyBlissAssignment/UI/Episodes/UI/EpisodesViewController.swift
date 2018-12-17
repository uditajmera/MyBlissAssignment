//
//  ViewController.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 14/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import UIKit

/// This view controller will display the Episodes in collection view, which can be navigate to episode detail page on tap
class EpisodesViewController: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var episodesCollectionView: UICollectionView!
    
     //MARK:- Constants declaration
    let pageTitle = "Episodes"
    let episodeDetailIdentifier = "EpisodeDetails"
    
     //MARK:- variable declaration
    /// viewModel provides all data in a presentable format to view/Cell
    /// also handles service request and response
    var viewModel: EpisodesViewModel!
    /// this variable hold the index of the selected episode cell in collection view
    var selectedIndex = -1
    
    //MARK:- UI setup
    
    /// viewDidLoad : setup UI Initial UI
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.startAnimating()
        self.navigationItem.title = pageTitle
        // Do any additional setup after loading the view, typically from a nib.
        self.viewModel = EpisodesViewModel.init(delegate: self)
        /// this method will fetch episodes from server and result will be notify by EpisodesViewModelDelegate
        self.viewModel.fetchEpisodes()
        
    }
    
    //MARK:- Navigation
    
    /// This method calls on perform segue, if identifier is 'episodeDetailIdentifier' then it will navigate to episode detail page with episode object
    ///
    /// - Parameters:
    ///   - segue: UIStoryboardSegue
    ///   - sender: controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == episodeDetailIdentifier{
           let dest =  segue.destination as? EpisodeDetailViewController
            /// transfer selected episode object to the Episode detail page
            dest?.updateEpisodeDetail(episode: viewModel.episode(at: self.selectedIndex))
        }
    }
    
}

//MARK:- EpisodesViewModelDelegate methods
extension EpisodesViewController:EpisodesViewModelDelegate{
    
    /// This delegate method will call on reciving new episodes data successfully.
    /// Update the collectionview cell with the new episode data
    /// Insert new collectionview cell for prefetching if there is more data that can be fetched
    ///
    /// - Parameter newIndexPathsToReload: IndexPath array for which new Episode data recieved
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
       
        indicatorView.stopAnimating()
        indicatorView.alpha = 0
        
        /// check whether IndexPath array is valid or not 
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            /// here it will comes first time when there is no data loaded
            episodesCollectionView.reloadData()
            let visibleCount = episodesCollectionView.visibleCells.count
            if visibleCount > viewModel.currentCount{
                viewModel.fetchEpisodes()
            }
            return
        }
        
        
        /// identify the visible indexpath which needs to be loaded
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        
        
        episodesCollectionView.performBatchUpdates({
            /// Insert new cells for prefecting, where currentcount is total recieved episodes and totalCount is new episodes can be used for prefecting
            if viewModel.currentCount < viewModel.totalCount{
                episodesCollectionView.insertItems(at: (viewModel.currentCount..<viewModel.totalCount).map{(NSIndexPath(row: $0, section: 0) as IndexPath)})
            }
            /// reload cells with new recieved episodes
            episodesCollectionView.reloadItems(at: indexPathsToReload)
            
        }) { [weak self] (loaded) in
            
            if let validViewModel = self?.viewModel{
                let visibleCount = self?.episodesCollectionView.visibleCells.count
                if visibleCount ?? 0 > validViewModel.currentCount{
                    self?.viewModel.fetchEpisodes()
                }
            }
            
        }
        
    }
    
    
    /// This delegate method will call on getting some error while fetching the new Episodes
    ///
    /// - Parameter reason: this string provide reason for failure
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        
        /// show error alert
        let alert = UIAlertController(title: "Error", message: reason, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


