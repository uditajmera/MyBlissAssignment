//
//  EpisodeCollectionViewCell.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 16/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import UIKit

/// This call shows episode data(Image & Title) in UI in the EpisodesViewController
class EpisodeCollectionViewCell: UICollectionViewCell {
     //MARK:- IBOutlet
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
     //MARK:- Configure methods
    
    /// this method will reset the cell before getting reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        /// reset cell with default setting
        configure(with: .none, withRow: -1)
    }
    
    
    /// This method takes Episode object as input and update UI
    ///
    /// - Parameters:
    ///   - episode: Episode UI model
    ///   - row: Index
    func configure(with episode: Episode?, withRow row:Int) {
        if let validEpisode = episode {
            
            activityIndicator.stopAnimating()
            activityIndicator.alpha = 0
            
            title.alpha = 1
            image.alpha = 1
            if let validURL = validEpisode.smallImageUrl{
                image.cacheImage(urlString: validURL) { (isCompleted) in
                }
            }
            
            title.text =  (validEpisode.subTitle ?? "") + " " + (validEpisode.title ?? "")
            
        } else {
            activityIndicator.startAnimating()
            activityIndicator.alpha = 1
            title.alpha = 0
            image.alpha = 0
        }
    }
    
}
