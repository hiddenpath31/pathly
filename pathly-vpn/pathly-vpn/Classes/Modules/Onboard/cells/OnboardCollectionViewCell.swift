//
//  OnboardCollectionViewCell.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import UIKit

enum OnboardItem: CaseIterable {
    case protect
    case choose
    case check
    
    var title: String {
        switch self {
        case .protect:
            return L10n.Onboard.Protect.title
        case .choose:
            return L10n.Onboard.Location.title
        case .check:
            return L10n.Onboard.Ip.title
        }
    }
    var subtitle: String {
        switch self {
        case .protect:
            return L10n.Onboard.Protect.description
        case .choose:
            return L10n.Onboard.Location.description
        case .check:
            return L10n.Onboard.Ip.description
        }
    }
    var image: UIImage? {
        switch self {
            case .protect:
                return Asset.onboardProtect.image
            case .choose:
                return Asset.onboardChoose.image
            case .check:
                return Asset.onboardCheck.image
        }
    }
}

class OnboardCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifire: String = "OnboardCollectionViewCell"
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = Styles.Fonts.largeTitle
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        var label = UILabel()
        label.font = Styles.Fonts.callout2
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.numberOfLines = 0
        label.textColor = Asset.textGray.color
        label.textAlignment = .center
        return label
    }()
    private lazy var imgView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func common() {
        let containerView = UIView()
        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let vStack = ViewFactory.stack(.vertical, spacing: 20)
        containerView.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40))
        }
        
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        vStack.addArrangedSubview(imgView)
    }
    
}

extension OnboardCollectionViewCell {
    
    func configure(item: OnboardItem) {
        self.imgView.image = item.image
        self.titleLabel.text = item.title
        self.subtitleLabel.text = item.subtitle
    }
    
}
