//
//  DekiFloatingView.swift
//  
//
//  Created by Dexter Ramos on 9/11/23.
//
#if PLATFORM_IOS
import UIKit

@objcMembers open class DekiFloatingView: UIView, Floatable {

    var animator: UIDynamicAnimator
    
    var snapBehavior: UISnapBehavior!
    
    var referenceView: UIView
    
    typealias ShouldFloatClosure = (_ sender: UIPanGestureRecognizer) -> Bool
    var shouldFloatClosure: ShouldFloatClosure?

    required init(referenceView: UIView, frame: CGRect) {
        self.animator = .init(referenceView: referenceView)
        self.referenceView = referenceView
        
        super.init(frame: frame)
        setupUI()
        addGestures()
    }
    
    convenience init(referenceView: UIView, shouldFloatClosure: ShouldFloatClosure? = nil, frame: CGRect = .zero) {
        self.init(referenceView: referenceView, frame: frame)
        self.shouldFloatClosure = shouldFloatClosure

    }
    
    private func addGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        referenceView.addSubview(self)
        
    }
    
    @objc func updateReferenceView(_ view: UIView) {
        self.animator = UIDynamicAnimator(referenceView: view)
        self.referenceView = view
        referenceView.addSubview(self)
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        
        guard let shouldFloatClosure = shouldFloatClosure else {
            handleFloat(sender)
            return
        }
        
        if shouldFloatClosure(sender) {
            handleFloat(sender)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        // override
    }
}
#endif
