//
//  NumberField.swift
//  Pods
//
//  Created by Tsang Kenneth on 20/3/2017.
//
//

import Foundation
import UIKit

@objc public protocol NumberFieldDelegate: class {
    @objc optional func numberFieldDidEndEditing(_ sender: NumberField, value: Double)
    @objc optional func numberFieldDidBeginEditing(_ sender: NumberField, value: Double)
    @objc optional func numberFieldDidReceiveWrongInput(_ sender: NumberField)
}

@objc public enum NumberFieldAlignment: Int {
    case left
    case right
}

@objc open class NumberField: UIView {
    weak public var delegate: NumberFieldDelegate?
    
    //MARK: Keyboard Customization
    @IBInspectable public var keyboardHeight: CGFloat = 260
    @IBInspectable public var keyboardBorderColor: UIColor = UIColor.lightGray
    @IBInspectable public var keyboardTextColor: UIColor = UIColor.darkText
    @IBInspectable public var keyboardBackgroundColor: UIColor = UIColor(white: 0.99, alpha: 1.0)
    @IBInspectable public var keyboardDecimalPlaceColor: UIColor = UIColor(white: 0.99, alpha: 1.0)
    @IBInspectable public var keyboardBackspaceColor: UIColor = UIColor(white: 0.90, alpha: 1.0)
    
    //MARK: NumberField Customization
    @IBInspectable public var decimalPlace: Int = 0
    @IBInspectable public var maxValue: Double = Double(0)
    @IBInspectable public var value: Double = Double(0) {
        didSet {
            tempVal = value
            text = String(format: "%.\(decimalPlace)f",value)
        }
    }
    @IBInspectable public var font: UIFont {
        get { return label.font }
        set { label.font = newValue }
    }
    @IBInspectable public var textColor: UIColor {
        get { return label.textColor }
        set { label.textColor = newValue }
    }
    @IBInspectable public var textAlignment = NumberFieldAlignment.right {
        didSet {
            redrawSubviews()
        }
    }
    
    //MARK: Private Varibles
    fileprivate var tempVal = Double(0)
    fileprivate var text: String {
        get { return label.text ?? "" }
        set { label.text = newValue }
    }
    
    //MARK: Subviews
    private let label = UILabel()
    private let cursor = FakeCursor()

    //MARK: Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        clipsToBounds = true
        redrawSubviews()
        // Become first responder when tapped
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder))
        addGestureRecognizer(tapGesture)
    }
    
    private func redrawSubviews() {
        label.removeFromSuperview()
        cursor.removeFromSuperview()
        addSubview(label)
        addSubview(cursor)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        cursor.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["label": label, "cursor": cursor]
        label.backgroundColor = UIColor.red
        let vfl = (textAlignment == .right) ? "H:|-(>=5)-[label][cursor]-4-|" : "H:|-(5)-[label][cursor]-(>=4)-|"
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: vfl, options: [], metrics: nil, views: views)
        let labelYConstraints = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let cursorYConstraints = NSLayoutConstraint(item: cursor, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let cursorHeightConstraints = NSLayoutConstraint(item: cursor, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.7, constant: 0)
        addConstraints(hConstraints)
        addConstraint(labelYConstraints)
        addConstraint(cursorYConstraints)
        addConstraint(cursorHeightConstraints)
        layoutIfNeeded()
    }

    //MARK: Define Custom Keyboard
    override open var inputView: UIView? {
        let keyboard = NumberKeyboard(frame: CGRect(x: 0, y: 0, width: 0, height: keyboardHeight))
        keyboard.delegate = self
        keyboard.backgroundColor = keyboardBorderColor
        for numberButton in keyboard.numberButtons {
            numberButton.backgroundColor = keyboardBackgroundColor
            numberButton.setTitleColor(keyboardTextColor, for: .normal)
        }
        keyboard.backspaceButton.backgroundColor = keyboardBackspaceColor
        keyboard.backspaceButton.setTitleColor(keyboardTextColor, for: .normal)
        keyboard.specialKeyButton.backgroundColor = keyboardDecimalPlaceColor
        keyboard.specialKeyButton.setTitleColor(keyboardTextColor, for: .normal)
        if decimalPlace == 0 {
            keyboard.specialKeyButton.setTitle(nil, for: .normal)
            keyboard.specialKeyButton.isEnabled = false
        } else {
            keyboard.specialKeyButton.setTitle(".", for: .normal)
            keyboard.specialKeyButton.isEnabled = true
        }
        return keyboard
    }
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 40)
    }
    
    //MARK: Cursor and Highlight
    // 1. Highlight all text when becomeFirstResponder
    // 2. Clear text before first edit
    var shouldOverwriteText = false {
        didSet {
            label.backgroundColor = shouldOverwriteText ? UIColor(red: 216/255, green: 234/255, blue: 249/255, alpha: 1.0) : UIColor.clear
            cursor.isHidden = !isFirstResponder || (shouldOverwriteText && !text.isEmpty)
        }
    }
    
    func overwriteTextIfNeeded() {
        if shouldOverwriteText {
            text = ""
            shouldOverwriteText = false
        }
    }
    
    //MARK: Handle FirstResponder
    override open var canBecomeFirstResponder: Bool {
        return true
    }
    
    override open func becomeFirstResponder() -> Bool {
        if super.becomeFirstResponder() {
            shouldOverwriteText = true
            delegate?.numberFieldDidBeginEditing?(self, value: value)
            return true
        } else {
            return false
        }
    }
        
    //MARK: Update value when resignFirstResponder
    override open func resignFirstResponder() -> Bool {
        if super.resignFirstResponder() {
            shouldOverwriteText = false
            value = tempVal
            delegate?.numberFieldDidEndEditing?(self, value: value)
            return true
        } else {
            return false
        }
    }
}

extension NumberField: NumberKeyboardDelegate, UITextFieldDelegate {
    
    func numberTapped(number: Int) {
        overwriteTextIfNeeded()
        // Get the pressed number
        var newText = String(number)
        
        // If origin value is not 0, or contains a ".", append the pressed number after original text
        if tempVal > 0 || text.contains(".") {
            newText = text.appending(newText)
        }
        
        // Prevent exceeding decimalPlace limit
        if let range = newText.range(of: ".") {
            let decimalCount = newText.substring(from: range.lowerBound).characters.count - 1
            if decimalCount > decimalPlace {
                delegate?.numberFieldDidReceiveWrongInput?(self)
                return
            }
        }
        
        // Prevent exceeding maxValue
        if let newValue = Double(newText) {
            if maxValue > 0 && newValue > maxValue {
                delegate?.numberFieldDidReceiveWrongInput?(self)
                return
            }
            tempVal = newValue
        }
        
        // Updat text if passed all validation
        text = newText
    }
    
    func specialKeyTapped() {
        overwriteTextIfNeeded()
        if text.isEmpty {
            text = "0"
        }
        if !text.contains(".") {
            text = text.appending(".")
        }
    }
    
    func backspaceTapped() {
        overwriteTextIfNeeded()
        text = String(text.characters.dropLast())
        if text.isEmpty {
            tempVal = 0
            return
        }
        if let newValue = Double(text) {
            tempVal = newValue
        }
    }
}
