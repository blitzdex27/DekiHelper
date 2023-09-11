//
//  DekiFloatingView.swift
//  
//
//  Created by Dexter Ramos on 9/11/23.
//

import UIKit

open class DekiFloatingView: UIView, Floatable {

    public var animator: UIDynamicAnimator
    
    public var snapBehavior: UISnapBehavior!
    
    public typealias ShouldFloatClosure = (_ sender: UIPanGestureRecognizer) -> Bool
    var shouldFloatClosure: ShouldFloatClosure?

    required public init(referenceView: UIView, frame: CGRect = .zero) {
        self.animator = .init(referenceView: referenceView)
        super.init(frame: frame)
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
    }
    
    public convenience init(referenceView: UIView, shouldFloatClosure: ShouldFloatClosure? = nil, frame: CGRect = .zero) {
        self.init(referenceView: referenceView, frame: frame)
        self.shouldFloatClosure = shouldFloatClosure
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let shouldFloat = shouldFloatClosure?(sender) ?? true
        
        if shouldFloat {
            handleFloat(sender)
        }
        
    }
}
