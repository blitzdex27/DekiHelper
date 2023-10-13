//
//  Floatable.swift
//  
//
//  Created by Dexter Ramos on 9/11/23.
//
#if PLATFORM_IOS
import Foundation
import UIKit

public protocol Animatable: UIView {
    var referenceView: UIView { get set }
    var animator: UIDynamicAnimator { get set }
}

public protocol Snappable: UIView {
    var snapBehavior: UISnapBehavior! { get set }
}

public protocol Floatable: Animatable, Snappable  {
    func handleFloat(_ sender: UIPanGestureRecognizer)
}

public extension Floatable {
    func handleFloat(_ sender: UIPanGestureRecognizer) {
        guard let referenceView = animator.referenceView else {
            return
        }
        
        let location = sender.location(in: referenceView)
        
        let state = sender.state
        
        switch state {
        case .began:
            if let snapBehavior = snapBehavior {
                animator.removeBehavior(snapBehavior)
            }
            center = location
        case .changed:
            center = location
        case .ended:
            center = location
            
            let halfWidth = referenceView.frame.width / 2
            let fullWidth = referenceView.frame.width
            
            let (x, y) = (location.x, location.y)
            
            let snapTo: CGPoint
            
            if x < halfWidth {
                snapTo = .init(x: 0 + frame.width / 2, y: y)
            } else {
                snapTo = .init(x: fullWidth - frame.width / 2, y: y)
            }
            
            snapBehavior = .init(item: self, snapTo: snapTo)
            animator.addBehavior(snapBehavior)
        default:
            break
        }
    }
}
#endif
