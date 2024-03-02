//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import Foundation
import SwiftUI

open class IBInspectableView:UIView {
    @IBInspectable public var haveShadow:Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable public var borderColor:UIColor = .clear {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable public var borderWidth:CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
}

@available (iOS 13,*)
/// This view bring sourceview uikit from swiftui bring to uikit to use, suggest overlay on position you want action sheet
public struct SourceViewAction:UIViewRepresentable {
    public typealias UIViewType = UIView

    public var onTap:((UIView)->Void)?
    public init(onTap: ( (UIView) -> Void)? = nil) {
        self.onTap = onTap
    }
    
    public func makeUIView(context: Context) -> UIView {
        let imv = UIView()
        imv.backgroundColor = .clear
        imv.addTargetCustom(target: context.coordinator, action: #selector(context.coordinator.tap(_:)), keepObject: nil)
        return imv
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    public func makeCoordinator() -> Action {
        return Action {self.onTap?($0)}
    }
    
    public class Action {
        public var onTap:((UIView)->Void)?
        public init(onTap: ((UIView) -> Void)? = nil) {
            self.onTap = onTap
        }
        @objc public func tap(_ sender:Button10Corner) {
            onTap?(sender)
        }
    }
}

@available (iOS 13,*)
public struct Loading:View {
    let style: UIActivityIndicatorView.Style
    let color:UIColor?
    public init(style: UIActivityIndicatorView.Style = .medium, color: UIColor? = .black) {
        self.style = style
        self.color = color
    }
    public var body: some View {
        if #available(iOS 14.0, *) {
            ProgressView()
                .tint(color: Color(color ?? .black))
        } else {
            ProgressIndicatior(style: style, color: color)
        }
    }
}

@available (iOS 13,*)
public struct ProgressIndicatior: UIViewRepresentable {
    
    let style: UIActivityIndicatorView.Style
    let color:UIColor?
    
    init(style: UIActivityIndicatorView.Style = .medium,color:UIColor? = .black) {
        self.style = style
        self.color = color
    }
    
    public func makeUIView(context: Context) -> UIActivityIndicatorView {
        let v = UIActivityIndicatorView(style: style)
        v.hidesWhenStopped = true
        v.color = self.color
        v.startAnimating()
        return v
    }
    
    public func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
    }
}

open class Corner12View: IBInspectableView {
    open override func layoutSubviews() {
        super.layoutSubviews()
        drawCorner(
            corner: 12,
            borderWidth: borderWidth,
            borderColor: borderColor
        )
        if haveShadow {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.25
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 2
        } else {
            layer.masksToBounds = true
            layer.shadowColor = UIColor.clear.cgColor
        }
    }
}

public class PopoverCoverView: UIView {
    
    var fillColor:UIColor = .white {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    var cornerRadius:CGFloat = 10 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    var isUp:Bool = false {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    var arrowRect:CGRect = .zero {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDefaultMargin()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setDefaultMargin()
    }
    
    func setDefaultMargin() {
        // subviews constraints should check relativeMargins
        if #available(iOS 11.0, *) {
            self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: arrowRect.height, leading: 0, bottom: arrowRect.height, trailing: 0)
        } else {
            self.layoutMargins = UIEdgeInsets(top: arrowRect.height, left: 0, bottom: arrowRect.height, right: 0)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDefaultMargin()
    }
    
    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), arrowRect != .zero else { return }
        let shadowHeight:CGFloat = 0
        context.saveGState()
//        context.setShadow(offset: CGSize(width: -shadowHeight/2, height: shadowHeight), blur: 5)

        var arrowRect = self.arrowRect
        if arrowRect.minX < rect.minX + cornerRadius {
            arrowRect.origin.x = rect.minX + cornerRadius
        } else if arrowRect.maxX > rect.maxX - cornerRadius {
            arrowRect.origin.x = rect.maxX - cornerRadius - arrowRect.width
        }
        
        let minX = rect.minX + shadowHeight
        let minY = rect.minY + arrowRect.height
        let maxX = rect.maxX - shadowHeight
        let maxY = rect.maxY - arrowRect.height

        if isUp {
            
            context.beginPath()
            context.move(to: CGPoint(x: minX + cornerRadius, y: minY))
            
            // draw anchor point
            context.addLine(to: CGPoint(x: arrowRect.minX, y: minY))
            context.addLine(to: CGPoint(x: arrowRect.minX + arrowRect.width/2, y: minY - arrowRect.height + shadowHeight))
            context.addLine(to: CGPoint(x: arrowRect.minX + arrowRect.width, y: minY))
            
            context.addLine(to: CGPoint(x: maxX - cornerRadius, y: minY))
            
            // add corner top right
            context.addArc(center: CGPoint(x: maxX - cornerRadius, y: minY + cornerRadius), radius: cornerRadius, startAngle: 270 * CGFloat.pi/180, endAngle: 0 * CGFloat.pi/180, clockwise: false)
            
            context.addLine(to: CGPoint(x: maxX, y: maxY - cornerRadius))
            
            // add corner bottom right
            context.addArc(center: CGPoint(x: maxX - cornerRadius, y: maxY - cornerRadius), radius: cornerRadius, startAngle: 0 * CGFloat.pi/180, endAngle: 90 * CGFloat.pi/180, clockwise: false)
            
            context.addLine(to: CGPoint(x: minX + cornerRadius, y: maxY))
            
            // add corner bottom left
            context.addArc(center: CGPoint(x: minX + cornerRadius, y: maxY - cornerRadius), radius: cornerRadius, startAngle: 90 * CGFloat.pi/180, endAngle: 180 * CGFloat.pi/180, clockwise: false)
            
            context.addLine(to: CGPoint(x: minX, y: minY + cornerRadius))
            
            // add corner top left
            context.addArc(center: CGPoint(x: minX + cornerRadius, y: minY + cornerRadius), radius: cornerRadius, startAngle: 180 * CGFloat.pi/180, endAngle: 270 * CGFloat.pi/180, clockwise: false)
            
            context.closePath()
        } else {
            
            context.beginPath()
            context.move(to: CGPoint(x: minX + cornerRadius, y: minY))
            context.addLine(to: CGPoint(x: maxX - cornerRadius, y: minY))
            
            // add corner top right
            context.addArc(center: CGPoint(x: maxX - cornerRadius, y: minY + cornerRadius), radius: cornerRadius, startAngle: 270 * CGFloat.pi/180, endAngle: 0 * CGFloat.pi/180, clockwise: false)
            
            context.addLine(to: CGPoint(x: maxX, y: maxY - cornerRadius))
            
            // add corner bottom right
            context.addArc(center: CGPoint(x: maxX - cornerRadius, y: maxY - cornerRadius), radius: cornerRadius, startAngle: 0 * CGFloat.pi/180, endAngle: 90 * CGFloat.pi/180, clockwise: false)
            
            context.addLine(to: CGPoint(x: minX + cornerRadius, y: maxY))
            
            // draw anchor point
            context.addLine(to: CGPoint(x: arrowRect.maxX, y: maxY))
            context.addLine(to: CGPoint(x: arrowRect.maxX - arrowRect.width/2, y: maxY + arrowRect.height - shadowHeight))
            context.addLine(to: CGPoint(x: arrowRect.maxX - arrowRect.width, y: maxY))
            
            // add corner bottom left
            context.addArc(center: CGPoint(x: minX + cornerRadius, y: maxY - cornerRadius), radius: cornerRadius, startAngle: 90 * CGFloat.pi/180, endAngle: 180 * CGFloat.pi/180, clockwise: false)
            
            context.addLine(to: CGPoint(x: minX, y: minY + cornerRadius))
            
            // add corner top left
            context.addArc(center: CGPoint(x: minX + cornerRadius, y: minY + cornerRadius), radius: cornerRadius, startAngle: 180 * CGFloat.pi/180, endAngle: 270 * CGFloat.pi/180, clockwise: false)
            
            context.closePath()
        }
        
        context.setFillColor(fillColor.cgColor)
        context.fillPath()
        context.restoreGState()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setDefaultMargin()
        layer.masksToBounds = true
        backgroundColor = .clear
    }
}

open class HalfCornerView: IBInspectableView {

    public override func layoutSubviews() {
        super.layoutSubviews()
        drawCorner(
            corner: self.frame.height/2,
            borderWidth: borderWidth,
            borderColor: borderColor
        )
    }
}

open class RoundCornerView: IBInspectableView {
    
    // MARK: -  override
    open override func layoutSubviews() {
        super.layoutSubviews()
        drawCorner(
            corner: self.frame.height/2,
            borderWidth: borderWidth,
            borderColor: borderColor
        )
        if haveShadow {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.25
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 2
        } else {
            layer.masksToBounds = true
            layer.shadowColor = UIColor.clear.cgColor
        }
    }
}

open class Corner10View: IBInspectableView {
    
    // MARK: -  override
    open override func layoutSubviews() {
        super.layoutSubviews()
        drawCorner(
            corner: 10,
            borderWidth: borderWidth,
            borderColor: borderColor
        )
        if haveShadow {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.25
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 2
        } else {
            layer.masksToBounds = true
            layer.shadowColor = UIColor.clear.cgColor
        }
    }
}

open class Corner5View: IBInspectableView {
    
    // MARK: -  override
    open override func layoutSubviews() {
        super.layoutSubviews()
        drawCorner(
            corner: 5,
            borderWidth: borderWidth,
            borderColor: borderColor
        )
        if haveShadow {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.25
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 2
        } else {
            layer.masksToBounds = true
            layer.shadowColor = UIColor.clear.cgColor
        }
    }
}
