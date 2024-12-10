//
//  SinglePaywallViewController.swift
//  pathly-vpn
//
//  Created by Александр on 10.11.2024.
//

import UIKit

enum SinglePaywallItem {
    case secure(string: String)
    case protection(string: String)
    case verification(string: String)

    var icon: UIImage? {
        switch self {
            case .secure:
                return Asset.paywallSecure.image
            case .protection:
                return Asset.paywallProtection.image
            case .verification:
                return Asset.paywallIp.image
        }
    }
    var title: String {
        switch self {
        case .secure(let string):
            return string
        case .protection(let string):
            return string
        case .verification(let string):
            return string
        }
    }
    func toString(object: PaywallLocalize) -> String {
        switch self {
        case .secure:
            return object.secureString
        case .protection:
            return object.protectionString
        case .verification:
            return object.verificationString
        }
    }
}

class SinglePaywallView: UIView {
    
    private var iconView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var titleLabel: UILabel = {
        var label = ViewFactory.label(
            font: Styles.Fonts.title2,
            color: .white
        )
        label.numberOfLines = 2
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
        self.iconView.layer.cornerRadius = self.iconView.frame.width / 2
    }
    
    private func common() {
        let hStack = ViewFactory.stack(.horizontal, spacing: 20)
        self.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        hStack.addArrangedSubview(iconView)
        hStack.addArrangedSubview(titleLabel)
    }
    
    func configure(item: SinglePaywallItem) {
        self.iconView.image = item.icon
        self.titleLabel.text = item.title
    }
    
}

class SinglePaywallViewController: CommonPaywallViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter?.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        let vStack = ViewFactory.stack(.vertical, spacing: 35)
        let items: [SinglePaywallItem] = self.presenter?.items ?? []
        items.forEach { item in
            let view = SinglePaywallView()
            view.configure(item: item)
            view.snp.makeConstraints { make in
                make.height.equalTo(48)
            }
            vStack.addArrangedSubview(view)
        }
        self.contentStack.addArrangedSubview(vStack)
        
        bottomStack.insertArrangedSubview(descriptionLabel, at: 0)
        bottomStack.setCustomSpacing(18, after: descriptionLabel)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

