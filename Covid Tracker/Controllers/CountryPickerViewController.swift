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
    
    private var countries = [Country]()
    
    var hud: JGProgressHUD?
    weak var delegate: ReloadDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationView()
        setupTableView()
        fetchCountries()
    }
    
    private func addNavigationView() {
        let navigationView = NavigationView(state: .backAndTitle, delegate: self, title: "Add Country")
        navigationHolderView.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.separatorColor = UIColor(hex: "EDEDED")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.reuseIdentifier)
    }
    
    private func fetchCountries() {
        displayHud(true)
        
        APIManager.shared.getAllCountries { [weak self] (result) in
            self?.displayHud(false)
            
            switch result {
            case .failure(let error):
                self?.showErrorAlert(error)
            case .success(let countries):
                self?.countries = countries.sorted(by: { $0.name < $1.name })
                self?.tableView.reloadData()
            }
        }
    }

}

extension CountryPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.reuseIdentifier)as! CountryTableViewCell
        let country = countries[indexPath.row]
        cell.delegate = self
        cell.setupCellData(country: country)
        return cell
    }
    
}

extension CountryPickerViewController: CountySelectionDelegate {
    func didChangeValueOn(country: Country) {
        guard let index = countries.firstIndex(where: { $0.isoCode == country.isoCode }) else { return }
        tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .none)
        delegate?.reloadCountriesData()
    }
    
    
}

extension CountryPickerViewController: NavigationViewDelegate {
    func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}


