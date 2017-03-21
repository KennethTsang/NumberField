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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberField.delegate = self
        numberField.textAlignment = .left
        numberField.decimalPlace = 2
        numberField.maxValue = 9999
        
        redrawBorder()
        
        // *** Hide keyboard when tapping outside ***
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        view.addGestureRecognizer(tapGesture)
    }

    func tapGestureHandler() {
        view.endEditing(true)
    }
    
    func redrawBorder() {
        if numberField.isFirstResponder {
            numberField.layer.borderWidth = 1
            numberField.layer.borderColor = view.tintColor.cgColor
        } else {
            numberField.layer.borderWidth = 0.5
            numberField.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.5
//        animation.values = [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0 ]
        animation.values = [-9.0, 9.0, -9.0, 9.0, -4.0, 4.0, -2.0, 2.0, 0.0 ]
        numberField.layer.add(animation, forKey: "shake")
    }
}


extension ViewController: NumberFieldDelegate {
    func numberFieldDidEndEditing(_ sender: NumberField, value: Double) {
        redrawBorder()
        print(value)
    }
    
    func numberFieldDidReceiveWrongInput(_ sender: NumberField) {
        shake()
    }
    
    func numberFieldDidBeginEditing(_ sender: NumberField, value: Double) {
        redrawBorder()
        print(value)
    }
}
