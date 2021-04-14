//
//  Alertable.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 14.4.21.
//

import Foundation
import UIKit

protocol Alertable: AnyObject {
    func showErrorAlert(_ error: Error)
}

extension Alertable where Self: UIViewController {
    func showErrorAlert(_ error: Error) {
        UIAlertController.Builder()
            .withTitle("Error")
            .withMessage(error.localizedDescription)
            .addOkAction()
            .show(in: self)
    }
}
