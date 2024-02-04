//
//  File.swift
//  
//
//  Created by Dai Pham on 04/02/2024.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

@available (iOS 13,*)
public struct StandardButton: ButtonStyle {
    let bgColor:Color
    let textColor:Color
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 20))
            .foregroundColor(textColor)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            .frame(height: 50)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
