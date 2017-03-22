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

    @IBOutlet weak var numberField: NumberField!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Customization
        numberField.value = 0
        numberField.textAlignment = .right
        numberField.maxValue = 9999.99
        numberField.decimalPlace = 2
        numberField.font = UIFont.systemFont(ofSize: 20)
        
        numberField.layer.borderWidth = 0.5
        numberField.layer.borderColor = UIColor.lightGray.cgColor
        numberField.layer.cornerRadius = 4
        
        //Listen to NumberField Events
        numberField.addTarget(self, action: #selector(numberFieldEditingDidBegin), for: .editingDidBegin)
        numberField.addTarget(self, action: #selector(numberFieldEditingDidEnd), for: .editingDidEnd)
        numberField.addTarget(self, action: #selector(numberFieldEditingChanged), for: .editingChanged)
        numberField.addTarget(self, action: #selector(numberFieldEditingRejected), for: .editingRejected)
        
        // Hide keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
    }

    func tapGestureHandler() {
        view.endEditing(true)
    }
    
    //Listen to NumberField Events
    func numberFieldEditingDidBegin(numberField: NumberField) {
        //Called when editing did begin
        warningLabel.isHidden = true
    }
    func numberFieldEditingDidEnd(numberField: NumberField) {
        //Called when editing did end
        warningLabel.isHidden = true
    }
    func numberFieldEditingChanged(numberField: NumberField) {
        //Called when value changed on editing
        warningLabel.isHidden = true
    }
    func numberFieldEditingRejected(numberField: NumberField) {
        //Called when input rejected. i.e. Value exceeded maximum value.
        warningLabel.isHidden = false
    }
}
