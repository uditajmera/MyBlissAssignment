//
//  GenericAPIClient.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 15/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import Foundation

enum APIError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}


/// APIClient protocol provide generic interface for client to perform URLSession data and get Generic Model type which can be convert to passing decodable Model
protocol APIClient {
    
    var session: URLSession { get }
    
    func fetch<T: Decodable>(with request: URLRequest,
                             decode: @escaping (Decodable) -> T?,
                             completion: @escaping (APIResult<T, APIError>) -> Void)
    
}


// MARK: - APIClient protocol extension
extension APIClient{
    
    /// JSONTaskCompletionHandler used as a datatask completion handler
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    /// This function initiate dataTask on the request, on response data gets decode to generic decodingType passes in parameters of function
    ///
    /// - Parameters:
    ///   - request: URLRequest
    ///   - decodingType: T.Type generic type of model
    ///   - completion: JSONTaskCompletionHandler
    /// - Returns: URLSessionDataTask
    func decodingTask<T: Decodable>(with request: URLRequest,
                                    decodingType: T.Type,
                                    completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let genericModel = try JSONDecoder().decode(decodingType, from: data)
                        completion(genericModel, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }
    
    
    /// This method calls decodingTask which calls service for request, on getting response handles the @escaping completion block
    /// and return
    /// - Parameters:
    ///   - request: URLRequest
    ///   - decode: pass Decodable and returns generic model
    ///   - completion: pass APIResult and returns void
    func fetch<T: Decodable>(with request: URLRequest,
                             decode: @escaping (Decodable) -> T?,
                             completion: @escaping (APIResult<T, APIError>) -> Void) {
        
        let task = decodingTask(with: request, decodingType: T.self) { (json , error) in
            
            //MARK: change to main queue
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(APIResult.failure(error))
                    } else {
                        completion(APIResult.failure(.invalidData))
                    }
                    return
                }
                if let value = decode(json) {
                    completion(.success(value))
                } else {
                    completion(.failure(.jsonParsingFailure))
                }
            }
        }
        task.resume()
    }
    
}


