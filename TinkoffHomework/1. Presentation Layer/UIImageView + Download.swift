//
//  UIImageView + Download.swift
//  TinkoffHomework
//
//  Created by Alexander Grishin on 15.11.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImage(urlString: String?) -> URLSessionDownloadTask? {
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return nil
        }
        if let url = URL(string: urlString ?? "") {
            let session = URLSession.shared
            let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] url, _, error in
                DispatchQueue.global(qos: .utility).async {
                    if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            if let weakSelf = self {
                                weakSelf.image = image
                                imageCache.setObject(image, forKey: urlString as AnyObject)
                            }
                        }
                    }
                }
            })
            downloadTask.resume()
            return downloadTask
        }
        return nil
    }
}
