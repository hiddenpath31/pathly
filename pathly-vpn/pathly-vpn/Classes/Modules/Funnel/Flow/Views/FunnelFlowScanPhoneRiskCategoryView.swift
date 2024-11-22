//
//  FunnelFlowScanPhoneRiskCategoryView.swift
//  GrowVPN
//
//  Created by Александр on 31.08.2024.
//

import UIKit

class FunnelFlowScanPhoneRiskCategoryView: UIView {

    private var icon: UIImage?
    private var title: String
    
    private lazy var iconView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    init(icon: UIImage?, title: String) {
        self.icon = icon
        self.title = title
        
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func common() {
        addSubview(iconView)
        addSubview(textLabel)
        
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(32)
        }
        textLabel.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(iconView.snp.right).inset(-20)
            make.height.greaterThanOrEqualTo(32)
        }
        
        self.iconView.image = self.icon
        self.textLabel.text = self.title
    }

}
