//
//  StringExtension.swift
//  Boardnote
//
//  Created by Julapong Techapakornrat on 21/05/2018.
//  Copyright © 2018 Super Scores Co., Ltd. All rights reserved.
//

import Foundation

extension String {
    func isEqualTo(insensitive compare: String) -> Bool {
        return (self.caseInsensitiveCompare(compare) == ComparisonResult.orderedSame)
    }
    func isValidEmail() -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regEx)
        return predicate.evaluate(with: self)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
