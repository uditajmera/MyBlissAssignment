//
//  EpisodeDetailsViewModel.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 16/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import UIKit

class EpisodeDetailsViewModel: NSObject {
    
    private var episode:Episode?
    
    func updateEpisodeInfo(newEpisode:Episode){
        self.episode = newEpisode
    }
    
    var title:String{
        return episode?.title ?? ""
    }
    
    var subTitle:String{
        return episode?.subTitle ?? ""
    }
    
    var episodeDescription:String{
        return episode?.description ?? ""
    }
    
    
    var imageURL:String?{
        return episode?.imageUrl
    }
    
    
}
