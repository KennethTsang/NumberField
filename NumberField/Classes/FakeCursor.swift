//
//  NumberFieldCursor.swift
//  Pods
//
//  Created by Tsang Kenneth on 20/3/2017.
//
//

import UIKit

final class FakeCursor: UIView {
    var timer: Timer?
    
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 2, height: UIViewNoIntrinsicMetric)
    }
    
    override var isHidden: Bool {
        didSet {
            if isHidden {
                timer?.invalidate()
            } else {
                if (timer?.isValid ?? false) == false {
                    alpha = 1
                    timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(flash), userInfo: nil, repeats: true)
                }
            }
        }
    }
    
    @objc func flash(timer: Timer) {
        self.alpha = self.alpha > 0 ? 0 : 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = tintColor
    }
}
