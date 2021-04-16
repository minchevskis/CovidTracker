//
//  CountryCollectionViewCell.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 13.4.21.
//

import UIKit

class CountryCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblCasesNumber: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    
    var country: Country?
    
    func setCountryData(_ country: Country) {
        self.country = country
        lblCountryName.text = country.name
        getComfirmedCases(country)
    }
    
    private func getComfirmedCases(_ country: Country) {
        APIManager.shared.getConfirmedCases(for: country.slug) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let casesByDay):
                print(casesByDay.count)
                
                let sorted = casesByDay.sorted(by: { $0.date > $1.date })
                if let today = sorted.first {
                    self.lblCasesNumber.text = "\(Int64(today.cases).getFormatedNumber())."
                }
            }
        }
    }
}
