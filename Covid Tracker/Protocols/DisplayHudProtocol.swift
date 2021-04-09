//
//  File.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 9.4.21.
//

import Foundation
import UIKit
import JGProgressHUD

protocol DisplayHudProtocol: AnyObject {
    var hud: JGProgressHUD? { get set }
    
    func displayHud(_ shouldDisplay: Bool)
}

extension DisplayHudProtocol {
    func displayHud(_ shouldDisplay: Bool) {
        print("Default for everyone")
    }
}

extension DisplayHudProtocol where Self: UIViewController {
    func displayHud(_ shouldDisplay: Bool) {
        print("Deafaul for UIViewController")
        
        if shouldDisplay {
            if hud == nil {
                setDefaulthud()
            }
            hud?.show(in: self.view)
        } else {
            hud?.dismiss()
        }
    }
    
    private func setDefaulthud() {
        hud = JGProgressHUD(style: .dark)
    }
}

