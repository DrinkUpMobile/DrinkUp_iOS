

import UIKit


protocol InputFieldViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) 
    func inputFieldViewDidChangeSelection(_ textField: UITextField)
}

@IBDesignable
class InputFieldView: UIView {
    
    @IBInspectable
    var text: String? {
        get {
            return self.label.text
        }
        set(newText) {
            self.label.text = newText
        }
    }
    
    @IBInspectable
    var placeholder: String? {
        get {
            return self.textField.placeholder
        }
        set {
            self.textField.placeholder = newValue
        }
    }
    
    @IBInspectable
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @IBInspectable
    let textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 17, weight: .regular)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    @IBInspectable
    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    var delegate: InputFieldViewDelegate?
    
    
    private func configure() {
        
        self.textField.delegate = self
        
        self.addSubview(self.label)
        self.addSubview(self.textField)
        self.addSubview(self.underlineView)
        
        NSLayoutConstraint.activate([
            self.label.topAnchor.constraint(equalTo: self.topAnchor),
            self.label.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        
            self.textField.heightAnchor.constraint(equalToConstant: 40),
            self.textField.leftAnchor.constraint(equalTo: self.label.leftAnchor),
            self.textField.centerXAnchor.constraint(equalTo: self.label.centerXAnchor),
            self.textField.topAnchor.constraint(equalTo: self.label.bottomAnchor, constant: 8),
            
            self.underlineView.heightAnchor.constraint(equalToConstant: 1),
            self.underlineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.underlineView.leftAnchor.constraint(equalTo: self.label.leftAnchor),
            self.underlineView.centerXAnchor.constraint(equalTo: self.label.centerXAnchor),
            self.underlineView.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 0),
        ])
    }
    
}


extension InputFieldView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.label.textColor = #colorLiteral(red: 0.0932898894, green: 0.7137736678, blue: 0.9685057998, alpha: 1)
        self.label.font = .systemFont(ofSize: 14, weight: .semibold)
        self.underlineView.backgroundColor = #colorLiteral(red: 0.0932898894, green: 0.7137736678, blue: 0.9685057998, alpha: 1)
        self.delegate?.textFieldDidBeginEditing(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.label.textColor = .secondaryLabel
        self.label.font = .systemFont(ofSize: 14, weight: .regular)
        self.underlineView.backgroundColor = .separator
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.delegate?.inputFieldViewDidChangeSelection(textField)
    }
}
