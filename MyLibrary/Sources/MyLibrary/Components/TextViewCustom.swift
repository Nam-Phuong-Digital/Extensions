//
//  TextViewCustom.swift
//  FindGo
//
//  Created by Dai Pham on 12/04/2023.
//

import UIKit
import Combine

public class TextViewCustom: BaseView, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    let PLACEHOLDER_TAG = 100
    
    var value:String = ""
    
    var onTyping:((String)->Void)?
    
    private var showPlaceholder:Bool = true {
        didSet {
            if self.lblPlaceholder != nil {
                self.lblPlaceholder.isHidden = !showPlaceholder
            }
        }
    }
    
    @IBInspectable var placeholder:String = "" {
        didSet {
            if lblPlaceholder != nil {
                lblPlaceholder.text = placeholder
            }
        }
    }
    
    @IBInspectable var placeholderColor:UIColor = UIColor.borderColor {
        didSet {
            if lblPlaceholder != nil {
                lblPlaceholder.textColor = placeholderColor
            }
        }
    }
    
    var font:UIFont? = UIFont.systemFont(ofSize: 17) {
        didSet {
            if textView != nil {
                textView.font = font
            }
        }
    }
    
    var text:String = "" {
        didSet {
            if textView != nil {
                textView.text = text
                showPlaceholder = textView.text.isEmpty
            }
        }
    }
    
    var textColor:UIColor? = .black {
        didSet {
            if textView != nil {
                textView.textColor = textColor
            }
        }
    }
    
    var isEnabled:Bool = true {
        didSet {
            guard textView != nil else {return}
            textView.isEditable = isEnabled
        }
    }
    
    public override func config() {
        super.config()
        view.backgroundColor = .clear
        backgroundColor = .clear
        textView.delegate = self
        
        lblPlaceholder.font = UIFont.systemFont(ofSize: 17)
        lblPlaceholder.text = self.placeholder
        lblPlaceholder.textColor = self.placeholderColor
        
        textView.textColor = textColor
        textView.font = font
        
        showPlaceholder = textView.text.isEmpty
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        showPlaceholder = false
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        showPlaceholder = textView.text.isEmpty
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        value = textView.text
        onTyping?(textView.text)
    }
    
}
