//
//  ViewController.swift
//  胡强计算器
//
//  Created by 胡强 on 6/2/15.
//  Copyright (c) 2015 huqiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var stackLabel: UILabel!
    var userIsInTheMiddleOfTypingANumber = false
    
    
    @IBAction func appendHistory(sender: UIButton) {
        history.text = history.text! + sender.currentTitle!
    }
    
    /**
    append the digit
    */
    @IBAction func appendDigit(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if sender.currentTitle! == "." && display.text!.rangeOfString(".") != nil {
                return
            }
            if display.text! == "0" && sender.currentTitle! != "."{
                display.text = sender.currentTitle!
            } else {
                display.text = display.text! + sender.currentTitle!
            }
        } else {
            if sender.currentTitle! == "." {
                display.text = "0."
            } else {
                display.text = sender.currentTitle!
            }
            userIsInTheMiddleOfTypingANumber = true
        }
        
        /**
        *  change the button color when clicked
        */
        let randomRed = CGFloat(arc4random_uniform(255)) / 255
        let randomGreen = CGFloat(arc4random_uniform(255)) / 255
        let randomBlue = CGFloat(arc4random_uniform(255)) / 255
        sender.tintColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    @IBAction func appendConstant(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        displayValue = M_PI
        enter()
    }
    
    var operandStack = Array <Double>()
    /**
    put the number in the stack
    */
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let _ = displayValue {
            operandStack.append(displayValue!)
        }
        stackLabel.text = "\(operandStack)"
    }
    
    var displayValue :Double? {
        get{
            if let displayText = display.text {
                if let displayNumber = NSNumberFormatter().numberFromString(displayText) {
                    return displayNumber.doubleValue
                }
            }
            return nil
        }
        set{
            if (newValue != nil) {
                display.text = "\(newValue!)"
            } else {
                display.text = "0"
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    //× ÷ + −
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch sender.currentTitle! {
        case "×":performOperationWithTwoparams { $0 * $1 }
        case "÷":performOperationWithTwoparams { $1 / $0 }
        case "+":performOperationWithTwoparams { $0 + $1 }
        case "−":performOperationWithTwoparams { $1 - $0 }
        case "sin":performOperationWithOneparams { sin($0) }
        case "cos":performOperationWithOneparams { cos($0) }
        case "√":
            if operandStack.last < 0 && operandStack.count != 0 {
                display.text = "不能为负数求根，请重新输入"
                userIsInTheMiddleOfTypingANumber = false
            } else {
                performOperationWithOneparams(){ sqrt($0) }
            }

        default : break
        }
    }
    
    func performOperationWithTwoparams(operation:(Double,Double) -> Double) {
        if operandStack.count >= 2 {
           displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enter()
        }
    }
    
    func performOperationWithOneparams(operation:(Double) -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    @IBAction func clear() {
        display.text = "0"
        history.text = "History->"
        stackLabel.text = "Stack->"
        operandStack.removeAll(keepCapacity: false)
    }
    
    //退格
    @IBAction func backSpace(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if display.text! != "0" && (display.text! as NSString).length > 1{
                display.text = (display.text! as NSString).substringToIndex((display.text! as NSString).length - 1)
            } else if (display.text! as NSString).length == 1{
                display.text = "0"
            }
        }
        
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

