//
//  JiroTextField.swift
//  TextFieldEffects
//
//  Created by Raúl Riera on 24/01/2015.
//  Copyright (c) 2015 Raul Riera. All rights reserved.
//

import UIKit

/**
 A JiroTextField is a subclass of the TextFieldEffects object, is a control that displays an UITextField with a customizable visual effect around the background of the control.
 */
@IBDesignable open class JiroTextField: TextFieldEffects {
    
    /**
     The color of the border.
     
     This property applies a color to the lower edge of the control. The default value for this property is a clear color.
     */
    @IBInspectable dynamic open var borderColor: UIColor? {
        didSet {
            updateBorder()
        }
    }
    
    /**
     The color of the placeholder text.
     
     This property applies a color to the complete placeholder string. The default value for this property is a black color.
     */
    @IBInspectable dynamic open var placeholderColor: UIColor = .black {
        didSet {
            updatePlaceholder()
        }
    }
    
    /**
     The scale of the placeholder font.
     
     This property determines the size of the placeholder label relative to the font size of the text field.
     */
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.80 {  //0.65
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            updateBorder()
            updatePlaceholder()
        }
    }
    
    private let borderThickness: CGFloat = 2
    private let placeholderInsets = CGPoint(x: 8, y: 8)
    private let textFieldInsets = CGPoint(x: 8, y: 12) //x: 8 ,y: 12
    private let borderLayer = CALayer()
    
    // MARK: - TextFieldEffects
    
    override open func drawViewsForRect(_ rect: CGRect) {
        print("SMGL: JiroTextField drawViewsForRect")

        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
        placeholderLabel.font = placeholderFontFromFont(font!)
        
        updateBorder()
        updatePlaceholder()
        
        layer.addSublayer(borderLayer)
        addSubview(placeholderLabel)        
    }
    
    override open func animateViewsForTextEntry() {
        print("SMGL: JiroTextField animateViewsForTextEntry")
        borderLayer.frame.origin = CGPoint(x: 0, y: font!.lineHeight)
        
        UIView.animate(withDuration: 0.2, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: ({
            
            self.placeholderLabel.frame.origin = CGPoint(x: self.placeholderInsets.x, y: self.borderLayer.frame.origin.y - self.placeholderLabel.bounds.height)
            self.borderLayer.frame = self.rectForBorder(self.borderThickness, isFilled: true)
            
        }), completion: { _ in
            self.animationCompletionHandler?(.textEntry)
        })
    }
    
    override open func animateViewsForTextDisplay() {
        print("SMGL: JiroTextField animateViewsForTextDisplay")
        if text!.isEmpty {
            UIView.animate(withDuration: 0.35, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 2.0, options: .beginFromCurrentState, animations: ({
                self.layoutPlaceholderInTextRect()
                self.placeholderLabel.alpha = 1
            }), completion: { _ in
                self.animationCompletionHandler?(.textDisplay)
            })
            
            borderLayer.frame = rectForBorder(borderThickness, isFilled: false)
        }
    }
    
    // MARK: - Private
    
    private func updateBorder() {
        print("SMGL: JiroTextField updateBorder")
        borderLayer.frame = rectForBorder(borderThickness, isFilled: false)
        borderLayer.backgroundColor = borderColor?.cgColor
    }
    
    private func updatePlaceholder() {
        print("SMGL: JiroTextField updatePlaceholder")
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func placeholderFontFromFont(_ font: UIFont) -> UIFont! {
        print("SMGL: JiroTextField placeholderFontFromFont")
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * placeholderFontScale)
        return smallerFont
    }
    
    private func rectForBorder(_ thickness: CGFloat, isFilled: Bool) -> CGRect {
        print("SMGL: JiroTextField rectForBorder")
        if isFilled {
            return CGRect(origin: CGPoint(x: 0, y: placeholderLabel.frame.origin.y + placeholderLabel.font.lineHeight), size: CGSize(width: frame.width, height: frame.height))
        } else {
            return CGRect(origin: CGPoint(x: 0, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        }
    }
    
    private func layoutPlaceholderInTextRect() {
        print("SMGL: JiroTextField layoutPlaceholderInTextRect")

        if text!.isNotEmpty {
            return
        }
        
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: textRect.size.height/2,
            width: placeholderLabel.frame.size.width, height: placeholderLabel.frame.size.height)
    }
    
    // MARK: - Overrides
    /*
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y) //Main
        //return bounds.insetBy(dx: 500, dy: 350) //Ours
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y) //Main
        //return bounds.insetBy(dx: 500, dy: 350)//Ours
    }*/
    
    //sort the inside out [text is on the border and textfield size shrinked on the text]
    //placeholder text on top off the border
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        print("SMGL: JiroTextField textRect")
        return bounds.insetBy(dx: 10, dy: 5) //10 from the left
    }
    
    //when you typing the text in
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        print("SMGL: JiroTextField editingRect")

        return bounds.insetBy(dx: 10, dy: 5) //10 from the left
    }

}
