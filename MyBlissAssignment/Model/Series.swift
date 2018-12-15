//
//  Series.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 14/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import Foundation

struct EpisodeFeedResult: Decodable {
    let message:String?
    let data:Episodes?
}

struct Episodes:Decodable{
    let count:Int?
    let page:Int?
    let episodes:[Episode]?
    let more:Bool?
    
}

