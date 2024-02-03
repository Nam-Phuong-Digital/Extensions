//
//  File.swift
//  
//
//  Created by Dai Pham on 31/01/2024.
//

import UIKit

public extension UIImage {
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let newImage = newImage else {
            return self
        }
        return newImage
    }
    
    func resizeImage(newSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = newSize.width  / size.width
        let heightRatio = newSize.height / size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: newSize)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let newImage = newImage else {
            return self
        }
        return newImage
    }
    
    func maskRoundedImage(radius: CGFloat? = nil) -> UIImage {
        let width = min(self.size.width,self.size.height)
        let imageView: UIImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: width)))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius == nil ? self.size.width/2 : radius!
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size,false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let newImage = roundedImage else {
            return self
        }
        return newImage
    }
    
    func maskCornerRadiusImage(radius: CGFloat) -> UIImage {
        let width = min(self.size.width,self.size.height)
        let imageView: UIImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: width)))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        let layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size,false, UIScreen.main.scale)
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return self
        }
        layer.render(in: currentContext)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let newImage = roundedImage else {
            return self
        }
        return newImage
    }
    
    func tint(with color: UIColor) -> UIImage {
        let image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(origin: .zero, size: size))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return self
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    static func textToImage(drawText text: String, inImage image: UIImage, atPoint point: CGPoint? = nil) -> UIImage {
        let textColor = UIColor.red
        let textFont = UIFont.boldSystemFont(ofSize: 12)
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes:[NSAttributedString.Key:Any] = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
        ] as [NSAttributedString.Key : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        var p = CGPoint.zero
        if let pp = point {
            p = pp
        }
        let rect = CGRect(origin: p, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let newImage = newImage else {
            return image
        }
        return newImage
    }
    
    func isEqualToImage(image: UIImage) -> Bool {
        guard let data1 = self.pngData(),
              let data2 = image.pngData() else {return false}
        let dt1 = data1 as NSData
        let dt2 = data2 as NSData
        return dt1.isEqual(dt2)
    }
}
