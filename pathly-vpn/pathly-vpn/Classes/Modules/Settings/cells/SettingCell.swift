//
//  SettingCell.swift
//  pathly-vpn
//
//  Created by Александр on 08.11.2024.
//

import UIKit

enum SettingItem: CaseIterable {
    case subscription
    case support
    case privacy
    case terms
    
    var icon: UIImage? {
        switch self {
        case .subscription:
            return Asset.settingsSubscription.image
        case .support:
            return Asset.settingsSupport.image
        case .privacy:
            return Asset.settingsPrivacy.image
        case .terms:
            return Asset.settingsTerms.image
        }
    }
    var title: String {
        switch self {
            case .subscription:
                return "Manage Subscription"
            case .support:
                return "Help & Support"
            case .privacy:
                return "Privacy Policy"
            case .terms:
                return "Terms of Service"
        }
    }
}

enum CellCorner {
    case up
    case down
    case none
}

class SettingCell: UITableViewCell {

    static let reuseIdentifier: String = "SettingCell"
    
    private lazy var iconView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.snp.makeConstraints { make in
            make.width.equalTo(18)
        }
        return view
    }()
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = Styles.Fonts.headline1
        label.textColor = .white
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = Styles.Fonts.headline1
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func common() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = Asset.gray.color
        self.backgroundColor = .clear
        let hStack = ViewFactory.stack(.horizontal, spacing: 18)
        self.contentView.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(
                top: 0,
                left: 20,
                bottom: 0,
                right: 20)
            )
        }
        
        hStack.addArrangedSubview(iconView)
        hStack.addArrangedSubview(titleLabel)
        
        let rightView = UIImageView(image: Asset.chevronRight.image)
        rightView.contentMode = .scaleAspectFit
        rightView.snp.makeConstraints { make in
            make.width.equalTo(10)
        }
        hStack.addArrangedSubview(rightView)
    }
    
    func configure(item: SettingItem, cornerType: CellCorner) {
        self.iconView.image = item.icon
        self.titleLabel.text = item.title
        
        switch cornerType {
            case .up:
                self.contentView.layer.cornerRadius = 20
                self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .down:
                self.contentView.layer.cornerRadius = 20
                self.contentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case .none:
                self.contentView.layer.cornerRadius = 0
        }
    }


}
