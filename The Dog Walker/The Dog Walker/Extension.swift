
//
//  Extension.swift
//  The Dog Walker
//
//  Created by Scott O'Hara on 6/28/17.
//  Copyright © 2017 Scott O'Hara. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView{
    
    //    func imageCirle(){
    //
    //        let radius = self.frame.height / 2
    //        self.layer.cornerRadius = radius
    //        self.layer.masksToBounds = true
    //        self.contentMode = .scaleAspectFill
    //        self.clipsToBounds = true
    //    }
    
    func loadImageUsingCache(_ urlString: String) {
        
        self.image = nil
        
        let radius = self.frame.height / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
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
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
}
