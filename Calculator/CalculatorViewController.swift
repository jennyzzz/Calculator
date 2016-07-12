//
//  ViewController.swift
//  Calculator
//
//  Created by Zhenzheng Zhu on 5/25/16.
//  Copyright © 2016 Zhenzheng Zhu. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    @IBOutlet weak private var display: UILabel!
    
    private var userIsTyping = false
    
    private var calculatorCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorCounter += 1
        print("Loaded up a new Calculator (count = \(calculatorCounter))")
        brain.addUnaryOperation("red√", operation: { [weak weakSelf = self] in
            weakSelf?.display.textColor = UIColor.redColor()
            return sqrt($0)
        })
    }
    
    deinit{
        calculatorCounter -= 1
        print ("Calculator left the heap (count = \(calculatorCounter))")
    }
    

    @IBAction private func number(sender: UIButton) {
        let digitNumber = sender.currentTitle!
        
        if userIsTyping {
            let displayCurrentlyString = display.text!
            if displayCurrentlyString != "0" {
                display.text = displayCurrentlyString + digitNumber
            } else {
                display.text = digitNumber
            }
        } else {
            display.text = digitNumber
        }
        userIsTyping = true
    }

    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsTyping{
            brain.setOperand(displayValue)
            userIsTyping = false
        }
        
        if let displayString = sender.currentTitle {
            brain.performOperation(displayString)
        }
        displayValue = brain.result
    }
    
    private var savedProgram : CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction func clear() {
        brain.clear()
        displayValue = brain.result
        userIsTyping = false
    }
}

