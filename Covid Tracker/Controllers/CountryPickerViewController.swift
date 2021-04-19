//
//  CountryPickerViewController.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 8.4.21.
//

import UIKit
import JGProgressHUD

protocol ReloadDataDelegate: AnyObject {
    func reloadCountriesData()
}

class CountryPickerViewController: UIViewController, DisplayHudProtocol, Alertable {

    @IBOutlet weak var navigationHolderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var searchHolderView: UIView!
    
    private var countries = [Country]()
    
    var hud: JGProgressHUD?
    weak var delegate: ReloadDataDelegate?
    
    var userDidTapSearch = false
    
    private let api = WebService()
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    var countriesDataSource: [Country] {
        if segmentControl.selectedSegmentIndex == 0 {
            guard let searchText = searchController.searchBar.text else {
                return countries
            }
            return countries.filter { $0.name.lowercased() == searchText.lowercased() }
        } else {
            
            guard let searchText = searchController.searchBar.text else {
                return countries.filter{ $0.isSelected }
            }
            return countries.filter { $0.isSelected && $0.name.lowercased().hasPrefix(searchText.lowercased())  }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationView()
        setupTableView()
        fetchCountries()
        configureSegmentControl()
        setupSearchController()
    }
    
    private func addNavigationView() {
        let navigationView = NavigationView(state: .backAndTitle, delegate: self, title: "Add Country")
        navigationHolderView.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupSearchController() {
        searchHolderView.layer.cornerRadius = 25
        searchHolderView.layer.masksToBounds = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search countries"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.extendedLayoutIncludesOpaqueBars = true
        searchController.automaticallyShowsCancelButton = false
        searchHolderView.addSubview(searchController.searchBar)
        searchHolderView.clipsToBounds = true
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorColor = UIColor(hex: "EDEDED")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.reuseIdentifier)
    }
    
    private func fetchCountries() {
        displayHud(true)
        
        api.request(CountriesAPI.getAllCountries) { [weak self] (_ result: Result<[Country], Error>)-> Void in
            switch result {
            case .failure(let error):
                self?.showErrorAlert(error)
            case .success(let countries):
                self?.countries = countries.sorted(by: { $0.name < $1.name })
                self?.tableView.reloadData()
            }
        }
        
    // this is another way to getAllCountries
        
//        APIManager.shared.getAllCountries { [weak self] (result) in
//            self?.displayHud(false)
//
//            switch result {
//            case .failure(let error):
//                self?.showErrorAlert(error)
//            case .success(let countries):
//                self?.countries = countries.sorted(by: { $0.name < $1.name })
//                self?.tableView.reloadData()
//            }
//        }
    }
    
    private func configureSegmentControl() {
        segmentControl.setBackgroundImage(nil,
                                          for: .normal,
                                          barMetrics: .compact)
        
        segmentControl.backgroundColor = .clear
        segmentControl.tintColor = .clear
        
        segmentControl.setTitleTextAttributes(
            [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .normal)
        
        segmentControl.setTitleTextAttributes(
            [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                NSAttributedString.Key.foregroundColor: UIColor(hex: "#3c3c3c")
            ], for: .normal)
    }
    
    @IBAction func onSegmentChanged(_ segmentControl: UISegmentedControl) {
        tableView.reloadData()
    }
    
}

extension CountryPickerViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
}

extension CountryPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countriesDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.reuseIdentifier)as! CountryTableViewCell
        let country = countriesDataSource[indexPath.row]
        cell.delegate = self
        cell.setupCellData(country: country)
        return cell
    }
    
}

extension CountryPickerViewController: CountySelectionDelegate {
    func didChangeValueOn(country: Country) {
        delegate?.reloadCountriesData()
        guard let index = countriesDataSource.firstIndex(where: { $0.isoCode == country.isoCode }) else {
            return
        }
        tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
    } 
}

extension CountryPickerViewController: NavigationViewDelegate {
    func didTapBack() {
        searchController.isActive = false
        navigationController?.popViewController(animated: true)
    }
}


