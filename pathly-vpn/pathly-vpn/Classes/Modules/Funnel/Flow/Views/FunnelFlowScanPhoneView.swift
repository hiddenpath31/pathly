//
//  FunnelFlowScanPhoneView.swift
//  GrowVPN
//
//  Created by Александр on 29.08.2024.
//

import UIKit
import Lottie

enum FunnelFlowScanPhoneMode: String {
    case startScanning
    case scanning
    case highRisk
    case attention
    case undefinded
    
    var icon: UIImage? {
        switch self {
            case .startScanning:
                return UIImage(named: "funnel-start-scaning")
            case .scanning:
                return nil
            case .highRisk:
                return UIImage(named: "funel-scanning-highrisk")
            case .attention:
                return nil
            case .undefinded:
                return nil
        }
    }
    var fullIcon: UIImage? {
        switch self {
            case .attention:
                return  UIImage(named: "funnel-attention")
            default:
                return nil
        }
    }
    var animation: String? {
        switch self {
            case .scanning:
                return "scanning"
            default:
                return nil
        }
    }
}

final class FunnelFlowScanPhoneView: FunnelContentView {
    
//    var didNextTap: (() -> Void)?
    let contentAppearInterval: CGFloat = 0.5
    
    private lazy var contentView: UIView = {
        var view = UIView()
        return view
    }()
    private lazy var vStack: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    private lazy var contentStack: UIStackView = {
        var view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 10
        return view
    }()
    private lazy var contentScrollView: UIScrollView = {
        var view = UIScrollView()
        return view
    }()
    private lazy var fullIconView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.snp.makeConstraints { make in
            make.height.equalTo(250)
        }
        return view
    }()
    private lazy var mainIconView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.snp.makeConstraints { make in
            make.height.equalTo(94)
        }
        return view
    }()
    private lazy var lottieIconView: LottieAnimationView = {
        var view = LottieAnimationView()
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        return view
    }()
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor(named: "subtitle")
        return label
    }()
    private lazy var actionButton: UIButton = {
        var button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.tintColor = .white
        button.setBackgroundImage(UIImage(named: "funnel-gradient-button"), for: .normal)
        button.addTarget(self, action: #selector(onDidActionTap), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.height.equalTo(58)
        }
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func common() {
        self.addSubview(contentView)
        self.contentView.addSubview(vStack)
        
        contentScrollView.addSubview(self.contentStack)
        self.contentStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        vStack.addArrangedSubview(mainIconView)
        vStack.addArrangedSubview(lottieIconView)
        vStack.addArrangedSubview(fullIconView)
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        vStack.addArrangedSubview(contentScrollView)
        vStack.addArrangedSubview(actionButton)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        vStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(iteration: FunnelScanPhoneIterationModel) {
        if let attributedTitle = iteration.attributedTitle, let attributes = iteration.attributed() {
            let attributedString = NSAttributedString(string: iteration.title, attributes: attributes)
            self.titleLabel.attributedText = attributedString
        } else {
            self.titleLabel.attributedText = nil
            self.titleLabel.text = iteration.title
        }
        
        if let actionString = iteration.actionString {
            self.actionButton.setTitle(actionString.uppercased(), for: .normal)
            self.actionButton.isHidden = false
        } else {
            self.actionButton.isHidden = true
        }
        
        if let subtitle = iteration.subtitle {
            self.subtitleLabel.text = subtitle
            self.subtitleLabel.isHidden = false
        } else {
            self.subtitleLabel.isHidden = true
        }
        
        if let mode = FunnelFlowScanPhoneMode(rawValue: iteration.key) {
            if let icon = mode.icon {
                self.mainIconView.image = icon
                self.mainIconView.isHidden = false
            } else {
                self.mainIconView.isHidden = true
            }
            
            if let icon = mode.fullIcon {
                self.fullIconView.image = icon
                self.fullIconView.isHidden = false
            } else {
                self.fullIconView.isHidden = true
            }
            
            if let animation = mode.animation {
                self.lottieIconView.isHidden = false
                self.lottieIconView.animation = LottieAnimation.named(animation)
                self.lottieIconView.play()
            } else {
                self.lottieIconView.isHidden = true
            }

        }
        
        if let categories = iteration.scrollCategoryContent {
            self.contentStack.isHidden = false
            self.fillCategoryContent(categories: categories)
            return
        } else {
            self.contentStack.isHidden = true
        }
        
        if let strings = iteration.scrollContent {
            self.contentStack.isHidden = false
            self.fillScrollLabelContent(
                strings: strings,
                completion: { [weak self] in
                    self?.actionButton.isHidden = false
                })
            return
        } else {
            self.contentStack.isHidden = true
        }
        

    }
    
    func fillScrollLabelContent(strings: [String], completion: (() -> Void)?) {
        let group = DispatchGroup()
        
        self.contentStack.spacing = 10
        self.contentStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        for (index, string) in strings.enumerated() {
            let randomMiliseconds = Int.random(in: 100...500)
            
            group.enter()
            DispatchQueue.main.asyncAfter(
                deadline: .now() + .milliseconds(index * randomMiliseconds),
                execute: { [weak self] in
                    guard let weakSelf = self else { return }
                    
                    let label = weakSelf.createErrorLabel()
                    label.text = string
                    weakSelf.contentStack.addArrangedSubview(label)
                    
                    if weakSelf.contentScrollView.contentSize.height > weakSelf.contentScrollView.frame.height {
                        weakSelf.contentScrollView.scrollToBottom()
                    }

                    group.leave()
                }
            )
        }
        
        group.notify(queue: .main, execute: { [weak self] in
            completion?()
        })
    }
    
    func fillCategoryContent(categories: [FunnelCategoryModel]) {
        self.contentStack.spacing = 20
        self.contentStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        for (index, category) in categories.enumerated() {
//            let randomMiliseconds = Int.random(in: 100...500)
            DispatchQueue.main.asyncAfter(
                deadline: .now() + .milliseconds(index * 200),
                execute: { [weak self] in
                    guard let weakSelf = self else { return }
                    
                    let view = FunnelFlowScanPhoneRiskCategoryView(
                        icon: UIImage(named: category.icon ?? ""),
                        title: category.text)
                    
                    weakSelf.contentStack.addArrangedSubview(view)
                    
                    if weakSelf.contentScrollView.contentSize.height > weakSelf.contentScrollView.frame.height {
                        weakSelf.contentScrollView.scrollToBottom()
                    }
                    
//                    if strings.count - 1 == index {
//                        completion?()
//                    }
                }
            )
        }
    }
    
    private func createErrorLabel() -> UILabel {
        var label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .red
        return label
    }
    
    @objc
    private func onDidActionTap() {
        self.didNextTap?()
    }
    
}

extension UIScrollView {
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.height + self.contentInset.bottom)
        self.setContentOffset(bottomOffset, animated: true)
    }
    
}
