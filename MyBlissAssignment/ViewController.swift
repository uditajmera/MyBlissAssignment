//
//  ViewController.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 14/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let client = EpisodeClient()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        client.getFeed(from: .nowPlaying, forPage: 1) { result in
            
            switch result {
            case .success(let movieFeedResult):
                guard let movieResults = movieFeedResult?.message else { return }
                print(movieResults)
            case .failure(let error):
                print("the error \(error)")
            }
        }

    }


}

