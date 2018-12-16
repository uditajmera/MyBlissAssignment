//
//  EpisodeCollectionViewCell.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 16/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import UIKit

class EpisodeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        configure(with: .none, withRow: -1)
    }
    
    
    func configure(with episode: Episode?, withRow row:Int) {
        if let validEpisode = episode {
            title.alpha = 1
            image.alpha = 1
            if let validURL = validEpisode.smallImageUrl{
                 image.cacheImage(urlString: validURL)
            }
            title.text = validEpisode.title ?? ""
            indicatorView.stopAnimating()
        } else {
            title.alpha = 0
            image.alpha = 0
           indicatorView.startAnimating()
        }
    }
    
}
