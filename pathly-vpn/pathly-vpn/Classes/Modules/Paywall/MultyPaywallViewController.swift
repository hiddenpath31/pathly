//
//  MultyPaywallViewController.swift
//  pathly-vpn
//
//  Created by Александр on 10.11.2024.
//

import UIKit

class ProductView: UIView {
    
    var id: String?
    var didAction: Completion?
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.separatorColor.color
        view.cornered(radius: 16)
        return view
    }()
    private lazy var titleLabel: UILabel = {
        var label = ViewFactory.label(
            font: Styles.Fonts.title2,
            color: .white
        )
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        var label = ViewFactory.label(
            font: Styles.Fonts.footnote,
            color: Asset.lightGray.color
        )
        return label
    }()
    private lazy var priceLabel: UILabel = {
        var label = ViewFactory.label(
            font: Styles.Fonts.title2,
            color: .white
        )
        label.textAlignment = .right
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        var label = ViewFactory.label(
            font: Styles.Fonts.footnote,
            color: Asset.lightGray.color
        )
        label.textAlignment = .right
        return label
    }()
    private lazy var actionButton: UIButton = {
        var button = UIButton(type: .custom)
        button.addAction(UIAction(handler: { [weak self] action in
            self?.didAction?()
        }), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func select() {
        self.contentView.bordered(color: Asset.accentColor.color, width: 2)
    }
    
    private func unselect() {
        self.contentView.unbordered()
    }
    
    private func common() {
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let leftVStack = ViewFactory.stack(.vertical, spacing: 6)
        let rightVStack = ViewFactory.stack(.vertical, spacing: 6)
        
        let hStack = ViewFactory.stack(.horizontal, spacing: 12)
        
        contentView.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        hStack.addArrangedSubview(leftVStack)
        hStack.addArrangedSubview(rightVStack)
        
        leftVStack.addArrangedSubview(titleLabel)
        leftVStack.addArrangedSubview(subtitleLabel)
        rightVStack.addArrangedSubview(priceLabel)
        rightVStack.addArrangedSubview(descriptionLabel)
        
        contentView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(product: ProductDTO) {
        self.id = product.id
        self.titleLabel.text = product.name
        if let description = product.description, description.isEmpty == false {
            self.descriptionLabel.isHidden = false
            self.descriptionLabel.text = description
        } else {
            self.descriptionLabel.isHidden = true
        }
        if let trial = product.displayTrial {
            self.subtitleLabel.isHidden = false
            self.subtitleLabel.text = trial
        } else {
            self.subtitleLabel.isHidden = true
        }
        self.priceLabel.text = product.localizedPrice
        
        product.isSelected ? self.select() : self.unselect()
    }
    
}

class MultyPaywallViewController: CommonPaywallViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        
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

