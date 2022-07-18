import UIKit
import CoreGraphics

class CalculatorViewController: UIViewController {

    let errorMessage = "Please enter an operation in the following format: (operand) (operator) (operand). IE: 2&1/3 + 4"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Fraction Calculator"
        label.backgroundColor = .white
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont(name: "Verdana", size: view.frame.height/40)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = """
        Instructions:
        *Legal operators: *,/,+,-,% (multiply, divide, add, subtract, modulo).
        *Operands and operators to be separated by one or more spaces.
        *Mixed numbers are represented by whole&numerator/denominator (for example, "3&1/4", “-1&7/8”).
        *Improper fractions, whole numbers, & negative numbers are allowed as operands.
        *Example Operation String: 1/2 * 3&3/4
        """
        textView.backgroundColor = .white
        textView.textColor = .lightGray
        textView.textAlignment = .left
        textView.font = UIFont(name: "Verdana", size: 12)
        textView.sizeToFit()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var operationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Operation String (Example: 1/2 * 3&3/4)"
        textField.textColor = .black
        textField.keyboardType = .numbersAndPunctuation
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var calculateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Calculate", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(calculateOperation), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        setUpOperationLabel()
        setUpDescriptionTextView()
        setUpOperationTextField()
        setUpCalculateButton()
    }
    
    private func setUpOperationLabel(){
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor, constant: 8),
            titleLabel.heightAnchor.constraint(equalToConstant: view.frame.height/20),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/20),
            titleLabel.leftAnchor.constraint(equalTo: view.readableContentGuide.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: view.readableContentGuide.rightAnchor)
        ])
    }
    
    private func setUpDescriptionTextView(){
        view.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            descriptionTextView.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor, constant: 8),
            descriptionTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionTextView.leftAnchor.constraint(equalTo: view.readableContentGuide.leftAnchor),
            descriptionTextView.rightAnchor.constraint(equalTo: view.readableContentGuide.rightAnchor)
        ])
    }
    
    private func setUpOperationTextField(){
        view.addSubview(operationTextField)
        NSLayoutConstraint.activate([
            operationTextField.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor, constant: 8),
            operationTextField.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8),
            operationTextField.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor)
        ])
    }
    
    private func setUpCalculateButton(){
        view.addSubview(calculateButton)
        NSLayoutConstraint.activate([
            calculateButton.widthAnchor.constraint(equalToConstant: 200),
            calculateButton.heightAnchor.constraint(equalToConstant: 40),
            calculateButton.topAnchor.constraint(equalTo: operationTextField.bottomAnchor, constant: 8),
            calculateButton.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor)
        ])
    }
    
    private func showResultsAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Got it!", style: .default) { _ in
            self.operationTextField.text?.removeAll()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    @objc
    func calculateOperation() {
            
        // get each operand and operators as [String]
        let components = operationTextField.text?.split(separator: " ", omittingEmptySubsequences: true)
        if let components = components {
            
            // check if there are two operands, and one operator.
            if components.count == 3 {
                
                // get operator and operands
                let userOperator = String(components[1])
                var leftOperand = MixedFraction(string: String(components[0]))
                var rightOperand = MixedFraction(string: String(components[2]))
                var result = MixedFraction.getResultFromMathOperation(leftOperand: leftOperand,operatorSymbol: userOperator,rightOperand: rightOperand)
                
                // present result
                showResultsAlert(title: "Results", message: "\(rightOperand.getString()) \(userOperator) \(leftOperand.getString()) = \(result.getString())")
                
            } else {
                // present error
                showResultsAlert(title: "Error", message: errorMessage)
            }
        }
    }
}
