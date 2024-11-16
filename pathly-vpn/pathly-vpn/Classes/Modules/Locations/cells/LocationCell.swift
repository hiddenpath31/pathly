//
//  LocationCell.swift
//  pathly-vpn
//
//  Created by Александр on 08.11.2024.
//

import UIKit

enum ServerDetailStyle {
    case select
    case unselect
    case primary
    
    var icon: UIImage? {
        switch self {
            case .select:
                return Asset.locationsRadioSelect.image
            case .unselect:
                return Asset.locationsRadioEmpty.image
            case .primary:
                return Asset.locationsLock.image
        }
    }
}

class LocationCell: UITableViewCell {

    static let reuseIdentifier: String = "LocationCell"
    
    private lazy var iconView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.snp.makeConstraints { make in
            make.size.equalTo(38)
        }
        view.backgroundColor = Asset.textGray.color
        return view
    }()
    private lazy var detailView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
        return view
    }()
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = Styles.Fonts.headline5
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.iconView.layoutIfNeeded()
        self.iconView.layer.cornerRadius = self.iconView.frame.height / 2
    }
    
    private func common() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        let hStack = ViewFactory.stack(.horizontal, spacing: 18)
        self.contentView.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview()
        }
        
        let containerIconView = UIView()
        containerIconView.addSubview(iconView)
        containerIconView.snp.makeConstraints { make in
            make.width.equalTo(38)
        }
        iconView.snp.makeConstraints { make in
            make.left.right.centerY.equalToSuperview()
            make.height.equalTo(self.iconView.snp.width)
        }
        
        hStack.addArrangedSubview(containerIconView)
        hStack.addArrangedSubview(titleLabel)
        hStack.addArrangedSubview(detailView)
    }
    
    func configure(item: Server, detail: ServerDetailStyle) {
        self.iconView.image = UIImage(named: item.country.uppercased())
        self.titleLabel.text = item.name
        self.detailView.image = detail.icon
    }

}
