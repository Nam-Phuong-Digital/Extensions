//
//  File.swift
//  
//
//  Created by Dai Pham on 30/01/2024.
//

import SwiftUI

@available(iOS 13,*)
public struct iOS15TintColor: ViewModifier {
   
    init(tintColor:Color?) {
        self.tintColor = tintColor
    }
    
    var tintColor:Color?
    
    public func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .tint(tintColor)
        } else {
            content
                .accentColor(tintColor)
        }
    }
    
}

@available(iOS 14.0, *)
struct Redacted: ViewModifier {
    @Binding var isPlaceHolder:Bool
    
    func body(content: Content) -> some View {
        if isPlaceHolder {
            content
                .redacted(reason: RedactionReasons.placeholder)
        } else {
            content
                .unredacted()
        }
    }
}

// MARK: -  ViewModifier
@available(iOS 13,*)
struct BorderModifier: ViewModifier {
    
    var hidden:Bool = false
    var isCapsule:Bool = false
    var radius:CGFloat = 18
    var color:Color
    
    func body(content: Content) -> some View {

        if !hidden {
            if #available(iOS 15.0, *) {
                content
                    .overlay {
                        if isCapsule {
                            Capsule()
                                .strokeBorder(color,lineWidth: 1, antialiased: true)
                        } else {
                            RoundedRectangle(cornerRadius: radius)
                                .strokeBorder(color,lineWidth: 1, antialiased: true)
                        }
                    }
            } else {
                content
                    .overlay (
                            below15()
                    )
            }
        } else {
            content
        }
    }
    
    @ViewBuilder
    func below15() -> some View {
        if isCapsule {
            Capsule()
                .strokeBorder(color,lineWidth: 1, antialiased: true)
        } else {
            RoundedRectangle(cornerRadius: radius)
                .strokeBorder(color,lineWidth: 1, antialiased: true)
        }
    }
}

@available(iOS 13,*)
struct BottomInsetViewModifier<OverlayContent: View>: ViewModifier {
  var overlayContent: OverlayContent
  func body(content: Self.Content) -> some View {
    content
      .overlay(
        overlayContent
//            .padding(.bottom, UICommon.shared.safeAreaInset.bottom) // 👈🏻 2
        ,
        alignment: .bottom
      )
  }
}

@available(iOS 13,*)
struct ModalBackgroundViewModifier: ViewModifier {
    let color:UIColor
    func body(content: Content) -> some View {
        content
            .background(ModalBackgroundViewView(color: color))
    }
    
    struct ModalBackgroundViewView: UIViewRepresentable {
        let color:UIColor
        
        func makeUIView(context: Context) -> some UIView {
            let view = UIView()
            DispatchQueue.main.async {
                view.superview?.superview?.backgroundColor = color
            }
            return view
        }
        func updateUIView(_ uiView: UIViewType, context: Context) {
        }
    }
}

@available(iOS 13,*)
struct ClearTopBackgroundViewModifier: ViewModifier {
    let top:CGFloat
    func body(content: Content) -> some View {
        content
            .background(ClearTopBackgroundSheetView(top: top))
    }
    
    struct ClearTopBackgroundSheetView: UIViewRepresentable {
        let top:CGFloat
        
        func makeUIView(context: Context) -> some UIView {
            let view = UIView()
            DispatchQueue.main.async {
                view.superview?.superview?.backgroundColor = .clear
            }
            let view2 = UIView()
            view2.backgroundColor = .white
            view.addSubview(view2)
            view2.layer.cornerRadius = 18
            view2.translatesAutoresizingMaskIntoConstraints = false
            view2.boundInside(view, insets: UIEdgeInsets(top: top, left: 0, bottom: -top, right: 0))
            return view
        }
        func updateUIView(_ uiView: UIViewType, context: Context) {
        }
    }
}
