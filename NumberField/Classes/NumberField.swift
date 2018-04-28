//
//  NumberField.swift
//  Pods
//
//  Created by Tsang Kenneth on 20/3/2017.
//
//

import UIKit

@objc public enum NumberFieldAlignment: Int {
    case left
    case right
}

@objc open class NumberField: UIControl {
    //MARK: UI Components
    public let valueLabel = UILabel()
    public let prefixLabel = UILabel()
    public let suffixLabel = UILabel()
    private let cursor = FakeCursor()
    private var stackView = UIStackView()

    //MARK: Keyboard Customization
    @IBInspectable public var keyboardHeight: CGFloat = 260
    @IBInspectable public var keyboardBorderColor: UIColor = UIColor.lightGray
    @IBInspectable public var keyboardTextColor: UIColor = UIColor.darkText
    @IBInspectable public var keyboardBackgroundColor: UIColor = UIColor(white: 0.99, alpha: 1.0)
    @IBInspectable public var keyboardDecimalPlaceColor: UIColor = UIColor(white: 0.99, alpha: 1.0)
    @IBInspectable public var keyboardBackspaceColor: UIColor = UIColor(white: 0.90, alpha: 1.0)
    
    //MARK: NumberField Customization
    @IBInspectable public var decimalPlace: Int = 0 {
        didSet { formatValue() }
    }
    
    @IBInspectable public var maxValue: Double = Double(0)
    
    @IBInspectable public var value: Double = Double(0) {
        didSet {
            if isFirstResponder {
                sendActions(for: [.editingChanged])
            } else {
                formatValue()
            }
        }
    }
    
    @IBInspectable public var textAlignment = NumberFieldAlignment.right {
        didSet { delayedRedrawSubviews() }
    }
    
    @IBInspectable public var highlightedColor: UIColor = UIColor(red: 216/255, green: 234/255, blue: 249/255, alpha: 1.0)
    
    //MARK: Private Varibles
    private var timer: Timer?
    fileprivate var text: String {
        get { return valueLabel.text ?? "" }
        set { valueLabel.text = newValue }
    }
    
    
    //MARK: Prefix / Suffix
    public var isPrefixAndSuffixStickToSides: Bool = true {
        didSet { delayedRedrawSubviews() }
    }

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
        prefixLabel.textAlignment = .left
        suffixLabel.textAlignment = .right
        delayedRedrawSubviews()
        // Become first responder when tapped
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder))
        addGestureRecognizer(tapGesture)
    }
    
    private func delayedRedrawSubviews() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(redrawSubviews), userInfo: nil, repeats: false)
    }
    
    @objc func redrawSubviews() {
        stackView.removeFromSuperview()
        cursor.removeFromSuperview()

        stackView = UIStackView(arrangedSubviews: [prefixLabel, valueLabel, suffixLabel])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4

        addSubview(stackView)
        addSubview(cursor)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        cursor.translatesAutoresizingMaskIntoConstraints = false
        
        // Always compress the value label if no enough space
        valueLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        prefixLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        suffixLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        valueLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        if textAlignment == .left {
            prefixLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
            suffixLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        } else {
            prefixLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
            suffixLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        }
        
        var vfl = ""
        if isPrefixAndSuffixStickToSides {
            vfl = "H:|-5-[stackView]-5-|"
        } else {
            if textAlignment == .left {
                vfl = "H:|-5-[stackView]-(>=5)-|"
            } else {
                vfl = "H:|-(>=5)-[stackView]-5-|"
            }
        }
        
        let views:[String: Any] = ["stackView": stackView]
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: vfl, options: [], metrics: nil, views: views)
        let yConstraint = NSLayoutConstraint(item: stackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let cursorXConstraint = NSLayoutConstraint(item: cursor, attribute: .left, relatedBy: .equal, toItem: valueLabel, attribute: .right, multiplier: 1, constant: 0)
        let cursorYConstraint = NSLayoutConstraint(item: cursor, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let cursorHeightConstraint = NSLayoutConstraint(item: cursor, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.7, constant: 0)
        
        addConstraints(hConstraints)
        addConstraint(yConstraint)
        addConstraint(cursorXConstraint)
        addConstraint(cursorYConstraint)
        addConstraint(cursorHeightConstraint)
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
        return CGSize(width: UIViewNoIntrinsicMetric, height: 30)
    }
    
    //MARK: Cursor and Highlight
    // 1. Highlight all text when becomeFirstResponder
    // 2. Clear text before first edit
    private var shouldOverwriteText = false {
        didSet {
            valueLabel.backgroundColor = shouldOverwriteText ? highlightedColor : UIColor.clear
            cursor.isHidden = !isFirstResponder || (shouldOverwriteText && !text.isEmpty)
        }
    }
    
    fileprivate func overwriteTextIfNeeded() {
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
            sendActions(for: [.editingDidBegin])
            return true
        } else {
            return false
        }
    }
        
    //MARK: Update value when resignFirstResponder
    override open func resignFirstResponder() -> Bool {
        if super.resignFirstResponder() {
            shouldOverwriteText = false
            formatValue()
            sendActions(for: [.editingDidEnd])
            return true
        } else {
            return false
        }
    }
    
    private func formatValue() {
        text = String(format: "%.\(decimalPlace)f",value)
    }
}

extension NumberField: NumberKeyboardDelegate {
    
    func numberTapped(number: Int) {
        overwriteTextIfNeeded()
        // Get the pressed number
        var newText = String(number)
        
        // If origin value is not 0, or contains a ".", append the pressed number after original text
        if value > 0 || text.contains(".") {
            newText = text.appending(newText)
        }
        
        // Prevent exceeding decimalPlace limit
        if let range = newText.range(of: ".") {
            let decimalCount = newText.suffix(from: range.upperBound).count
            if decimalCount > decimalPlace {
                sendActions(for: [.editingRejected])
                return
            }
        }
        
        // Prevent exceeding maxValue
        if let newValue = Double(newText) {
            if maxValue > 0 && newValue > maxValue {
                sendActions(for: [.editingRejected])
                return
            }
            value = newValue
        }
        // Update value and text if passed all validation
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
        text = String(text.dropLast())
        value = Double(text) ?? 0
    }
}
