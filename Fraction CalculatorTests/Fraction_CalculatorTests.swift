//
//  Fraction_CalculatorTests.swift
//  Fraction CalculatorTests
//
//  Created by Alejandro Giron on 7/15/22.
//

import XCTest
@testable import Fraction_Calculator

class Fraction_CalculatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOperations() throws {
        let leftOperand = MixedFraction(wholeNumber: 10)
        let rightOperand = MixedFraction(wholeNumber: 2, numerator: 1, denominator: 2)
        
        var additionResult = MixedFraction.getResultFromMathOperation(leftOperand: leftOperand, operatorSymbol: "+", rightOperand: rightOperand)
        var subtractionResult = MixedFraction.getResultFromMathOperation(leftOperand: leftOperand, operatorSymbol: "-", rightOperand: rightOperand)
        var multiplicationResult = MixedFraction.getResultFromMathOperation(leftOperand: leftOperand, operatorSymbol: "*", rightOperand: rightOperand)
        var divisionResult = MixedFraction.getResultFromMathOperation(leftOperand: leftOperand, operatorSymbol: "/", rightOperand: rightOperand)
        var moduloResult = MixedFraction.getResultFromMathOperation(leftOperand: leftOperand, operatorSymbol: "%", rightOperand: rightOperand)
        
        XCTAssert(additionResult.getString() == "12&1/2", "additionResult \(additionResult.getString()) does not equal expected \"12&1/2\".")
        XCTAssert(subtractionResult.getString() == "7&1/2", "subtractionResult \(subtractionResult.getString()) does not equal expected \"7&1/2\".")
        XCTAssert(multiplicationResult.getString() == "25", "multiplicationResult \(multiplicationResult.getString()) does not equal expected \"25\".")
        XCTAssert(divisionResult.getString() == "4", "divisionResult \(divisionResult.getString()) does not equal expected \"4\".")
        XCTAssert(moduloResult.getString() == "0", "moduloResult \(moduloResult.getString()) does not equal expected \"0\".")
    }

}
