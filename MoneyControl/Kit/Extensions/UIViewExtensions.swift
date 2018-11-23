//
//  UIViewControllerExtensions.swift
//  MoneyControl
//
//  Created by Yaroslav Babalich on 2/5/18.
//  Copyright © 2018 RxToday Co. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - Class methods
    class func nib<T: UIView>() -> T {
        var className = NSStringFromClass(self)
        className = className.split{$0 == "."}.map(String.init)[1]
        return Bundle.main.loadNibNamed(className, owner: nil, options: nil)![0] as! T
    }
    
    class func nib<T: UIView>(sufix: String) -> T {
        var className = NSStringFromClass(self)
        className = className.split{$0 == "."}.map(String.init)[1]
        className += sufix
        return Bundle.main.loadNibNamed(className, owner: nil, options: nil)![0] as! T
    }
    
    // MARK: - Other methods
    public func removeAllSubviews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    public func currentFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        
        return nil
    }
    
    //just call in viewDidLayoutSubviews
    public func applyFullyRounded(_ radius: Float) {
        self.applyCornerRadius(radius, topLeft: true, topRight: true, bottomRight: true, bottomLeft: true)
    }
    
    public func applyCornerRadius(_ radius: Float, topLeft: Bool, topRight: Bool, bottomRight: Bool, bottomLeft: Bool) {
        if #available(iOS 11, *) {
            clipsToBounds = true
            layer.cornerRadius = CGFloat(radius)
            
            var corners: CACornerMask = CACornerMask()
            
            if topLeft {
                corners = corners.union(.layerMinXMinYCorner)
            }
            
            if topRight {
                corners = corners.union(.layerMaxXMinYCorner)
            }
            
            if bottomRight {
                corners = corners.union(.layerMaxXMaxYCorner)
            }
            
            if bottomLeft {
                corners = corners.union(.layerMinXMaxYCorner)
            }
            
            layer.maskedCorners = corners
        }
        
        
        var corners: UIRectCorner = UIRectCorner()
        
        if topLeft {
            corners = corners.union(.topLeft)
        }
        
        if topRight {
            corners = corners.union(.topRight)
        }
        
        if bottomRight {
            corners = corners.union(.bottomRight)
        }
        
        if bottomLeft {
            corners = corners.union(.bottomLeft)
        }
        
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: CGFloat(radius), height: CGFloat(radius)))
        let layer1 = CAShapeLayer()
        layer1.path = maskPath.cgPath
        self.layer.mask = layer1
    }
    
    // MARK: - Constraints methods
    public func alignExpandToSuperview() {
        self.alignExpandToSuperview(padding: 0)
    }
    
    public func alignExpandToSuperview(padding: Int) {
        let currentView: UIView = self
        let superView: UIView? = self.superview
        
        if superView == nil {
            return
        }
        
        currentView.translatesAutoresizingMaskIntoConstraints = false
        superView!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(padding)-[currentView]-\(padding)-|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views: ["currentView" : currentView]))
        
        superView!.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(padding)-[currentView]-\(padding)-|",
            options: NSLayoutConstraint.FormatOptions(rawValue: 0),
            metrics: nil,
            views:["currentView" : currentView]))
    }
    
    @discardableResult
    public func alignCenterX(toView view: UIView?) -> NSLayoutConstraint? {
        return self.alignToView(view: view,
            attr: .centerX,
            toAttr: .centerX,
            padding: 0,
            multiplier: 1);
    }
    
    @discardableResult
    public func alignCenterY(toView view: UIView?) -> NSLayoutConstraint? {
        return self.alignToView(view: view,
                                attr: NSLayoutConstraint.Attribute.centerY,
                                toAttr: NSLayoutConstraint.Attribute.centerY,
                                padding: 0,
                                multiplier: 1);
    }
    
    @discardableResult
    public func alignTop(toView view: UIView?, toTop: Bool, padding: CGFloat) -> NSLayoutConstraint? {
        return self.alignToView(view: view,
                                attr: .top,
                                toAttr: (toTop) ? .top : .bottom,
                                padding: padding,
                                multiplier: 1);
    }
    
    @discardableResult
    public func alignLeft(toView view: UIView?, toLeft: Bool, padding: CGFloat) -> NSLayoutConstraint? {
        return self.alignToView(view: view,
                                attr: .left,
                                toAttr: (toLeft) ? .left : .right,
                                padding: padding,
                                multiplier: 1);
    }
    
    @discardableResult
    public func alignRight(toView view: UIView?, toRight: Bool, padding: CGFloat) -> NSLayoutConstraint? {
        return self.alignToView(view: view,
                                attr: .right,
            toAttr: (toRight) ? .right : .left,
            padding: (toRight) ? -padding : padding,
            multiplier: 1);
    }
    
    @discardableResult
    public func alignBottom(toView view: UIView?, toBottom: Bool, padding: CGFloat) -> NSLayoutConstraint? {
        return self.alignToView(view: view,
                                attr: .bottom,
                                toAttr: (toBottom) ? .bottom : .top,
            padding: (toBottom) ? -padding : padding,
            multiplier: 1);
    }
    
    @discardableResult
    public func aspectRatioWidth(toHeight: CGFloat) -> NSLayoutConstraint? {
        return self.alignToView(view: self,
                                attr: .width,
                                toAttr: .height,
                                padding: 0,
                                multiplier: toHeight)
    }
    
    @discardableResult
    public func alignToView(view: UIView?, attr: NSLayoutConstraint.Attribute, toAttr: NSLayoutConstraint.Attribute, padding: CGFloat, multiplier: CGFloat) -> NSLayoutConstraint? {
        return self.align(
            attr1: attr,
            toView: view,
            attr2: toAttr,
            relation: NSLayoutConstraint.Relation.equal,
            padding: padding,
            multiplier: multiplier);
    }
    
    public func align(attr1: NSLayoutConstraint.Attribute, toView: UIView?, attr2: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, padding: CGFloat, multiplier: CGFloat) -> NSLayoutConstraint? {
        var constraint: NSLayoutConstraint? = nil
        if toView != nil {
            self.translatesAutoresizingMaskIntoConstraints = false
            constraint = NSLayoutConstraint(
                item: self,
                attribute: attr1,
                relatedBy: relation,
                toItem: toView!,
                attribute: attr2,
                multiplier: multiplier,
                constant: padding);
            constraint!.priority = UILayoutPriority.required - 1;
            self.superview?.addConstraint(constraint!)
        }
        return constraint
    }
    
    @discardableResult
    public func widthConstraint(needCreate create: Bool) -> NSLayoutConstraint? {
        return self.widthConstraint(needCreate: create, priority: UILayoutPriority.required)
    }
    
    @discardableResult
    public func heightConstraint(needCreate create: Bool) -> NSLayoutConstraint? {
        return self.heightConstraint(needCreate: create, priority: UILayoutPriority.required)
    }
    
    public func widthConstraint(needCreate create: Bool, priority: UILayoutPriority) -> NSLayoutConstraint? {
        // try to find constraint
        var constraint: NSLayoutConstraint? = self.constraintToSelf(withAttr: NSLayoutConstraint.Attribute.width)
        
        if create
            && constraint?.priority != priority
            && constraint != nil
        {
            self.removeConstraint(constraint!)
            constraint = nil;
        }
        
        // create constraint
        if constraint == nil && create {
            constraint = NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.width,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: self.frame.size.width)
            constraint!.priority = priority;
            self.addConstraint(constraint!)
        }
        
        return constraint;
    }
    
    public func heightConstraint(needCreate create: Bool, priority: UILayoutPriority) -> NSLayoutConstraint? {
        // try to find constraint
        var constraint: NSLayoutConstraint? = self.constraintToSelf(withAttr: NSLayoutConstraint.Attribute.height)
        
        if create
            && constraint?.priority != priority
            && constraint != nil
        {
            self.removeConstraint(constraint!)
            constraint = nil;
        }
        
        // create constraint
        if constraint == nil && create {
            constraint = NSLayoutConstraint(
                item: self,
                attribute: NSLayoutConstraint.Attribute.height,
                relatedBy: NSLayoutConstraint.Relation.equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1,
                constant: self.frame.size.height)
            constraint!.priority = priority;
            self.addConstraint(constraint!)
        }
        
        return constraint;
    }
    
    public func constraintToSelf(withAttr attr: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        var constraint: NSLayoutConstraint? = nil;
        for constraintTmp in self.constraints {
            if ((constraintTmp.firstAttribute == attr
                && constraintTmp.firstItem as? NSObject == self)
                || ((constraintTmp.secondAttribute == attr
                    && constraintTmp.secondItem as? NSObject == self)))
            {
                constraint = constraintTmp;
                break;
            }
        }
        
        return constraint;
    }
    
    //if first item or second item constains constraint to each other
    public func constraintBetween(second: UIView, attr: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        var constraint: NSLayoutConstraint? = nil;
        var allConstraints: [NSLayoutConstraint] = []
        allConstraints.append(contentsOf: self.constraints)
        allConstraints.append(contentsOf: second.constraints)
        
        for constraintTmp in allConstraints {
            if constraintTmp.firstAttribute == attr || constraintTmp.secondAttribute == attr {
                if (constraintTmp.firstItem as! NSObject == self || constraintTmp.secondItem as! NSObject == self)
                    && (constraintTmp.firstItem as! NSObject == second || constraintTmp.secondItem as! NSObject == second)
                {
                    constraint = constraintTmp;
                    break;
                }
            }
        }
        
        return constraint
    }
    
    //searching in views superviews
    static func constraintFromSuperviewBetween(view first: UIView, view second: UIView, attr: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        var constraint: NSLayoutConstraint? = nil;
        var allConstraints: [NSLayoutConstraint] = []
        if let superView = first.superview {
            allConstraints.append(contentsOf: superView.constraints)
        }
    
        if let superView = second.superview {
            allConstraints.append(contentsOf: superView.constraints)
        }
        
        for constraintTmp in allConstraints {
            if constraintTmp.firstAttribute == attr || constraintTmp.secondAttribute == attr {
                if (constraintTmp.firstItem as! NSObject == first || constraintTmp.secondItem as! NSObject == first)
                    && (constraintTmp.firstItem as! NSObject == second || constraintTmp.secondItem as! NSObject == second)
                {
                    constraint = constraintTmp;
                    break;
                }
            }
        }
        
        return constraint
    }
    
}
