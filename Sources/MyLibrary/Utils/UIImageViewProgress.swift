//
//  UIImageViewProgress.swift
//  ChupHinhDep
//
//  Created by Van Trieu Phu Huy on 7/18/16.
//  Copyright © 2016 ePepaperSmart. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImage {
    
    func getImageFromRect(rect: CGRect) -> UIImage? {
        if let cg = self.cgImage,
            let mySubimage = cg.cropping(to: rect) {
            return UIImage(cgImage: mySubimage)
        }
        return nil
    }
    
    func blurImage(withRadius radius: Double) -> UIImage? {
        let inputImage = UIKit.CIImage(cgImage: self.cgImage!)
        if let filter = CIFilter(name: "CIGaussianBlur") {
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            filter.setValue((radius), forKey: kCIInputRadiusKey)
            if let blurred = filter.outputImage {
                return UIImage(ciImage: blurred)
            }
        }
        return nil
    }
    
    func drawImageInRect(inputImage: UIImage, inRect imageRect: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height))
        inputImage.draw(in: imageRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func applyBlurInRect(rect: CGRect, withRadius radius: Double) -> UIImage? {
        if let subImage = self.getImageFromRect(rect: rect),
            let blurredZone = subImage.blurImage(withRadius: radius) {
            return self.drawImageInRect(inputImage: blurredZone, inRect: rect)
        }
        return nil
    }
    
}




@objc protocol UIImageViewProgressDelegate: NSObjectProtocol {
    
    @objc optional func userLikeImage()
    
}


open class UIImageViewProgress: UIImageView {
    
    var urlImageString: String?
    
    weak var delegate: UIImageViewProgressDelegate?
    
    var isLoadSuccessed = false
    
    weak var sdWebImageOperation: SDWebImageOperation?
    
    let circularProgressView = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    let imageViewHeart = UIImageView(image: UIImage(named: "heart.png"))
    
    class func cacheKey(for url:URL) -> String {
        return SDWebImageManager.shared.cacheKey(for: url) ?? ""
        
    }
    
//    class func saveCacheImage(for image:UIImage, for url: URL?) {
//        if(url != nil) {
//            SDWebImageManager.shared.saveImage(toCache: image, for: url)
//        }
//    }
//
//    class func imageCache(for url: URL?) -> UIImage? {
//        if(url != nil) {
//            return SDWebImageManager.shared.imageCache?.imageFromDiskCache(forKey: UIImageViewProgress.cacheKey(for: url!))
//        } else {
//            return nil
//        }
//    }
    
    
    
    deinit {
//        print("Deinit UIImageViewProgress")
    }
    
    init() {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.circularProgressView.frame = CGRect(x: (self.frame.size.height - 80)/2.0, y: (self.frame.size.height - 80)/2.0, width: 80, height: 80)
        
        self.circularProgressView.autoresizingMask = [.flexibleTopMargin,.flexibleBottomMargin,.flexibleRightMargin,.flexibleLeftMargin]
        //self.circularProgressView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.circularProgressView.trackColor = UIColor.white
        self.circularProgressView.startAngle = -90
        self.circularProgressView.progressThickness = 0.13
        self.circularProgressView.trackThickness = 0.13
        self.circularProgressView.clockwise = true
        self.circularProgressView.gradientRotateSpeed = 0.0
        self.circularProgressView.roundedCorners = false
        //self.circularProgressView.glowMode = .Forward
        self.circularProgressView.glowAmount = 0.0
        //self.circularProgressView.setColors(UIColor.cyanColor() ,UIColor.whiteColor(), UIColor.magentaColor(), UIColor.whiteColor(), UIColor.orangeColor())
        self.circularProgressView.set(colors: UIColor.black)
        //self.circularProgressView.center = CGPoint(x: self.center.x, y: self.center.y + 25)
        self.circularProgressView.tag = 1000
        addSubview(self.circularProgressView)
        
        addDoubleTap()
        
        
        
    }
    
    init(isProgressBar:Bool) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        if(isProgressBar){
            self.circularProgressView.frame = CGRect(x: (self.frame.size.height - 80)/2.0, y: (self.frame.size.height - 80)/2.0, width: 80, height: 80)
            self.circularProgressView.autoresizingMask = [.flexibleTopMargin,.flexibleBottomMargin,.flexibleRightMargin,.flexibleLeftMargin]
            //self.circularProgressView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            self.circularProgressView.trackColor = UIColor.white
            self.circularProgressView.startAngle = -90
            self.circularProgressView.progressThickness = 0.13
            self.circularProgressView.trackThickness = 0.13
            self.circularProgressView.clockwise = true
            self.circularProgressView.gradientRotateSpeed = 0.0
            self.circularProgressView.roundedCorners = false
            //self.circularProgressView.glowMode = .Forward
            self.circularProgressView.glowAmount = 0.0
            //self.circularProgressView.setColors(UIColor.cyanColor() ,UIColor.whiteColor(), UIColor.magentaColor(), UIColor.whiteColor(), UIColor.orangeColor())
            self.circularProgressView.set(colors: UIColor.black)
            //self.circularProgressView.center = CGPoint(x: self.center.x, y: self.center.y + 25)
            self.circularProgressView.tag = 1000
            addSubview(self.circularProgressView)
            
            
        }
        
        
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.circularProgressView.frame = CGRect(x: (self.frame.size.height - 80)/2.0, y: (self.frame.size.height - 80)/2.0, width: 80, height: 80)
        
        self.circularProgressView.autoresizingMask = [.flexibleTopMargin,.flexibleBottomMargin,.flexibleRightMargin,.flexibleLeftMargin]
        //self.circularProgressView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.circularProgressView.trackColor = UIColor.white
        self.circularProgressView.startAngle = -90
        self.circularProgressView.progressThickness = 0.13
        self.circularProgressView.trackThickness = 0.13
        self.circularProgressView.clockwise = true
        self.circularProgressView.gradientRotateSpeed = 0.0
        self.circularProgressView.roundedCorners = false
        //self.circularProgressView.glowMode = .Forward
        self.circularProgressView.glowAmount = 0.0
        //self.circularProgressView.setColors(UIColor.cyanColor() ,UIColor.whiteColor(), UIColor.magentaColor(), UIColor.whiteColor(), UIColor.orangeColor())
        self.circularProgressView.set(colors: UIColor.black)
        //self.circularProgressView.center = CGPoint(x: self.center.x, y: self.center.y + 25)
        self.circularProgressView.tag = 1000
        self.circularProgressView.isHidden = true
        addSubview(self.circularProgressView)
        
        
    }
    
    func addDoubleTap() {
        self.isLoadSuccessed = false
        self.imageViewHeart.isHidden = true
        self.imageViewHeart.frame = CGRect(x: (self.frame.size.height - 80)/2.0, y:(self.frame.size.height - 80)/2.0, width: 80, height: 80)
        self.imageViewHeart.autoresizingMask = [.flexibleTopMargin,.flexibleBottomMargin,.flexibleRightMargin,.flexibleLeftMargin]
        addSubview(self.imageViewHeart)
        
        // Single Tap
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(sender:)))
        singleTap.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTap)
        
        // Double Tap
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(sender:)))
        doubleTap.numberOfTapsRequired = 2
        //singleTap.requireGestureRecognizerToFail(doubleTap)
        self.addGestureRecognizer(doubleTap)
        
        self.isUserInteractionEnabled = true
    }
    
    
    func loadImageNoProgressBar(url: URL?) {
        
        if(!self.circularProgressView.isHidden){
            self.circularProgressView.isHidden = true
            self.circularProgressView.angle = 0.0
        }
        if(url != nil) {
            self.urlImageString = url!.absoluteString
            self.cancelLoadImageProgress()
            sdWebImageOperation = SDWebImageManager.shared.loadImage(with: url as URL?, options: SDWebImageOptions.allowInvalidSSLCertificates, progress: nil, completed: { (image, data, error, cacheType, bool, url) in
                if image != nil {
                    self.isLoadSuccessed = true
                    self.image = image
                } else {
                    self.image = UIImage(named: "ic_errorImage.png")
//                    if #available(iOS 14, *) {
//                        AppLogger.shared.loggerAPI.error("\(error?.message ?? "")")
//                    }
                }
            })
        }
        
    }
    
    
    func loadImageProgress(url: URL?) {
        if(url != nil) {
            self.urlImageString = url!.absoluteString
            self.cancelLoadImageProgress()
            if(self.circularProgressView.isHidden){
                self.circularProgressView.isHidden = false
                self.circularProgressView.angle = 0.0
            }
            /*
             self.sd_setImage(with: url as URL!, placeholderImage: nil, options: .cacheMemoryOnly , progress: { [weak self](receivedSize, expectedSize) -> Void in
             let progressView = self?.viewWithTag(1000) as! KDCircularProgress
             progressView.angle = (Double(receivedSize)/Double(expectedSize) * 360.0)
             
             
             }) { [weak self](image, error, _, _) -> Void in
             
             self!.image = image
             let progressView = self?.viewWithTag(1000) as! KDCircularProgress
             if(!(progressView.isHidden)){
             progressView.isHidden = true
             }
             
             
             }
             */
            sdWebImageOperation = SDWebImageManager.shared.loadImage(with: url as URL?, options: SDWebImageOptions.allowInvalidSSLCertificates, progress: { [weak self](min, max, url) in
                DispatchQueue.main.async {
                    if let progressView = self?.viewWithTag(1000) as? KDCircularProgress {
                        progressView.angle = Double(min)/Double(max) * 360
                    }
                }
                }, completed: { [weak self](image, data, error, cacheType, bool, url) in
                    DispatchQueue.main.async {
                        if image != nil {
                            self?.isLoadSuccessed = true
                            self?.image = image
                            let progressView = self?.viewWithTag(1000) as? KDCircularProgress
                            if(progressView != nil){
                                progressView!.isHidden = true
                            }
                        } else {
//                            if #available(iOS 14, *) {
//                                AppLogger.shared.loggerAPI.error("\(error?.message ?? "")")
//                            }
                        }
                    }
            })
            
            
        }
        
        
        
    }
    
    func cancelLoadImageProgress() {
        //urlImageString = nil
        self.image = nil
        self.sdWebImageOperation?.cancel()
        if(!self.circularProgressView.isHidden){
            self.circularProgressView.isHidden = true
        }
    }
    
    @objc func handleSingleTap(sender:AnyObject) {
        
    }
    
    @objc func handleDoubleTap(sender:AnyObject) {
        if(self.isLoadSuccessed) {
            self.animateLike()
        }
        
    }
    
    
    
    func animateLike() {
        
        self.imageViewHeart.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {
            //
            self.imageViewHeart.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.imageViewHeart.alpha = 1.0
        }) { (finished) in
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .allowUserInteraction, animations: {
                //
                self.imageViewHeart.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (finished) in
                UIView.animate(withDuration: 0.5, delay: 0.5, options: .allowUserInteraction, animations: {
                    //
                    self.imageViewHeart.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    self.imageViewHeart.alpha = 0.0
                }) { (finished) in
                    //
                    
                    self.imageViewHeart.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    self.imageViewHeart.isHidden = true
                    self.delegate?.userLikeImage?()
                }
            }
        }
    }
    
    
    
    
}
