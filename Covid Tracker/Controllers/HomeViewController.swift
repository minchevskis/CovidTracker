//
//  HomeViewController.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 8.4.21.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    @IBOutlet weak var navigationHolderView: UIView!
    @IBOutlet weak var btnAddCountry: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationView()
    }
    
    private func addNavigationView() {
        let navigationView = NavigationView(state: .onlyTitle, delegate: nil, title: "Dashboard")
        navigationHolderView.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @IBAction func onAddCountry(_ sender: UIButton) {
        performSegue(withIdentifier: "countriesSegue", sender: nil)
    }
}


