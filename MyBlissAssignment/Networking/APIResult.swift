//
//  APIResult.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 15/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import Foundation

enum APIResult<T, U> where U: Error  {
    case success(T)
    case failure(U)
}
