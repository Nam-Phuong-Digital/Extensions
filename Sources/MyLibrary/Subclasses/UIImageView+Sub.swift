//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import UIKit
import SwiftUI
import Photos

public class RoundImageView: UIImageViewProgress {
    
    // MARK: -  override
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.size.height/2
        layer.masksToBounds = true
    }
}

public class ImageView10Corner: UIImageViewProgress {
    
    public var onPress:((UIImageView)->Void)?
    
    // MARK: -  override
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.isMultipleTouchEnabled = true
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onPress?(self)
        super.touchesEnded(touches, with: event)
    }
}

public class ImageView5Corner: UIImageViewProgress {
    
    // MARK: -  override
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }
}

@available (iOS 13,*)
public struct BindingImageViewRepresentable:UIViewRepresentable {
    public typealias UIViewType = UIView
    
    @Binding public  var url:String?
    
    public func makeUIView(context: Context) -> UIView {
        let imv = UIImageViewProgress()
        imv.contentMode = .scaleAspectFill
        if let urlString = url {
            imv.loadImageProgress(url: URL(string: urlString))
        }
        let v = UIView()
        v.addSubview(imv)
        imv.boundInside(v)
        return v
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        (uiView.subviews.first as? UIImageViewProgress)?.cancelLoadImageProgress()
    }
    
}

@available (iOS 13,*)
public struct ImageViewRepresentable:UIViewRepresentable {
    public typealias UIViewType = UIView
    
    let url:String?
    let data:Data?
    let asset:PHAsset?
    let uiImage:UIImage?
    
    public init(url: String? = nil, data: Data? = nil,asset: PHAsset? = nil,uiImage:UIImage? = nil) {
        self.url = url
        self.data = data
        self.asset = asset
        self.uiImage = uiImage
    }
    
    public func makeUIView(context: Context) -> UIView {
        let imv = UIImageViewProgress()
        imv.contentMode = .scaleAspectFill
        if let url = url{
            imv.loadImageProgress(url: URL(string: url))
        }
        if let data = data{
            imv.image = UIImage(data: data)
        }
        if let asset = asset {
            Task {
                imv.image = await asset.getImage(size: PHImageManagerMaximumSize)
            }
        }
        if let uiImage = uiImage{
            imv.image = uiImage
        }
        let v = UIView()
        v.addSubview(imv)
        imv.boundInside(v)
        return v
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
}
