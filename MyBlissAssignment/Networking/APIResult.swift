//
//  APIResult.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 15/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import Foundation

/// APIResult enum is a generic type enum where <T,U:Error>
/// on success we can return APIResult.success(T) where T is a generic data type which can be replaced by any decodable Model
///
/// - success: can be used to return Success result as any model type as T is generic
/// - failure: can be used to return failure result as any model type as U is Error generic
enum APIResult<T, U> where U: Error  {
    case success(T)
    case failure(U)
}
