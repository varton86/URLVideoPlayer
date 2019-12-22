//
//  Extensions.swift
//  TestVideo
//
//  Created by Oleg Soloviev on 21/12/2019.
//  Copyright © 2019 Oleg Soloviev. All rights reserved.
//

import UIKit

extension UIViewController {
    func showError(_ msg: String) {
        let alert = UIAlertController(
            title: "Error",
            message: msg,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
