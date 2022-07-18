//
//  MixedFraction.swift
//  QuestChallenge
//
//  Created by Alejandro Giron on 7/6/22.
//

import Foundation

struct Fraction {

    var numerator: Int
    var denominator: Int
    
    // MARK: - Initializers
    
    init() {
        self.numerator = 0
        self.denominator = 1
    }
    
    init(numerator: Int, denominator: Int) {
        self.numerator = numerator
        
        // handle denominators if 0 is passed.
        if denominator == 0 {
            self.denominator = 1
        } else {
            self.denominator = denominator
        }
    }
    
    // MARK: - Class Functions
    
    ///  Returns the fraction inverted.
    ///  - Returns: Inverted Fraction. Ex: 3/2 -> 2/3
    func getInvertedFraction() -> Fraction {
        return Fraction(numerator: self.denominator, denominator: self.numerator)
    }
    
    /// Simplify the fraction. Ex: 6/12 = 1/2
    mutating func simplify(){
        var numerator = self.numerator
        var denominator = self.denominator
        while denominator != 0 {
            let buffer = denominator
            denominator = numerator % denominator
            numerator = buffer
        }
        self.numerator = self.numerator/numerator
        self.denominator = self.denominator/numerator
    }
    
    /// Adds two fractions with the same denominators.
    static func addTwoFractionsWithCommonDenominators(fraction1: Fraction, fraction2: Fraction) -> Fraction {
        let numerator = fraction1.numerator + fraction2.numerator
        let denominator = fraction2.denominator
        var resultFraction = Fraction(numerator: numerator, denominator: denominator)
        resultFraction.simplify()
        return resultFraction
    }
    
    /// Get the fraction as a String. Ex: 1/2
    ///  - Returns: The values of Fraction as a String
    func getFractionString() -> String {
        return "\(self.numerator)/\(self.denominator)"
    }
    
    /// Get the fraction as a MixedFraction.
    ///  - Returns: the fraction as a MixedFraction object.
    func getAsMixedFraction() -> MixedFraction {
        if numerator < denominator {
            if numerator < 0 {
                let wholeNumber = numerator / denominator
                let newNumerator = numerator % denominator
                return MixedFraction(wholeNumber: wholeNumber, numerator: newNumerator, denominator: self.denominator)
            }
            return MixedFraction(wholeNumber: 0, numerator: numerator, denominator: denominator)
        }
        let wholeNumber = numerator / denominator
        let newNumerator = numerator % denominator
        return MixedFraction(wholeNumber: wholeNumber, numerator: newNumerator, denominator: self.denominator)
    }
}

struct MixedFraction {
    
    var wholeNumber: Int
    var fraction: Fraction
    
    // MARK: - Initializers
    
    init() {
        self.wholeNumber = 0
        self.fraction = Fraction(numerator: 0, denominator: 1)
    }
    
    init(wholeNumber: Int){
        self.wholeNumber = wholeNumber
        self.fraction = Fraction(numerator: 0, denominator: 1)
    }
    
    init(wholeNumber: Int, numerator: Int, denominator: Int){
        self.wholeNumber = wholeNumber
        self.fraction = Fraction(numerator: numerator, denominator: denominator)
        self.fraction.simplify()
    }
    
    init(string: String) {
        let mixedFraction = MixedFraction.convertStringToMixedFraction(text: string)
        self.wholeNumber = mixedFraction.wholeNumber
        self.fraction = mixedFraction.fraction
    }
    
    // MARK: - Functions
    
    /// Get the fraction as a String. Ex: 4&1/2.
    /// If the whole number == 0, it will not include it in the string. Ex: 1/2
    ///  - Returns: The values of the Mixed Fraction as a String
    mutating func getString() -> String {
        self.fraction.simplify()
        
        var fractionString = ""
        if self.wholeNumber != 0 {
            fractionString += "\(self.wholeNumber)"
        }
        
        if self.fraction.numerator != 0 {
            let amperSand = self.wholeNumber == 0 ? "" : "&"
            fractionString += "\(amperSand)\(self.fraction.numerator)/\(self.fraction.denominator)"
        }
        
        return fractionString == "" ? "0" : fractionString
        
    }
    
    /// Get the Mixed Fraction as a Fraction
    ///  - Returns: The values of MixedFraction as a Fraction
    func getAsFraction() -> Fraction {
        let newNumerator = self.wholeNumber * self.fraction.denominator + self.fraction.numerator
        return Fraction(numerator: newNumerator, denominator: self.fraction.denominator)
    }
    
    /// Get a MixedFraction object from a given text. Ex: 2&1/3, 3/4, 11
    /// - Returns: MixedFraction object
    static func convertStringToMixedFraction(text: String) -> MixedFraction {
        
        // remove whitespaces
        let updatedText = text.replacingOccurrences(of: " ", with: "")
    
        if updatedText.contains("&") { //it's a mixed fraction
            
            let line = updatedText.components(separatedBy: "&")
            if line.count == 2 {
                let wholeNumberString = line[0]
                let line2 = line[1].components(separatedBy: "/")
                if line2.count == 2 {
                    if let wholeNumber = Int(wholeNumberString),
                        let numerator = Int(line2[0]),
                        let denominator = Int(line2[1]) {
                        return MixedFraction(wholeNumber: wholeNumber, numerator: numerator, denominator: denominator)
                    }
                }
            }
            
        } else if updatedText.contains("/") { //if it's a fraction
            
            // split into components, numerator on left, denominator on right
            let line = updatedText.components(separatedBy: "/")
            if line.count == 2 {
                if let numerator = Int(line[0]),
                    let denominator = Int(line[1]) {
                    return MixedFraction(wholeNumber: 0, numerator: numerator, denominator: denominator)
                }
            }
        } else { // just a whole number
            if let wholeNum = Int(text) {
                return MixedFraction(wholeNumber: wholeNum)
            }
        }
        return MixedFraction()
    }
    
    /// Get a MixedFraction object from a given text. Ex: 2&1/3, 3/4, 11
    ///  - Parameter leftMixedFraction: Left Mixed Fraction of Operation.
    ///  - Parameter operatorSymbol: Symbol for operation. Values can be "+", "-", "*", "/", "%"
    ///  - Parameter rightMixedFraction: Right Mixed Fraction of Operation.
    ///  - Returns: MixedFraction object after the operation has been performed. If the operator symbol is not "+", "-", "*", "/", or "%", a new MixedFraction object will be returned.
    static func getResultFromMathOperation(leftOperand: MixedFraction, operatorSymbol: String, rightOperand: MixedFraction) -> MixedFraction {
        switch operatorSymbol {
        case "+":
            return leftOperand + rightOperand
        case "-":
            return leftOperand - rightOperand
        case "*":
            return leftOperand * rightOperand
        case "/":
            return leftOperand / rightOperand
        case "%":
            return leftOperand % rightOperand
        default:
            return MixedFraction()
        }
    }
    
    // MARK: - Operator Overloads
    
    static func + (left: MixedFraction, right: MixedFraction) -> MixedFraction {
        
        // Get both sides as improper fractions
        let leftImproperFraction = left.getAsFraction()
        let rightImproperFraction = right.getAsFraction()
        
        // Formula: a/b + c/d = [(a*d) + (c*b)] / (b*d)
        let resultsNumerator = (leftImproperFraction.numerator * rightImproperFraction.denominator) + (rightImproperFraction.numerator * leftImproperFraction.denominator)
        let resultsDenominator = leftImproperFraction.denominator * rightImproperFraction.denominator
        
        return Fraction(numerator: resultsNumerator, denominator: resultsDenominator).getAsMixedFraction()
    }
    
    static func - (left: MixedFraction, right: MixedFraction) -> MixedFraction {
        
        // Get both sides as improper fractions
        let leftImproperFraction = left.getAsFraction()
        let rightImproperFraction = right.getAsFraction()
        
        // Formula: a/b - c/d = [(a*d) - (c*b)] / (b*d)
        let resultsNumerator = (leftImproperFraction.numerator * rightImproperFraction.denominator) - (rightImproperFraction.numerator * leftImproperFraction.denominator)
        let resultsDenominator = leftImproperFraction.denominator * rightImproperFraction.denominator
        
        return Fraction(numerator: resultsNumerator, denominator: resultsDenominator).getAsMixedFraction()
    }
    
    static func * (left: MixedFraction, right: MixedFraction) -> MixedFraction {
        
        // Get improper fractions
        let leftImproperFraction = left.getAsFraction()
        let rightImproperFraction = right.getAsFraction()
        
        // Formula: a/b * c/d = (a*c) / (b*d)
        let resultNumerator = leftImproperFraction.numerator * rightImproperFraction.numerator
        let resultDenominator = leftImproperFraction.denominator * rightImproperFraction.denominator
        
        return Fraction(numerator: resultNumerator, denominator: resultDenominator).getAsMixedFraction()
    }
    
    static func / (left: MixedFraction, right: MixedFraction) -> MixedFraction {
        
        // check if right operand == 0, print error, and return a new MixedFraction object
        if right == 0 {
            print("Error: Right operand is zero. Right operand must be non-zero.")
            return MixedFraction()
        }
        
        // Formula: a/b / c/d = a/b * d/c = (a*d) / (b*c)
        let leftImproperFraction = left.getAsFraction()
        let rightImproperFraction = right.getAsFraction().getInvertedFraction()
        let resultNumerator = leftImproperFraction.numerator * rightImproperFraction.numerator
        let resultDenominator = leftImproperFraction.denominator * rightImproperFraction.denominator
        
        return Fraction(numerator: resultNumerator, denominator: resultDenominator).getAsMixedFraction()
    }
    
    static func % (left: MixedFraction, right: MixedFraction) -> MixedFraction {
        
        // Get the whole number after division, multiply it to right operand, and subtract it from the left operand
        let quotientWholeNumber = (left / right).wholeNumber
        let quotientAsFraction = MixedFraction(wholeNumber: quotientWholeNumber)
        return left - (quotientAsFraction * right)
    }
    
    static func < (left: MixedFraction, right: MixedFraction) -> Bool {
        
        // convert to double, and compare
        let leftDouble = (Double(left.fraction.numerator)/Double(left.fraction.denominator)) + Double(left.wholeNumber)
        let rightDouble = (Double(right.fraction.numerator)/Double(right.fraction.denominator)) + Double(right.wholeNumber)
        return leftDouble < rightDouble
    }
    
    static func > (left: MixedFraction, right: MixedFraction) -> Bool {
        
        // convert to double, and compare
        let leftDouble = (Double(left.fraction.numerator)/Double(left.fraction.denominator)) + Double(left.wholeNumber)
        let rightDouble = (Double(right.fraction.numerator)/Double(right.fraction.denominator)) + Double(right.wholeNumber)
        return leftDouble > rightDouble
    }
    
    static func == (left: MixedFraction, right: MixedFraction) -> Bool {
        
        // Compare each property
        return left.wholeNumber == right.wholeNumber && left.fraction.numerator == right.fraction.numerator && left.fraction.denominator == right.fraction.denominator
    }
    
    static func == (left: MixedFraction, right: Int) -> Bool {
        
        // Consider the Int as a whole number in a mixed fraction.
        let mixedFractionFromInt = MixedFraction(wholeNumber: right, numerator: 0, denominator: 1)
        return mixedFractionFromInt == left
    }
    
    static func <= (left: MixedFraction, right: MixedFraction) -> Bool {
        return left < right || left == right
    }
    
    static func >= (left: MixedFraction, right: MixedFraction) -> Bool {
        return left > right || left == right
    }
    
}
