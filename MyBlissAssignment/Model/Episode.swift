//
//  Episode.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 14/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import Foundation

struct Episode: Decodable {
    let id:UInt?
    let title: String?
    let subTitle: String?
    let description: String?
    let imageUrl: String?
    let smallImageUrl: String?
    let date: String?
}
