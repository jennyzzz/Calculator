//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Zhenzheng Zhu on 6/3/16.
//  Copyright © 2016 Zhenzheng Zhu. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var accumulator = 0.0
    
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand : Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    func addUnaryOperation(symbol: String, operation: (Double) -> Double) {
        operations[symbol] = Operation.UnaryOperation(operation)
    }
    
    var operations : Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "=" : Operation.Equal
    ]
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equal
        
    }
    
    func performOperation(symbol : String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value) :
                accumulator = value
            case.UnaryOperation(let function) :
                accumulator = function(accumulator)
            case.BinaryOperation(let function) :
                executePendingBinaryOperation()
                pending = pendingBinaryOperationInfo(binaryFunction: function, firstOperand : accumulator)
            case .Equal :
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator =  pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }

    }
    
    typealias PropertyList = AnyObject
    
    var program : PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOp = newValue as? [AnyObject] {
                for op in arrayOfOp {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
            
        }
    }
    
    func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    private var pending : pendingBinaryOperationInfo?
    
    struct pendingBinaryOperationInfo {
        var binaryFunction : (Double, Double) -> Double
        var firstOperand : Double
    }
    
    var result : Double {
        get {
            return accumulator
        }
    }
}