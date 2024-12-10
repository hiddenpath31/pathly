//
//  DataCell.swift
//  pathly-vpn
//
//  Created by Александр on 08.11.2024.
//

import UIKit

enum DataItem: CaseIterable {
    case ip
    case location
    case postal
    case country
    
    var icon: UIImage? {
        switch self {
        case .ip:
            return Asset.dataIp.image
        case .location:
            return Asset.dataLocation.image
        case .postal:
            return Asset.dataPostalCode.image
        case .country:
            return Asset.dataCountryCode.image
        }
    }
    var title: String {
        switch self {
            case .ip:
                return L10n.Data.ipAddress
            case .location:
                return L10n.Data.location
            case .postal:
                return L10n.Data.postalCode
            case .country:
                return L10n.Data.countryCode
        }
    }
}

class DataCell: UITableViewCell {

    static let reuseIdentifier: String = "DataCell"
    
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
        var label = ViewFactory.label(
            font: Styles.Fonts.headline3,
            color: Asset.textGray.color
        )
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
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        let hStack = ViewFactory.stack(.horizontal, spacing: 18)
        self.contentView.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        hStack.addArrangedSubview(iconView)
        hStack.addArrangedSubview(titleLabel)
        hStack.addArrangedSubview(descriptionLabel)
    }
    
    func configure(item: DataInfoDTO) {
        self.iconView.image = item.item.icon
        self.titleLabel.text = item.item.title
        self.descriptionLabel.text = item.dataString
    }

}
