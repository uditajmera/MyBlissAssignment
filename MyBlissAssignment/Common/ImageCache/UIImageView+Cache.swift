//
//  UIImageView+Cache.swift
//  MyBlissAssignment
//
//  Created by Udit Ajmera on 16/12/18.
//  Copyright © 2018 Udit Ajmera. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    typealias cacheImageCompletionHandler = (Bool) -> Void
    
    func cacheImage(urlString: String,
                    completion:@escaping cacheImageCompletionHandler){
        
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            completion(true)
            return
        }
        
        
        let activityIndicator = UIActivityIndicatorView.init(style:.whiteLarge)
        activityIndicator.backgroundColor = .gray
        activityIndicator.center = self.center
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        
        
        URLSession.shared.dataTask(with: url!) {
            data, response, error in
            if  data  != nil{
                DispatchQueue.main.async {
                    
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    
                    let imageToCache = UIImage(data: data!)
                    imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                    self.image = imageToCache
                    completion(true)
                }
            }
            else{
                completion(false)
            }
            }.resume()
    }
}
