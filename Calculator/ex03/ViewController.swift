//
//  ViewController.swift
//  ex02
//
//  Created by Umana Hand on 4/30/21.
//  Copyright © 2021 Umana Hand. All rights reserved.
//

import UIKit

class ViewController: UIViewController, Displaying {
    
    var calculator: Calculator?
    var selectedOperationButton: CalculatorButton?
    
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculator = Calculator(with: self)
    }
    
    // MARK: - Actions
    
    @IBAction func digitButtonPressed(_ sender: CalculatorButton) {
        let digit = sender.titleLabel?.text ?? "None"
        print("Yeah \(digit) pressed!")
        
        calculator!.setDisplayValue(with: digit)
        sender.setDigitBackgroundColor()
    }
    
    @IBAction func extraButtonPressed(_ sender: CalculatorButton) {
        switch sender.accessibilityIdentifier {
        case "cleanButton":
            calculator!.resetValues()
            if let selectedButton = selectedOperationButton {
                selectedButton.setOperationBackgroundColor()
                selectedOperationButton = nil
            }
        case "negativeButton":
            calculator!.setNegative()
        default:
            print("ololosh extra button pressed")
        }
        sender.setExtraBackgroundColor()
    }
    
    @IBAction func operationButtonPressed(_ sender: CalculatorButton) {
        if sender.accessibilityIdentifier == "resultButton" {
            calculator!.showResult()
            sender.setOperationBackgroundColor()
            if let selectedButton = selectedOperationButton {
                selectedButton.setOperationBackgroundColor()
                selectedOperationButton = nil
            }
            return
        }
        switch sender.accessibilityIdentifier {
        case "divisionButton":
            calculator!.setOperation(operation: .divide)
        case "multiplyButton":
            calculator!.setOperation(operation: .multyply)
        case "minusButton":
            calculator!.setOperation(operation: .substract)
        case "plusButton":
            calculator!.setOperation(operation: .add)
        default:
            print("ololosh operation button pressed")
        }
        sender.setOperationSelectedColor()
        if let selectedButton = selectedOperationButton {
            selectedButton.setOperationBackgroundColor()
        }
        selectedOperationButton = sender
    }
    
    
    @IBAction func digitButtonHeld(_ sender: CalculatorButton) {
        sender.setDigitHighlightColor()
    }
    
    @IBAction func extraButtonHeld(_ sender: CalculatorButton) {
        sender.setExtraHighlightColor()
    }
    
    @IBAction func operationButtonHeld(_ sender: CalculatorButton) {
        sender.setOperationHighlightedColor()
    }
    
    
    // MARK: - Displaying

    func display(_ valueString: String) {
        label.text = valueString
    }
}

