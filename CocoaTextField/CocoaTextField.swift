//
//  CocoaTextField.swift
//  CocoaTextField
//
//  Created by Edgar Žigis on 10/10/2019.
//  Copyright © 2019 Edgar Žigis. All rights reserved.
//

import UIKit

@IBDesignable
public class CocoaTextField: UITextField {
    
    //  MARK: - Open variables -
    
    /**
     * Sets hint color for not focused state
     */
    @IBInspectable
    open var inactiveHintColor: UIColor = .gray {
        didSet {
            self.configureHint()
        }
    }
    
    /**
     * Sets hint color for focused state
     */
    @IBInspectable
    open var activeHintColor: UIColor = .cyan
    
    /**
     * Sets background color for not focused state
     */
    @IBInspectable
    open var defaultBackgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.8) {
        didSet {
            self.backgroundColor = self.defaultBackgroundColor
        }
    }
    
    /**
    * Sets background color for focused state
    */
    @IBInspectable
    open var focusedBackgroundColor: UIColor = .lightGray
    
    /**
    * Sets border color
    */
    @IBInspectable
    open var borderColor: UIColor = .lightGray {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    /**
    * Sets border width
    */
    @IBInspectable
    open var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    /**
    * Sets corner radius
    */
    @IBInspectable
    open var cornerRadius: CGFloat = 11 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    /**
    * Sets error color
    */
    @IBInspectable
    open var errorColor: UIColor = .red {
        didSet {
            self.errorLabel.textColor = errorColor
        }
    }
    
    override open var placeholder: String? {
        set {
            self.hintLabel.text = newValue
        }
        get {
            return self.hintLabel.text
        }
    }
    
    private var isHintVisible = false
    private let hintLabel = UILabel()
    private let errorLabel = UILabel()
    
    private let padding: CGFloat = 16
    private let hintFont = UIFont.systemFont(ofSize: 12)
    
    //  MARK: Public
    
    public func setError(errorString: String) {
        UIView.animate(withDuration: 0.4) {
            self.layer.borderColor = self.errorColor.cgColor
            self.errorLabel.alpha = 1
        }
        self.errorLabel.text = errorString
        self.updateErrorLabelPosition()
        self.errorLabel.shake(offset: 10)
    }
    
    //  MARK: Private
    
    private func initializeTextField() {
        self.configureTextField()
        self.configureHint()
        self.configureErrorLabel()
        self.addObservers()
    }
    
    private func addObservers() {
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func configureTextField() {
        self.clearButtonMode = .whileEditing
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.hintLabel.frame = CGRect(origin: CGPoint.zero,
                                      size: CGSize(width: self.frame.width,
                                                   height: self.frame.height))
        self.addSubview(hintLabel)
    }
    
    private func configureHint() {
        self.hintLabel.transform = CGAffineTransform.identity.translatedBy(x: padding, y: 0)
        self.hintLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.hintLabel.font = self.font
        self.hintLabel.textColor = inactiveHintColor
    }
    
    private func configureErrorLabel() {
        self.errorLabel.font = UIFont.systemFont(ofSize: 12)
        self.errorLabel.textAlignment = .right
        self.errorLabel.textColor = self.errorColor
        self.errorLabel.alpha = 0
        self.addSubview(self.errorLabel)
    }
    
    private func activateTextField() {
        guard !self.isHintVisible else {
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            if let text = self.text, !text.isEmpty {
                self.hintLabel.alpha = 1
            } else {
                self.hintLabel.transform =
                    CGAffineTransform.identity.translatedBy(x: self.padding, y: -self.hintHeight())
                self.hintLabel.font = self.hintFont
            }
            self.hintLabel.textColor = self.activeHintColor
            self.backgroundColor = self.focusedBackgroundColor
            if self.errorLabel.alpha == 0 {
                self.layer.borderColor = self.focusedBackgroundColor.cgColor
            }
        }
        
        isHintVisible.toggle()
    }
    
    private func deactivateTextField() {
        if !isHintVisible { return }
        
        UIView.animate(withDuration: 0.3) {
            if let text = self.text, !text.isEmpty {
                self.hintLabel.alpha = 0
            } else {
                self.hintLabel.transform =
                    CGAffineTransform.identity.translatedBy(x: self.padding, y: 0)
                self.hintLabel.font = self.font
            }
            self.hintLabel.textColor = self.inactiveHintColor
            self.backgroundColor = self.defaultBackgroundColor
            self.layer.borderColor = self.borderColor.cgColor
        }
        
        isHintVisible.toggle()
    }
    
    private func hintHeight() -> CGFloat {
        return hintFont.lineHeight - padding / 8
    }
    
    private func updateErrorLabelPosition() {
        let size = self.errorLabel.sizeThatFits(CGSize(width: self.frame.width,
                                                       height: CGFloat.greatestFiniteMagnitude))
        self.errorLabel.frame.size = size
        self.errorLabel.frame.origin.x = self.frame.width - size.width
        self.errorLabel.frame.origin.y = self.frame.height + padding / 4
    }
    
    @objc private func textFieldDidChange() {
        UIView.animate(withDuration: 0.2) {
            self.errorLabel.alpha = 0
            self.layer.borderColor = self.focusedBackgroundColor.cgColor
        }
    }
    
    //  MARK: UIKit methods
    
    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        self.activateTextField()
        return super.becomeFirstResponder()
    }

    @discardableResult
    override open func resignFirstResponder() -> Bool {
        self.deactivateTextField()
        return super.resignFirstResponder()
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        let rect = CGRect(
            x: self.padding,
            y: superRect.origin.y,
            width: superRect.size.width - self.padding * 1.5,
            height: superRect.size.height
        )
        return rect
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.editingRect(forBounds: bounds)
        let rect = CGRect(
            x: self.padding,
            y: self.hintHeight() - self.padding / 8,
            width: superRect.size.width - self.padding * 1.5,
            height: superRect.size.height - self.hintHeight()
        )
        return rect
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    
    override open func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.clearButtonRect(forBounds: bounds)
        return superRect.offsetBy(dx: -self.padding / 2, dy: 0)
    }
    
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: self.bounds.size.width, height: 64)
    }
    
    //  MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeTextField()
    }
}
