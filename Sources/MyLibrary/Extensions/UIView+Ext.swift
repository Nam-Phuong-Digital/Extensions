//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import UIKit
import SwiftUI

@available (iOS 13,*)
public struct SizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

@available (iOS 13,*)
public extension View {
    func tint(color:Color?) -> some View {
        modifier(iOS15TintColor(tintColor: color))
    }
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    func border(hidden:Bool = false, isCapsule:Bool = false, radius:CGFloat = 18, color:Color = Color(hex:"#C0C5CA")) -> some View {
        return modifier(BorderModifier(hidden: hidden, isCapsule:isCapsule, radius: radius, color: color))
    }
    
    @available(iOS, introduced: 13, deprecated: 15, message: "Use .safeAreaInset() directly") // 👈🏻 2
    @ViewBuilder
    func bottomSafeAreaInset<OverlayContent: View>(_ overlayContent: OverlayContent) -> some View {
        if #available(iOS 15.0, *) {
            self.safeAreaInset(edge: .bottom, spacing: 0, content: { overlayContent }) // 👈🏻 1
        } else {
            self.modifier(BottomInsetViewModifier(overlayContent: overlayContent))
        }
    }
    
    @ViewBuilder
    func ignoredBottomSafeAreaInset() -> some View {
        if #available(iOS 14.0, *) {
            self.ignoresSafeArea(.all, edges: .bottom)
        } else {
            self.edgesIgnoringSafeArea(.bottom)
        }
    }
    
    @ViewBuilder
    func ignoredKeyboardSafeAreaInset() -> some View {
        if #available(iOS 14.0, *) {
            self.ignoresSafeArea(.keyboard)
        } else {
            self.edgesIgnoringSafeArea(.bottom)
        }
    }
    
    @ViewBuilder
    func ignoredTopSafeAreaInset() -> some View {
        if #available(iOS 14.0, *) {
            self.ignoresSafeArea(.all, edges: .top)
        } else {
            self.edgesIgnoringSafeArea(.top)
        }
    }
    
    @ViewBuilder
    func removeWeirdExtraPaddingAtTop(minusHeight:CGFloat) -> some View {
        if #available(iOS 15.0, *) {
            self.padding(.top,-minusHeight)
        } else {
            self
        }
    }
}

public extension UIView {
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        if let name = NSStringFromClass(self).components(separatedBy: ".").last {
            return name
        }
        return String(describing: self)
    }
    
    func makeSnapshot() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func getRectInScreen() -> CGRect? {
        superview?.convert(frame, to: nil)
    }
    
    func drawCorner(corner:CGFloat,
                    borderWidth:CGFloat = 0,
                    borderColor:UIColor = .white) {
        layer.cornerRadius = corner
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    func getHeightConstraint() -> NSLayoutConstraint? {
        for constraint in constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                return constraint
            }
        }
        return nil
    }
    
    func getWidthConstraint() -> NSLayoutConstraint? {
        for constraint in constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.width {
                return constraint
            }
        }
        return nil
    }
    
    func boundInside(_ superView: UIView, insets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(insets.left)@999-[subview]-\(insets.right)@999-|", options: NSLayoutConstraint.FormatOptions(), metrics:nil, views:["subview":self]))
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(insets.top)@999-[subview]-\(insets.bottom)@999-|", options: NSLayoutConstraint.FormatOptions(), metrics:nil, views:["subview":self]))
    }
    
    func addRemoveButton(
        image:UIImage? = nil,
        target:Any?,
        action:Selector,
        keepObject:Any?
    ) {
        let button = ButtonHalfHeight(type: .custom)
        button.object = keepObject
        button.contentMode = .scaleToFill
        button.tag = 19001800
        button.setImage(image, for: UIControl.State())
        button.backgroundColor = .white
        button.addTarget(target, action: action, for: .touchUpInside)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        let top = button.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        top.priority = UILayoutPriority(999)
        let trailing = trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: 0)
        trailing.priority = UILayoutPriority(999)
        self.addConstraints([top,trailing])
        
        let height = button.heightAnchor.constraint(equalToConstant: 25)
        height.priority = UILayoutPriority(999)
        let ratio = button.widthAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1)
        ratio.priority = UILayoutPriority(999)
        button.addConstraints([height,ratio])
    }
    
    func removeRemoveButton(target:Any?,action:Selector?) {
        let btn = self.subviews.first(where: {$0.tag == 19001800}) as? UIButton
        btn?.removeTarget(target, action: action, for: .touchUpInside)
        btn?.removeFromSuperview()
    }
    
    func addTargetCustom(target:Any?,action:Selector, keepObject:Any?, boundInside:UIEdgeInsets = .zero) {
        removeTargetCustom(target: target, action: action)
        
        isUserInteractionEnabled = true
        let button = Button10Corner(type: .custom)
        button.object = keepObject
        button.tag = 19001801
        button.setTitle(nil, for: UIControl.State())
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.boundInside(self, insets: boundInside)
        button.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func removeTargetCustom(target:Any?,action:Selector?) {
        let btn = self.subviews.first(where: {$0.tag == 19001801}) as? UIButton
        btn?.removeTarget(target, action: action, for: .touchUpInside)
        btn?.removeFromSuperview()
    }
    
    func findClass(classNeeded:AnyClass) -> UIView? {
        var view:UIView?
        for subview in self.subviews {
            if subview.isKind(of: classNeeded) {
                view = subview
            } else {
                
                if subview.isKind(of: UITextView.self) ||
                    subview.isKind(of: UILabel.self) ||
                    subview.isKind(of: UIImageView.self) ||
                    subview.isKind(of: UIButton.self) {
                    continue
                } else {
                    if let v = subview.findClass(classNeeded:classNeeded) {
                        view = v
                    } else {
                        continue
                    }
                }
            }
        }
        return view
    }
}
