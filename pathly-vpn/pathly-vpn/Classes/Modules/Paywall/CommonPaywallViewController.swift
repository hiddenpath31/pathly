//
//  CommonPaywallViewController.swift
//  pathly-vpn
//
//  Created by Александр on 10.11.2024.
//

import UIKit

typealias PaywallViewEventHandler = ((PaywallViewEvent) -> Void)
enum PaywallViewEvent {
    case dismiss
    case subscribe
    case select(productId: String)
    case terms
    case privacy
}

protocol PaywallView: AnyObject, Loadable {
    var presenter: PaywallPresenterInterface? { get set }
    
    func dismiss()
    func display(products: [ProductDTO], paywallLocalize: PaywallLocalize?)
    func display(productDescription: String, dismissDelay: Int, paywallLocalize: PaywallLocalize?)
}

class CommonPaywallViewController: UIViewController {

    private var productViews: [ProductView] = []
    private lazy var titleLabel: UILabel = {
        let titleLabel = ViewFactory.label(
            font: Styles.Fonts.largeTitle,
            color: .white
        )
        titleLabel.textAlignment = .center
        titleLabel.text = "Go Premium"
        return titleLabel
    }()
    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = ViewFactory.label(
            font: Styles.Fonts.callout2,
            color: Asset.textGray.color
        )
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Unlock the full power of this mobile tool\nand enjoy a digital experience like never!"
        subtitleLabel.numberOfLines = 0
        return subtitleLabel
    }()
    private lazy var actionButton: UIButton = {
        let actionButton = ViewFactory.Buttons.base()
        actionButton.setTitle("Start & Subscribe", for: .normal)
        actionButton.addAction(UIAction(handler: { [weak self] action in
            self?.presenter?.pay()
        }), for: .touchUpInside)
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        return actionButton
    }()
    private lazy var titleView: UIView = {
        var vStack = ViewFactory.stack(.vertical, spacing: 40)
        
        let iconView = UIImageView(image: Asset.paywallCrown.image)
        iconView.contentMode = .scaleAspectFit
        iconView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        
        vStack.addArrangedSubview(iconView)
        vStack.addArrangedSubview(titleLabel)
        vStack.setCustomSpacing(12, after: titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        
        return vStack
    }()
    lazy var contentStack: UIStackView = {
        var view = ViewFactory.stack(.vertical, spacing: 35)
        return view
    }()
    lazy var bottomStack: UIStackView = {
        let view = ViewFactory.stack(.vertical, spacing: 32)
        return view
    }()
    lazy var descriptionLabel: UILabel = {
        var label = ViewFactory.label(
            font: Styles.Fonts.callout,
            color: Asset.textGray.color
        )
        label.textAlignment = .center
        label.text = "Description"
        return label
    }()
    private lazy var termsButton: UIButton = {
        let termsButton = UIButton(type: .system)
        termsButton.titleLabel?.font = Styles.Fonts.callout
        termsButton.setTitleColor(Asset.textGray.color, for: .normal)
        termsButton.setTitle("Terms of use", for: .normal)
        termsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        termsButton.addAction(UIAction(handler: { [weak self] action in
            self?.presenter?.didEvent?(.terms)
        }), for: .touchUpInside)
        return termsButton
    }()
    private lazy var privacyButton: UIButton = {
        let privacyButton = UIButton(type: .system)
        privacyButton.titleLabel?.font = Styles.Fonts.callout
        privacyButton.setTitleColor(Asset.textGray.color, for: .normal)
        privacyButton.setTitle("Privacy Policy", for: .normal)
        privacyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        privacyButton.addAction(UIAction(handler: { [weak self] action in
            self?.presenter?.didEvent?(.privacy)
        }), for: .touchUpInside)
        return privacyButton
    }()
    private lazy var dismissButton: UIButton = {
        let dismissButton = UIButton(type: .system)
        dismissButton.tintColor = .white
        dismissButton.setImage(Asset.dismiss.image, for: .normal)
        dismissButton.addAction(UIAction(handler: { [weak self] actions in
            self?.presenter?.didEvent?(.dismiss)
        }), for: .touchUpInside)
        return dismissButton
    }()
    
    var presenter: PaywallPresenterInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.presenter?.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        self.view.backgroundColor = Asset.backgroundColor.color
        
        let contentView = UIView()
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
        
        let vStack = ViewFactory.stack(.vertical, spacing: 40)
        contentView.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let titleContainerView = UIView()
        titleContainerView.addSubview(titleView)
        titleContainerView.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.size.equalTo(44)
        }
        self.titleView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let hStack = ViewFactory.stack(.horizontal, spacing: 8)
        
        hStack.addArrangedSubview(termsButton)
        hStack.addArrangedSubview(UIView())
        hStack.addArrangedSubview(privacyButton)
        
        bottomStack.addArrangedSubview(actionButton)
        bottomStack.addArrangedSubview(hStack)
        
        vStack.addArrangedSubview(titleContainerView)
        vStack.addArrangedSubview(contentStack)
        vStack.addArrangedSubview(bottomStack)
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

extension CommonPaywallViewController: PaywallView {
    
    func dismiss() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    func display(products: [ProductDTO], paywallLocalize: PaywallLocalize?) {
        contentStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        self.productViews.removeAll()
        
        contentStack.spacing = 10
        products.forEach { product in
            let productView = ProductView()
            productView.configure(product: product)
            productView.didAction = { [weak self] in
                self?.presenter?.productDidSelect(id: product.id)
            }
            productView.snp.makeConstraints { make in
                make.height.equalTo(78)
            }
            contentStack.addArrangedSubview(productView)
            self.productViews.append(productView)
        }
        
        if let paywallLocalize = paywallLocalize {
            self.titleLabel.text = paywallLocalize.titleString
            self.subtitleLabel.text = paywallLocalize.descriptionString
            self.actionButton.setTitle(paywallLocalize.actionButtonString, for: .normal)
            self.termsButton.setTitle(paywallLocalize.termsOfUseString, for: .normal)
            self.privacyButton.setTitle(paywallLocalize.privacyPolicyString, for: .normal)
        }
    }
    
    func display(productDescription: String, dismissDelay: Int, paywallLocalize: PaywallLocalize?) {
        self.descriptionLabel.text = productDescription
        self.dismissButton.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(dismissDelay), execute: {
            self.dismissButton.isHidden = false
        })
        
        if let paywallLocalize = paywallLocalize {
            self.titleLabel.text = paywallLocalize.titleString
            self.subtitleLabel.text = paywallLocalize.descriptionString
            self.actionButton.setTitle(paywallLocalize.actionButtonString, for: .normal)
            self.termsButton.setTitle(paywallLocalize.termsOfUseString, for: .normal)
            self.privacyButton.setTitle(paywallLocalize.privacyPolicyString, for: .normal)
        }
    }
    
}
