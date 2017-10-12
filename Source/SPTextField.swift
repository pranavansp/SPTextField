//
//  LoginTextField.swift
//  ImageTextfieldUltra
//
//  Created by Sivarajah Pranavan on 8/15/17.
//  Copyright © 2017 Amethyst. All rights reserved.
//

import UIKit

@IBDesignable
open class LoginTextField: UITextField {
    
    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 8, inactive: 4)
    private let inactiveBorderLayer = CALayer()
    private let activeBorderLayer = CALayer()
    
    @IBInspectable
    var leftImage : UIImage? {
        didSet {
            updateView()
        }
    }
    @IBInspectable
    var leftPadding : CGFloat = 0 {
        didSet{
            updateView()
        }
    }
    @IBInspectable
    var rigthPadding : CGFloat = 0 {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable
    var borderInactiveColor : UIColor = .clear{
        didSet{
            updateBorder()
        }
    }
    @IBInspectable
    var borderActiveColor : UIColor = .clear{
        didSet{
            updateBorder()
        }
    }
    override open func willMove(toSuperview newSuperview: UIView!) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
            
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }

    open func textFieldDidBeginEditing() {
        activeBorderLayer.frame = actionForBorder(borderThickness.active, isFilled: true)
        rightViewMode = .never
    }

    open func textFieldDidEndEditing() {
        activeBorderLayer.frame = actionForBorder(borderThickness.active, isFilled: false)
        rightViewMode = .never
    }

    private func actionForBorder(_ thickness: CGFloat, isFilled: Bool) -> CGRect {
        if isFilled {
            return CGRect(origin: CGPoint(x: 30, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        } else {
            return CGRect(origin: CGPoint(x: 30, y: frame.height-thickness), size: CGSize(width: 0, height: thickness))
        }
    }
    
    private func updateBorder() {
        inactiveBorderLayer.frame = actionForBorder(borderThickness.inactive, isFilled: true)
        inactiveBorderLayer.backgroundColor = borderInactiveColor.cgColor
        
        activeBorderLayer.frame = actionForBorder(borderThickness.active, isFilled: false)
        activeBorderLayer.backgroundColor = borderActiveColor.cgColor
        
        layer.addSublayer(inactiveBorderLayer)
        layer.addSublayer(activeBorderLayer)
    }
    
    private func updateView() {
        if let icon = leftImage{
            leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: self.view.frame.width, height: self.view.frame.width))
            var width = leftPadding + 20
            
            if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line {
                    width = width + 5 + rigthPadding
            }
            imageView.image = icon
            imageView.tintColor = tintColor
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(imageView)
            leftView = view
        }else{
            leftViewMode = .never
        }
    }
}
