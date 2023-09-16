//
//  DekiValidator.swift
//  
//
//  Created by Dexter Ramos on 9/16/23.
//

import Foundation

struct DekiValidator {
    
    
    private static let regex: String = {
        "^(?:(?:(?:(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-])+(?:(?:\\.(?!\\.))?(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-])+)*)|(?:\"(?:[^\"\\\\]|\\\\.)*\"))@(?:(?:[a-zA-Z0-9])+(?:\\.(?:[a-zA-Z0-9])+(?:[a-zA-Z0-9-])*(?:[a-zA-Z0-9]))+))$"
    }()
    
    static func validateEmail(_ email: String) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", Self.regex)
        return pred.evaluate(with: email)
    }
}
