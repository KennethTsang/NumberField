//
//  ViewController.swift
//  NumberField
//
//  Created by kenthth@gmail.com on 03/20/2017.
//  Copyright (c) 2017 kenthth@gmail.com. All rights reserved.
//

import UIKit
import NumberField

class ViewController: UIViewController {

    @IBOutlet weak var numberField1: NumberField!
    @IBOutlet weak var numberField2: NumberField!
    @IBOutlet weak var numberField3: NumberField!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupField1()
        setupField2()
        setupField3()
        
        // Hide keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupField1() {
        //Customization
        numberField1.value = 0
        numberField1.maxValue = 99999.99
        numberField1.decimalPlace = 2
        numberField1.valueLabel.font = UIFont.systemFont(ofSize: 20)
        
        //Prefix and Suffix
        numberField1.prefixLabel.text = "LENGTH"
        numberField1.suffixLabel.text = "cm"
        numberField1.textAlignment = .right
        numberField1.isPrefixAndSuffixStickToSides = true
        numberField1.prefixLabel.font = UIFont.boldSystemFont(ofSize: 16)
        numberField1.suffixLabel.font = UIFont.boldSystemFont(ofSize: 16)
        numberField1.prefixLabel.textColor = UIColor.gray
        numberField1.suffixLabel.textColor = UIColor.gray
        
        //Add Border
        numberField1.layer.borderWidth = 0.5
        numberField1.layer.borderColor = UIColor.lightGray.cgColor
        numberField1.layer.cornerRadius = 4
        
        //Listen to NumberField Events
        numberField1.addTarget(self, action: #selector(numberFieldEditingDidBegin), for: .editingDidBegin)
        numberField1.addTarget(self, action: #selector(numberFieldEditingDidEnd), for: .editingDidEnd)
        numberField1.addTarget(self, action: #selector(numberFieldEditingChanged), for: .editingChanged)
        numberField1.addTarget(self, action: #selector(numberFieldEditingRejected), for: .editingRejected)
    }

    func setupField2() {
        //Customization
        numberField2.value = 0
        numberField2.maxValue = 1000
        numberField2.decimalPlace = 0
        numberField2.valueLabel.font = UIFont.systemFont(ofSize: 20)
        
        //Prefix and Suffix
        numberField2.suffixLabel.text = "pcs"
        numberField2.prefixLabel.text = "QUANTITY"
        numberField2.textAlignment = .left
        numberField2.isPrefixAndSuffixStickToSides = false
        numberField2.prefixLabel.font = UIFont.boldSystemFont(ofSize: 16)
        numberField2.suffixLabel.font = UIFont.boldSystemFont(ofSize: 16)
        numberField2.prefixLabel.textColor = UIColor.gray
        numberField2.suffixLabel.textColor = UIColor.gray
        
        //Add Border
        numberField2.layer.borderWidth = 0.5
        numberField2.layer.borderColor = UIColor.lightGray.cgColor
        numberField2.layer.cornerRadius = 4
        
        //Listen to NumberField Events
        numberField2.addTarget(self, action: #selector(numberFieldEditingDidBegin), for: .editingDidBegin)
        numberField2.addTarget(self, action: #selector(numberFieldEditingDidEnd), for: .editingDidEnd)
        numberField2.addTarget(self, action: #selector(numberFieldEditingChanged), for: .editingChanged)
        numberField2.addTarget(self, action: #selector(numberFieldEditingRejected), for: .editingRejected)
    }

    func setupField3() {
        //Customization
        numberField3.value = 0
        numberField3.maxValue = 99999.99
        numberField3.decimalPlace = 2
        numberField3.valueLabel.font = UIFont.systemFont(ofSize: 20)
        
        //Prefix and Suffix
        numberField3.prefixLabel.text = "HKD"
        numberField3.textAlignment = .right
        numberField3.prefixLabel.font = UIFont.boldSystemFont(ofSize: 16)
        numberField3.suffixLabel.font = UIFont.boldSystemFont(ofSize: 16)
        numberField3.prefixLabel.textColor = UIColor.gray
        numberField3.suffixLabel.textColor = UIColor.gray
        
        //Add Border
        numberField3.layer.borderWidth = 0.5
        numberField3.layer.borderColor = UIColor.lightGray.cgColor
        numberField3.layer.cornerRadius = 4
        
        //Listen to NumberField Events
        numberField3.addTarget(self, action: #selector(numberFieldEditingDidBegin), for: .editingDidBegin)
        numberField3.addTarget(self, action: #selector(numberFieldEditingDidEnd), for: .editingDidEnd)
        numberField3.addTarget(self, action: #selector(numberFieldEditingChanged), for: .editingChanged)
        numberField3.addTarget(self, action: #selector(numberFieldEditingRejected), for: .editingRejected)
    }

    @objc func tapGestureHandler() {
        view.endEditing(true)
    }
    
    //Listen to NumberField Events
    @objc func numberFieldEditingDidBegin(numberField: NumberField) {
        //Called when editing did begin
        warningLabel.isHidden = true
    }
    @objc func numberFieldEditingDidEnd(numberField: NumberField) {
        //Called when editing did end
        warningLabel.isHidden = true
    }
    @objc func numberFieldEditingChanged(numberField: NumberField) {
        //Called when value changed on editing
        warningLabel.isHidden = true
    }
    @objc func numberFieldEditingRejected(numberField: NumberField) {
        //Called when input rejected. i.e. Value exceeded maximum value.
        warningLabel.isHidden = false
    }
}
