//
//  EpisodeDetailViewController.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 16/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import UIKit

class EpisodeDetailViewController: UIViewController {

    let viewModel: EpisodeDetailsViewModel = EpisodeDetailsViewModel.init()
    
    @IBOutlet weak var episodeImage: UIImageView!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var episodeSubTitle: UILabel!
    
    @IBOutlet weak var episodeDescription: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI(){
        
        if let validURL = viewModel.imageURL{
            episodeImage.cacheImage(urlString: validURL) { (isCompleted) in
                
            }
        }
        
        episodeTitle.text = viewModel.title
        episodeSubTitle.text = viewModel.subTitle
        episodeDescription.text = viewModel.episodeDescription
    }

    func updateEpisodeDetail(episode:Episode){
        viewModel.updateEpisodeInfo(newEpisode: episode)
    }


}
