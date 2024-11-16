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

protocol PaywallView: AnyObject {
    var presenter: PaywallPresenterInterface? { get set }
    
    func dismiss()
    func display(products: [ProductDTO])
    func display(productDescription: String)
}

class CommonPaywallViewController: UIViewController {

    private var productViews: [ProductView] = []
    private lazy var titleView: UIView = {
        var vStack = ViewFactory.stack(.vertical, spacing: 40)
        
        let iconView = UIImageView(image: Asset.paywallCrown.image)
        iconView.contentMode = .scaleAspectFit
        iconView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }
        
        let titleLabel = ViewFactory.label(
            font: Styles.Fonts.largeTitle,
            color: .white
        )
        titleLabel.textAlignment = .center
        titleLabel.text = "Go Premium"
        
        let subtitleLabel = ViewFactory.label(
            font: Styles.Fonts.callout2,
            color: Asset.textGray.color
        )
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Unlock the full power of this mobile tool\nand enjoy a digital experience like never!"
        subtitleLabel.numberOfLines = 0
        
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
        let dismissButton = UIButton(type: .system)
        dismissButton.tintColor = .white
        dismissButton.setImage(Asset.dismiss.image, for: .normal)
        dismissButton.addAction(UIAction(handler: { [weak self] actions in
            self?.presenter?.didEvent?(.dismiss)
        }), for: .touchUpInside)
        titleContainerView.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.size.equalTo(44)
        }
        self.titleView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let actionButton = ViewFactory.Buttons.base()
        actionButton.setTitle("Start & Subscribe", for: .normal)
        actionButton.addAction(UIAction(handler: { [weak self] action in
            self?.presenter?.pay()
        }), for: .touchUpInside)
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        let hStack = ViewFactory.stack(.horizontal, spacing: 8)
        let termsButton = UIButton(type: .system)
        termsButton.titleLabel?.font = Styles.Fonts.callout
        termsButton.setTitleColor(Asset.textGray.color, for: .normal)
        termsButton.setTitle("Terms of use", for: .normal)
        termsButton.addAction(UIAction(handler: { [weak self] action in
            self?.presenter?.didEvent?(.terms)
        }), for: .touchUpInside)
        
        let privacyButton = UIButton(type: .system)
        privacyButton.titleLabel?.font = Styles.Fonts.callout
        privacyButton.setTitleColor(Asset.textGray.color, for: .normal)
        privacyButton.setTitle("Privacy Policy", for: .normal)
        privacyButton.addAction(UIAction(handler: { [weak self] action in
            self?.presenter?.didEvent?(.privacy)
        }), for: .touchUpInside)
        
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
    
    func display(products: [ProductDTO]) {
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
    }
    
    func display(productDescription: String) {
        self.descriptionLabel.text = productDescription
    }
    
}
