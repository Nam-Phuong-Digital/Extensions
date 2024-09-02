//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import Foundation
import Photos
import UIKit

public extension PHAsset {
    
    @available(iOS 13,*)
    func getImage(size:CGSize, deliveryMode:PHImageRequestOptionsDeliveryMode = .opportunistic)
    async -> UIImage? {
        return await withUnsafeContinuation({ c in
            getImage(size: size, deliveryMode: deliveryMode) { image in
                c.resume(returning: image)
            }
        })
    }
    
    @discardableResult
    func getImage(size:CGSize, deliveryMode:PHImageRequestOptionsDeliveryMode = .opportunistic,_ completion:((UIImage?)->Void)? = nil) -> PHImageRequestID? {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isNetworkAccessAllowed = true
        option.resizeMode = .exact
        option.deliveryMode = deliveryMode
        option.isSynchronous = true
        return manager.requestImage(for: self, targetSize: size, contentMode: .aspectFit, options: option, resultHandler: {[weak self] (result, info)->Void in
            guard let _self = self else {
                completion?(nil)
                return
            }
            if let result = result {
                completion?(result)
            } else {
                manager.requestImageData(for: _self, options: option) { (data, str, orientation, info) in
                    if let data = data {
                        completion?(UIImage(data: data))
                    } else {
                        completion?(nil)
                    }
                }
            }
        })
    }
    
    func cancelRequest(requestId:PHImageRequestID) {
        PHImageManager.default().cancelImageRequest(requestId)
    }
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
    
    func getDataToUpload(
        maxLength:Int = 320000,
        size: CGSize = UIScreen.bounceWindow.size,
        completionHandler : @escaping ((_ responseURL : URL?,_ data:Data?,_ error:Any?) -> Void)
    ){
        if self.mediaType == .image {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isNetworkAccessAllowed = true
            option.resizeMode = .exact
            option.deliveryMode = .highQualityFormat
            option.isSynchronous = true
            manager.requestImage(for: self, targetSize: size, contentMode: .default, options: option) { image, info in
                if let image = image {
                    ImageCompressor.compress(image: image, maxByte: maxLength) { image in
                        DispatchQueue.main.async {
                            completionHandler(nil,image?.jpegData(compressionQuality: 1),nil)
                        }
                    }
                } else {
                    completionHandler(nil,nil,info)
                }
            }
            
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
//            options.version = .current
            options.deliveryMode = .mediumQualityFormat
            options.isNetworkAccessAllowed = true
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url
                    completionHandler(localVideoUrl,try? Data(contentsOf: localVideoUrl, options: []),nil)
                } else {
                    completionHandler(nil,nil,info)
                }
            })
        }
    }
    
    @available(iOS 13,*)
    func getDataToUpload(maxLength:Int = 320000, size: CGSize) async throws -> (URL?,Data?) {
        return try await withUnsafeThrowingContinuation({ c in
            self.getDataToUpload(maxLength: maxLength,size: size) { responseURL, data, error in
                if error != nil {
                    c.resume(throwing: NSError(domain: "com.photos.error.app", code: 404, userInfo: [:]))
                } else {
                    c.resume(returning: (responseURL,data))
                }
            }
        })
    }
}
