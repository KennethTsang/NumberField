//
//  NumberKeyboard.swift
//  mos
//
//  Created by Kenneth on 8/12/2016.
//  Copyright © 2016 HCG. All rights reserved.
//

import UIKit

protocol NumberKeyboardDelegate: class {
    func numberTapped(number: Int)
    func specialKeyTapped()
    func backspaceTapped()
}

class NumberKeyboard: UIView {
    weak var delegate: NumberKeyboardDelegate?
    @IBOutlet weak var specialKeyButton: UIButton!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var backspaceButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: NumberKeyboard.classForCoder())
        let view = bundle.loadNibNamed("NumberKeyboard", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
    
    // MARK: Actions
    @IBAction func keyTapped(sender: UIButton) {
        self.delegate?.numberTapped(number: Int(sender.titleLabel!.text!)!)
    }
    
    @IBAction func specialKeyTapped(sender: UIButton) {
        self.delegate?.specialKeyTapped()
    }
    
    @IBAction func backspace(sender: UIButton) {
        self.delegate?.backspaceTapped()
    }
    
}
