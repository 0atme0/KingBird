//
//  Extensions.swift
//  KingBirdTest
//
//  Created by Andrey Ildyakov on 13.12.16.
//
//

import Foundation

extension UIImage {
    func cropImage() -> UIImage {
        let img = self
        let croprect = CGRectMake(img.size.width / 20, img.size.height / 20,img.size.width / 1.5, img.size.height / 1.5)
        let imageRef = CGImageCreateWithImageInRect(img.CGImage!, croprect)
        let croppedImage = UIImage.init(CGImage: imageRef!)
        
        return croppedImage
    }
}
