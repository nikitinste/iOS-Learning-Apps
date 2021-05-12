//
//  CalculatorButton.swift
//  ex02
//
//  Created by Степан Никитин on 02.05.2021.
//  Copyright © 2021 Umana Hand. All rights reserved.
//

import UIKit

class CalculatorButton: UIButton {

    let cornerRadius = CGFloat(24)
    let digitBackgroundColor = UIColor.init(red: 52/255, green: 52/255, blue: 52/255, alpha: 1)
    let digitHighlightedColor = UIColor.darkGray
    let extraBackgroundColor = UIColor.systemGray
    let extraHighlightedColor = UIColor.lightGray
    let operationBackgroundColor = UIColor.systemOrange
    let operationHighlightedColor = UIColor.init(red: 251/255, green: 199/255, blue: 142/255, alpha: 1)
    let operationSelectedColor = UIColor.white
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.layer.cornerRadius = cornerRadius
    }
    
    func setDigitBackgroundColor() {
        self.backgroundColor = digitBackgroundColor
    }
    
    func setDigitHighlightColor() {
        self.backgroundColor = digitHighlightedColor
    }
    
    func setExtraBackgroundColor() {
        self.backgroundColor = extraBackgroundColor
    }
    
    func setExtraHighlightColor() {
        self.backgroundColor = extraHighlightedColor
    }
    
    func setOperationBackgroundColor() {
        self.backgroundColor = operationBackgroundColor
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    func setOperationHighlightedColor() {
        self.backgroundColor = operationHighlightedColor
    }
    
    func setOperationSelectedColor() {
        self.backgroundColor = operationSelectedColor
        self.setTitleColor(UIColor.systemOrange, for: .normal)
    }
    
}
