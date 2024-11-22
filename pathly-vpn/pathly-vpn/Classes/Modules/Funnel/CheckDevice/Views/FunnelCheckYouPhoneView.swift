//
//  CheckYouPhoneView.swift
//  GrowVPN
//
//  Created by Александр on 28.08.2024.
//

import UIKit

class FunnelContentView: UIView {
    
    var didNextTap: (() -> Void)?
    
}

final class FunnelCheckYouPhoneView: FunnelContentView {

    var titleColor: UIColor = .white
    var subtitleColor: UIColor = UIColor(red: 141/255, green: 141/255, blue: 147/255, alpha: 1)
    var actionButtonColor: UIColor = UIColor(red: 0/255, green: 123/255, blue: 254/255, alpha: 1)

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        var button = UIButton(type: .system)
        button.tintColor = .white
        button.layer.cornerRadius = 14
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        button.addTarget(self, action: #selector(onDidTapAction), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func common() {
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 15
        
        self.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let containerImageView = UIView()
        let warningDeviceView = UIImageView(image: UIImage(named: "funnel-warning-device"))
        warningDeviceView.contentMode = .scaleAspectFit
        containerImageView.addSubview(warningDeviceView)
        warningDeviceView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        containerImageView.snp.makeConstraints { make in
            make.height.equalTo(38)
        }
        
        let spacingView = UIView()
        
        
        vStack.addArrangedSubview(containerImageView)
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        vStack.setCustomSpacing(30, after: titleLabel)
        vStack.addArrangedSubview(spacingView)
        vStack.addArrangedSubview(actionButton)
    }
    
    @objc func onDidTapAction() {
//        self.didNext?(.checkover)
    }

    func configure(title: String, subtitle: String, buttonTitle: String) {
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        self.actionButton.setTitle(buttonTitle, for: .normal)
        
        self.titleLabel.textColor = self.titleColor
        self.subtitleLabel.textColor = self.subtitleColor
        self.actionButton.backgroundColor = self.actionButtonColor
    }
    
}

