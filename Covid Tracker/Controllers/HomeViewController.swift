//
//  HomeViewController.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 8.4.21.
//

import UIKit
import SnapKit
import JGProgressHUD

class HomeViewController: UIViewController, DisplayHudProtocol, Alertable {
    
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
    private(set) var allCountries = [Country]()
    
    var hud: JGProgressHUD?
    var api = WebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigationView()
        setupGlobalHolder()
        getGlobalData()
        collectionView.delegate   = self
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
        
        api.request(GlobalAPI.getSummary) { [weak self] (_ result: Result<GlobalResponse, Error>) -> Void in
            guard let self = self else { return }
            self.displayHud(false)
            switch result {
            case .failure(let error):
                self.btnRetry.isHidden = false
                self.showErrorAlert(error)
            case .success(let globalResponse):
                self.btnRetry.isHidden = true
                self.setGlobalData(global: globalResponse.global)
            }
        }
    }
        
        //        displayHud(true)
        //        APIManager.shared.getGlobalInfo { [weak self] (result) in
        //            guard let self = self else { return }
        //            self.displayHud(false)
        //            switch result {
        //            case .failure(let error):
        //                self.btnRetry.isHidden = false
        //                self.showErrorAlert(error)
        //            case .success(let global):
        //                self.btnRetry.isHidden = true
        //                self.setGlobalData(global: global)
        //            }
        //        }
        //    }
        
        private func fetchCountries() {
            displayHud(true)
            
            APIManager.shared.getAllCountries { [weak self] (result) in
                self?.displayHud(false)
                switch result {
                case .failure(let error):
                    self?.showErrorAlert(error)
                case .success(let countries):
                    self?.allCountries = countries
                    self?.reloadCountriesData()
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
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "countriesSegue" {
                let controller = segue.destination as! CountryPickerViewController
                controller.delegate = self
            }
        }
    }
    
    extension HomeViewController: ReloadDataDelegate {
        func reloadCountriesData() {
            selectedCountries = allCountries.filter { $0.isSelected }
            collectionView.reloadData()
        }
    }
    
    
    extension HomeViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return selectedCountries.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath) as! CountryCollectionCell
            let country = selectedCountries[indexPath.row]
            cell.setCountryData(country)
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
    
    extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 165, height: 70)
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
    }





