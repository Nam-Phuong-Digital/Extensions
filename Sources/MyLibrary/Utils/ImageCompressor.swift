//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import UIKit
#if canImport(RxSwift)
import RxSwift
#endif

public struct ImageCompressor {
    #if canImport(RxSwift)
    public static func compress(image: UIImage, maxBytes: Int = 320_000) -> Single<UIImage?> {
        Single.create { ob in
            ImageCompressor.compress(image: image, maxByte: maxBytes, completion: {image in
                ob(.success(image))
            })
            return Disposables.create()
        }
    }
    #endif
    
    static public func compress(image: UIImage, maxByte: Int,
                         completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let currentImageSize = image.jpegData(compressionQuality: 1.0)?.count else {
                return completion(nil)
            }
        
            var iterationImage: UIImage? = image
            var iterationImageSize = currentImageSize
            var iterationCompression: CGFloat = 1.0
        
            while iterationImageSize > maxByte && iterationCompression > 0.01 {
                let percantageDecrease = getPercantageToDecreaseTo(forDataCount: iterationImageSize)
            
                let canvasSize = CGSize(width: image.size.width * iterationCompression,
                                        height: image.size.height * iterationCompression)
                UIGraphicsBeginImageContextWithOptions(canvasSize, false, image.scale)
                defer { UIGraphicsEndImageContext() }
                image.draw(in: CGRect(origin: .zero, size: canvasSize))
                iterationImage = UIGraphicsGetImageFromCurrentImageContext()
            
                guard let newImageSize = iterationImage?.jpegData(compressionQuality: 1.0)?.count else {
                    return completion(nil)
                }
                iterationImageSize = newImageSize
                iterationCompression -= percantageDecrease
            }
            completion(iterationImage)
        }
    }

    private static func getPercantageToDecreaseTo(forDataCount dataCount: Int) -> CGFloat {
        switch dataCount {
        case 0..<3000000: return 0.05
        case 3000000..<10000000: return 0.1
        default: return 0.2
        }
    }
}

@available(iOS 13.0.0, *)
public extension ImageCompressor {
    static func compress(image: UIImage, maxByte: Int = 320_000) async -> UIImage? {
        return await withUnsafeContinuation({ c in
            ImageCompressor.compress(image: image, maxByte: maxByte) { image in
                c.resume(returning: image)
            }
        })
    }
}

