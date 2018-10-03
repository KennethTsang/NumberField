//
//  UIControlEventsExtension.swift
//  Pods
//
//  Created by Tsang Kenneth on 22/3/2017.
//
//

import UIKit

extension UIControl.Event {
    public static var editingRejected: UIControl.Event { return UIControl.Event(rawValue: 0b0001 << 24) }
}
