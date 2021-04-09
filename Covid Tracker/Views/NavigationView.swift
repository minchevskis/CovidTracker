//
//  NavigationView.swift
//  Covid Tracker
//
//  Created by Stefan Minchevski on 8.4.21.
//

import UIKit
import SnapKit

protocol NavigationViewDelegate: AnyObject {
    func didTapBack()
}


class NavigationView: UIView {
    
    enum NavigationState {
        case onlyTitle
        case backAndTitle
    }
    
    private lazy var btnBack: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.setTitle(nil, for: .normal)
        button.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        return button
    }()
    
    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let state: NavigationState
    private weak var delegate: NavigationViewDelegate?
    
    private var gradientLayer: CAGradientLayer?
    
    init(state: NavigationState, delegate: NavigationViewDelegate?, title: String) {
        self.state = state
        super.init(frame: .zero)
        self.delegate = delegate
        lblTitle.text = title
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupGradient()
        switch state {
        case .onlyTitle:
            addSubview(lblTitle)
            lblTitle.snp.makeConstraints { (make) in
                make.height.equalTo(30)
                make.leading.equalToSuperview().offset(16)
                make.top.equalToSuperview().inset(61)
                make.trailing.equalToSuperview().inset(16)
            }
        case .backAndTitle:
            addSubview(btnBack)
            addSubview(lblTitle)
            btnBack.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(13)
                make.top.equalToSuperview().inset(59)
                make.width.equalTo(20)
                make.height.equalTo(26)
            }
            
            lblTitle.snp.makeConstraints { (make) in
                make.height.equalTo(30)
                make.leading.equalTo(btnBack.snp.trailing).offset(15)
                make.top.equalToSuperview().inset(61)
                make.trailing.equalToSuperview().inset(16)
            }
        }
    }
    
    private func setupGradient() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [UIColor(hex: "#5AC7AA").cgColor,UIColor(hex: "#9ADCB9").cgColor]
        gradientLayer?.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer?.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer?.frame = .zero
        gradientLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 124)
        layer.addSublayer(gradientLayer!)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    @objc private func onBack() {
        delegate?.didTapBack()
    }
}


