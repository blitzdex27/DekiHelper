//
//  DekiGetters.swift
//  
//
//  Created by Dexter Ramos on 9/26/23.
//


import Foundation
import UIKit

public struct DekiGetters {
    
    public struct UI {
        
        private static var keyWindow: UIWindow? {
            if #available(iOS 15.0, *) {
                let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
                return windowScene.keyWindow
            } else {
                return UIApplication.shared.windows.first { $0.isKeyWindow }
            }
        }
        
        public static let safeAreaInsets: UIEdgeInsets = {
            return keyWindow?.safeAreaInsets ?? .init()
        }()
        
        public static let screenSize: CGSize = UIScreen.main.bounds.size
        
        public static let screenScale: CGFloat = UIScreen.main.scale
        
        public static let statusBarHeight: CGFloat = {
            let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
            return windowScene.statusBarManager?.statusBarFrame.height ?? 0
        }()
        
        public static var navBarHeight: CGFloat {
            return topViewController?.navigationController?.navigationBar.frame.height ?? 0
        }
        
        public static var topViewController: UIViewController? {
            var topVC = keyWindow?.rootViewController
            while let presentedVC = topVC?.presentedViewController {
                topVC = presentedVC
            }
            return topVC
        }
    }
}

