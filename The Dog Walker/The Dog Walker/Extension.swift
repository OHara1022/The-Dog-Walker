
//
//  Extension.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/28/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation
import UIKit

//holser to cache images
let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView{
    
    //load image using cache
    func loadImageUsingCache(_ urlString: String) {
        
        //set image to nil before load
        self.image = nil
//        self.alpha = 0.0    
        
        //set radius so image is circle
        let radius = self.frame.height / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            //set image
            self.image = cachedImage
            return
        }
        
        //get url as sting
        let url = URL(string: urlString)
        
        //get URLsession to download url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if let error = error {
                //dev
                print(error.localizedDescription)
                //TODO: alert that error loading image to avoid crash
                return
            }
            
            //load on main queue
            DispatchQueue.main.async(execute: {
                
                //check for data
                if let downloadedImage = UIImage(data: data!) {
                    //cache image from FB
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    //set downloaded image
                    self.image = downloadedImage
                    UIView.animate(withDuration: 1.0, animations: {
                        self.alpha = 1.0
                        
                    })
                }
            })
            
        }).resume()//resume session
    }
}
