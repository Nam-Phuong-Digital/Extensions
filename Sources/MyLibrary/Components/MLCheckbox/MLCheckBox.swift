//
//  MLCheckBox.swift
//  
//
//  Created by Dai Pham on 5/6/24.
//

import UIKit

@IBDesignable
public class MLCheckBox: UIControl {

    @IBInspectable
    public var normalImage: UIImage?
    
    @IBInspectable
    public var selectedImage: UIImage?
    
    @IBInspectable
    public var isChecked: Bool = false {
        didSet {
            updateUI()
            sendActions(for: .valueChanged)
        }
    }
    
    public init(
        normalImage: UIImage?,
        selectedImage: UIImage?,
        isChecked: Bool = false
    ) {
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        self.isChecked = isChecked
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        self.isChecked = false
        super.init(coder: coder)
        setupViews()
    }
    
    private let titleLabel = UILabel()
    private let stack = UIStackView(frame: .zero)
    private let imageView = UIImageView()
    
    private func setupViews() {
        
        [stack, titleLabel, imageView].forEach{ $0.isUserInteractionEnabled = false }
        
        stack.axis = .horizontal
        stack.alignment = .top
        stack.distribution = .fill
        stack.spacing = 10
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        titleLabel.font = .systemFont(ofSize: 14)
        
        imageView.image = normalImage
        imageView.highlightedImage = selectedImage
        
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(titleLabel)
        
        stack.boundInside(self, insets: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
        
        updateUI()
    }
    
    private func updateUI() {
        imageView.isHighlighted = isChecked
    }
    
    // MARK: -  PUBLIC APIS
    public func setColor(_ color: UIColor) {
        tintColor = color
        imageView.tintColor = color
        titleLabel.textColor = color
    }
    
    public func setTitle(_ text: String?) {
        titleLabel.text = text
    }
}
