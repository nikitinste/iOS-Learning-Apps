//
//  Calculator.swift
//  ex03
//
//  Created by Umana Hand on 03.05.2021.
//  Copyright © 2021 Umana Hand. All rights reserved.
//

import Foundation

enum Operation {
    case divide
    case multyply
    case substract
    case add
    case none
}

class Calculator {
    var operand = 0
    var operation = Operation.none
    var valueString = "0"
    let screen: Displaying
    var inputStarted = false
    
    init(with screen: Displaying) {
        self.screen = screen
    }
    
    func resetValues() {
        operand = 0
        operation = .none
        valueString = "0"
        inputStarted = false
        print("Input completed")
        screen.display("0")
    }
    
    func displayError() {
        resetValues()
        screen.display("Error")
    }
    
    func setDisplayValue(with digit: String) {
        var numberString = valueString
        if inputStarted {
            numberString.append(contentsOf: digit)
        } else if digit != "0" {
            numberString = digit
            inputStarted = true
            print("Input started")
        } else {
            numberString = digit
        }
        if Int(numberString) != nil {
            valueString = numberString
            screen.display(valueString)
        }
    }
    
    func setNegative() {
        if !valueString.hasPrefix("-") {
            valueString = "-" + valueString
        } else {
            let index = valueString.index(after: valueString.startIndex)
            valueString = String(valueString[index...])
        }
        screen.display(valueString)
    }
    
    func setOperation(operation: Operation) {
        if self.operation != .none {
            guard let resultValue = result(value: Int(valueString)!) else {
                displayError()
                return
            }
            operand = resultValue
        } else {
            operand = Int(valueString)!
        }
        self.operation = operation
        inputStarted = false
        valueString = String(operand)
        screen.display(valueString)
        
        print("\(operation) button pressed")
    }
    
    func showResult() {
        guard let resultValue = result(value: Int(valueString)!) else {
            displayError()
            return
        }
        
        operand = resultValue
        inputStarted = false
        valueString = String(operand)
        screen.display(valueString)
    }
    
    func result(value: Int) -> Int? {
        var resultValue: (partialValue: Int, overflow: Bool) = (0, false)
        
        switch operation {
        case .divide:
            resultValue = operand.dividedReportingOverflow(by: value)
        case .multyply:
            resultValue = operand.multipliedReportingOverflow(by: value)
        case .substract:
            resultValue = operand.subtractingReportingOverflow(value)
        case .add:
            resultValue = operand.addingReportingOverflow(value)
        case .none:
            ()
        }
        
        operation = .none
        if resultValue.overflow {
            return nil
        }
        return resultValue.partialValue
    }
}
