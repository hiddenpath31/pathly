//
//  CountryView.swift
//  pathly-vpn
//
//  Created by Александр on 08.11.2024.
//

import UIKit

class CountryView: UIView {

    var didTap: Completion?
    
    private lazy var iconView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.snp.makeConstraints { make in
            make.size.equalTo(38)
        }
        view.backgroundColor = Asset.textGray.color.withAlphaComponent(0.2)
        return view
    }()
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = Styles.Fonts.headline5
        label.textColor = .white
        label.text = "Name"
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        var label = UILabel()
        label.font = Styles.Fonts.footnote
        label.textColor = Asset.textGray.color
        label.text = "Subtitle"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
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
        let containerView = UIView()
        let hStack = ViewFactory.stack(.horizontal, spacing: 12)
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        containerView.addSubview(hStack)
        containerView.layer.cornerRadius = 20
        containerView.backgroundColor = Asset.gray.color
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        let vStack = ViewFactory.stack(.vertical, spacing: 4)
        let rightView = UIImageView(image: Asset.chevronRight.image)
        rightView.contentMode = .center
        rightView.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        
        hStack.addArrangedSubview(iconView)
        hStack.addArrangedSubview(vStack)
        hStack.addArrangedSubview(rightView)
        
        let actionButton = UIButton(type: .system, primaryAction: UIAction(handler: { action in
            self.didTap?()
        }))
        containerView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(server: Server?) {
        if let server = server {
            self.subtitleLabel.isHidden = false
            self.titleLabel.text = server.name
            self.subtitleLabel.text = L10n.Vpn.streamingServer
            self.iconView.image = UIImage(named: server.country)
        } else {
            self.titleLabel.text = L10n.Vpn.selectServer
            self.subtitleLabel.isHidden = true
            self.iconView.image = nil
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
