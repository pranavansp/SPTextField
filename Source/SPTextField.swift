//
//  SPTextField.swift
//  SPTextField
//
//  Created by Sivarajah Pranavan on 8/15/17.
//  Copyright © 2017 Pranavan. All rights reserved.
//

import UIKit

@IBDesignable
open class SPTextField: UITextField {
    
    private let borderThickness: (active: CGFloat, inactive: CGFloat) = (active: 3, inactive: 1)
    private let inactiveBorderLayer = CALayer()
    private let activeBorderLayer = CALayer()
    
    @IBInspectable
    var leftImage : UIImage? {
        didSet {
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
    
    @IBInspectable
    var alertImage : UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable
    var ImageSize : CGFloat = 30 {
        didSet{
            updateView()
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
            return CGRect(origin: CGPoint(x: ImageSize, y: frame.height-thickness), size: CGSize(width: frame.width, height: thickness))
        } else {
            return CGRect(origin: CGPoint(x: ImageSize, y: frame.height-thickness), size: CGSize(width: 0, height: thickness))
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
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ImageSize, height: ImageSize))
            
            var width = ImageSize + rigthPadding
            
            if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line {
                    width = width + 5
            }
            imageView.image = icon
            imageView.tintColor = tintColor
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
            view.addSubview(imageView)
            leftView = view
        }else{

            leftViewMode = .never
        }

        if let alertIcon = alertImage {
            rightViewMode = .never
            let alertImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ImageSize, height: ImageSize))
            let alertView = UIView(frame:  CGRect(x: 0, y: 0, width: ImageSize+5, height: ImageSize))
            alertImageView.image = alertIcon
            alertImageView.tintColor = tintColor
            alertView.addSubview(alertImageView)
            rightView = alertView
        }else{
            rightViewMode = .never
        }
    }
    
    public func invalidFieldAlert() {
        rightViewMode = .unlessEditing
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint : CGPoint.init(x: self.center.x - 5.0, y: self.center.y))
        animation.toValue = NSValue(cgPoint : CGPoint.init(x: self.center.x + 5.0, y: self.center.y))
        layer.add(animation, forKey: "position")
    }
}
