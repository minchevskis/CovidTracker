//
//  HomeViewController.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 8.4.21.
//

import UIKit
import SnapKit
import JGProgressHUD

class HomeViewController: UIViewController, DisplayHudProtocol {

    @IBOutlet weak var navigationHolderView: UIView!
    @IBOutlet weak var btnAddCountry: UIButton!
    @IBOutlet weak var globalHolderView: UIView!
    @IBOutlet weak var lblConfirmed: UILabel!
    @IBOutlet weak var lblDeaths: UILabel!
    @IBOutlet weak var lblRecovered: UILabel!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var lblLastUpdate: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var selectedCountries = [Country]()
    
    var hud: JGProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationView()
        setupGlobalHolder()
        getGlobalData()
        collectionView.dataSource = self
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: 165, height: 70)
        }
        fetchCountries()
    }
    
    private func addNavigationView() {
        let navigationView = NavigationView(state: .onlyTitle, delegate: nil, title: "Dashboard")
        navigationHolderView.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupGlobalHolder() {
        globalHolderView.layer.cornerRadius = 8
        globalHolderView.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        globalHolderView.layer.shadowOpacity = 1.0
        globalHolderView.layer.shadowRadius = 10
        globalHolderView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func getGlobalData() {
        displayHud(true)
        APIManager.shared.getGlobalInfo { [weak self] (result) in
            guard let self = self else { return }
            self.displayHud(false)
            switch result {
            case .failure(let error):
                self.btnRetry.isHidden = false
                print(error.localizedDescription)
            case .success(let global):
                self.btnRetry.isHidden = true
                self.setGlobalData(global: global)
            }
        }
    }
    
    private func fetchCountries() {
        displayHud(true)
        
        APIManager.shared.getAllCountries { [weak self] (result) in
            self?.displayHud(false)
            
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let countries):
                self?.selectedCountries = countries.filter { $0.isSelected }
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setGlobalData(global: Global) {
        lblDeaths.text = global.deaths.getFormatedNumber()
        lblRecovered.text = global.recovered.getFormatedNumber()
        lblConfirmed.text = global.confirmed.getFormatedNumber()
        setFormatedLastUpdate()
    }
    
    private func setFormatedLastUpdate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, h:mm a"
        let formatedDate = dateFormatter.string(from: date)
        let updated = "Last Updated on " + formatedDate
        let text = "Confirmed Cases\n" + updated
        
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .bold),.foregroundColor: UIColor(hex: "3C3C3C") ],
            range: (text as NSString).range(of: text))
        attributed.addAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .regular),.foregroundColor: UIColor(hex: "707070") ],
            range: (text as NSString).range(of: updated))
        
        lblLastUpdate.attributedText = attributed
    }
    
    @IBAction func onAddCountry(_ sender: UIButton) {
        performSegue(withIdentifier: "countriesSegue", sender: nil)
    }
    
    @IBAction func onRetryPressed(_ sender: UIButton) {
        getGlobalData()
    }
}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedCountries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath) as! CountryCollectionCell
            let country = selectedCountries[indexPath.row]
            cell.lblCountryName.text = country.name
            cell.lblCasesNumber.text = "0"
            cell.shadowView.layer.cornerRadius = 8
            cell.shadowView.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
            cell.shadowView.layer.shadowOpacity = 1.0
            cell.shadowView.layer.shadowRadius = 8
            cell.shadowView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.masksToBounds = true
            return cell
        }
    
    
}




