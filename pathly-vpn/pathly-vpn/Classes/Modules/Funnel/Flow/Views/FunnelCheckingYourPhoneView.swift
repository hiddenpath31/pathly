//
//  FunnelCheckingYourPhoneView.swift
//  GrowVPN
//
//  Created by Александр on 28.08.2024.
//

import UIKit
import  Lottie

//enum FunnelCheckStatus {
//    case error
//    case warning
//    case checkover
//    case firstCheck
//    case secondCheck
//    
//    var title: String {
//        switch self {
//            case .error:
//                return "Your iPhone\nis hight risk"
//            case .warning:
//                return "Warning!\nDo not delete this app"
//            case .checkover:
//                return "Check is\nover"
//            case .firstCheck:
//                return "Checking your\niPhone"
//            case .secondCheck:
//                return "What will be closed when using VPN"
//        }
//    }
//    var icon: UIImage? {
//        switch self {
//            case .error:
//                return UIImage(named: "funnel-check-error")
//            case .warning:
//                return UIImage(named: "funnel-check-warning")
//            case .checkover:
//                return UIImage(named: "funnel-check-success")
//            case .firstCheck:
//                return nil
//            case .secondCheck:
//                return nil
//        }
//    }
//    var buttonTitle: String {
//        switch self {
//            case .error:
//                return "Clean my iPhone"
//            case .warning:
//                return "OK"
//            case .checkover:
//                return "Done"
//            case .firstCheck:
//                return "Checking your\niPhone"
//            case .secondCheck:
//                return "What will be closed when using VPN"
//        }
//    }
//}
//
//struct FunnelCheckingItem {
//    var icon: UIImage?
//    var warnings: [FunnelCheckingWarning]
//    
//    static func wrongItems() -> [FunnelCheckingItem] {
//        let item = FunnelCheckingItem(
//            icon: UIImage(named: "funnel-bug"),
//            warnings: [FunnelCheckingWarning(title: "PUF.Match.Cache", type: .warning),
//                       FunnelCheckingWarning(title: "PUF.Match.Cache", type: .warning),
//                       FunnelCheckingWarning(title: "PUF.Match.Cache", type: .warning)]
//        )
//        
//        let item2 = FunnelCheckingItem(
//            icon: UIImage(named: "funnel-eye"),
//            warnings: [FunnelCheckingWarning(title: "PUF.Match.Cache.Crashlyst", type: .warning),
//                       FunnelCheckingWarning(title: "PUF.Match.Cache.Cleanup", type: .warning),
//                       FunnelCheckingWarning(title: "PUF.Mac.Lagent", type: .warning),
//                       FunnelCheckingWarning(title: "PUF.Mac.Cleanup", type: .warning),
//                       FunnelCheckingWarning(title: "PUF.Mac.Lagent", type: .warning)]
//        )
//        return [item, item2]
//    }
//    
//    static func successItems() -> [FunnelCheckingItem] {
//        let item = FunnelCheckingItem(
//            icon: UIImage(named: "funnel-bug"),
//            warnings: [FunnelCheckingWarning(title: "PUF.Match.Cache", type: .success),
//                       FunnelCheckingWarning(title: "PUF.Match.Cache", type: .success),
//                       FunnelCheckingWarning(title: "PUF.Match.Cache", type: .success)]
//        )
//        
//        let item2 = FunnelCheckingItem(
//            icon: UIImage(named: "funnel-eye"),
//            warnings: [FunnelCheckingWarning(title: "PUF.Match.Cache.Crashlyst", type: .success),
//                       FunnelCheckingWarning(title: "PUF.Match.Cache.Cleanup", type: .success),
//                       FunnelCheckingWarning(title: "PUF.Mac.Lagent", type: .success),
//                       FunnelCheckingWarning(title: "PUF.Mac.Cleanup", type: .success),
//                       FunnelCheckingWarning(title: "PUF.Mac.Lagent", type: .success)]
//        )
//        return [item, item2]
//    }
//}
//
//struct FunnelCheckingWarning {
//    
//    enum FunnelCheckingWarningType {
//        case warning
//        case success
//        
//        var color: UIColor? {
//            switch self {
//            case .warning:
//                return UIColor(named: "red")
//            case .success:
//                return UIColor(named: "green")
//            }
//        }
//    }
//    
//    var title: String
//    var type: FunnelCheckingWarningType
//}

enum FunnelFlowCheckMode: String {
    case startChecking
    case checking
    case highRisk
    case establishing
    case checkover
    case warning
    case undefinded
    
    var icon: UIImage? {
        switch self {
            case .startChecking:
                return UIImage(named: "funnel-warning-device")
            case .checking:
                return nil
            case .highRisk:
                return UIImage(named: "funnel-check-error")
            case .establishing:
                return nil
            case .checkover:
                return UIImage(named: "funnel-check-success")
            case .warning:
                return UIImage(named: "funnel-check-warning")
            case .undefinded:
                return nil
        }
    }
    var animation: String? {
        switch self {
            case .checking, .establishing:
                return "scanning"
            default:
                return nil
        }
    }
}

class FunnelCheckWarningView: UIView {
    
    let maxLabel: Int = 4
    var contents: [UILabel] = []
    
    var availableString: String?
    var moreString: String?
    
    private lazy var containerIconView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(named: "red")
        return view
    }()
    private lazy var iconView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var vStack: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    private var moreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .red // warning.type.color
        label.isHidden = true
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
        
        self.containerIconView.layoutIfNeeded()
        self.containerIconView.layer.cornerRadius = self.containerIconView.frame.height / 2
    }
    
    func configure(item: FunnelCheck) {
        self.iconView.image = UIImage(named: item.key)
        self.containerIconView.backgroundColor = item.error
        self.titleLabel.text = "\(item.title ?? "") (0)"
        self.moreLabel.textColor = item.error
        
        if item.availableString != nil {
            self.availableString = item.availableString
        }
        if item.moreString != nil {
            self.moreString = item.moreString
        }
    }
    
    func addLabel(text: String, color: UIColor) {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = color
        label.text = text
        
        if self.contents.count > self.maxLabel {
            let contentCount: String = {
                var count = self.contents.count + 1
                return "\(count)"
            }()
            
            let available = self.availableString ?? "Available online"
            self.titleLabel.text = "\(available) (\(contentCount))"
            self.moreLabel.text = "\(self.contents.count - self.maxLabel) \(self.moreString ?? "more")"
            self.moreLabel.isHidden = false
        } else {
            vStack.insertArrangedSubview(label, at: 1)
        }
        
        self.contents.append(label)
    }
    
    func fill(color: UIColor, completion: (() -> Void)?) {
        var views = self.contents
        views.shuffle()
        
        let group = DispatchGroup()
        
        for (index, label) in views.enumerated() {
            group.enter()
            DispatchQueue.main.asyncAfter(
                deadline: .now() + .milliseconds(index*200),
                execute: {
                    group.leave()
                    label.textColor = color
                    let count = index + 1
                    let available = self.availableString ?? "Available online"
                    self.titleLabel.text = "\(available) (\(count))"
                }
            )
            
        }
        
        group.notify(
            queue: .main,
            execute: { [weak self] in
                self?.moreLabel.textColor = color
                self?.containerIconView.backgroundColor = color
                
                completion?()
            }
        )
    }
    
    private func common() {
        self.containerIconView.addSubview(self.iconView)
        
        self.addSubview(containerIconView)
        self.addSubview(vStack)
        
        containerIconView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.size.equalTo(32)
        }
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(20)
        }
        
        vStack.snp.makeConstraints { make in
            make.left.equalTo(containerIconView.snp.right).inset(-20)
            make.top.right.bottom.equalToSuperview()
        }
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(moreLabel)
    }
    
}

class FunnelCheckingYourPhoneView: FunnelContentView {
    
    var didCheckingOver: (() -> Void)?
    var actionButtonColor: UIColor = UIColor(red: 0/255, green: 123/255, blue: 254/255, alpha: 1)
    private let loadingInterval: CGFloat = 2
    

    init() {
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .white.withAlphaComponent(0.5)
        return label
    }()
    private lazy var actionTitleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    private lazy var activityStatusView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.tintColor = .white
        view.startAnimating()
        view.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        return view
    }()
//    private lazy var mainIconView: UIImageView = {
//        var view = UIImageView()
//        view.contentMode = .scaleAspectFit
//        view.snp.makeConstraints { make in
//            make.height.equalTo(94)
//        }
//        return view
//    }()
    private lazy var lottieIconView: LottieAnimationView = {
        var view = LottieAnimationView()
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        return view
    }()
    private lazy var statusImageView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        return view
    }()
//    private lazy var containerstatusImageView: UIImageView = {
//        var view = UIImageView()
//        return view
//    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    private lazy var vContentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    private lazy var actionButton: UIButton = {
        var button = UIButton(type: .system)
        button.tintColor = .white
        button.layer.cornerRadius = 14
        button.backgroundColor = self.actionButtonColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        button.addTarget(self, action: #selector(onDidTapAction), for: .touchUpInside)
        button.setTitle("Clean my iPhone", for: .normal)
        button.isHidden = true
        return button
    }()
    
    private lazy var statusLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        label.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        label.text = "Do not close this window."
        label.isHidden = false
        return label
    }()
    
    private func common() {

        self.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let containerStatusView = UIStackView()
        containerStatusView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        containerStatusView.axis = .horizontal
        containerStatusView.addArrangedSubview(activityStatusView)
        containerStatusView.addArrangedSubview(statusImageView)
        containerStatusView.addArrangedSubview(UIView())

        let spacingView = UIView()
        spacingView.tag = 999
        
        vStack.addArrangedSubview(containerStatusView)
        vStack.addArrangedSubview(titleLabel)
        vStack.setCustomSpacing(30, after: titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        vStack.addArrangedSubview(vContentStack)
        vStack.addArrangedSubview(spacingView)
        vStack.addArrangedSubview(statusLabel)
        vStack.addArrangedSubview(actionButton)
    }
    
//    func configure(status: FunnelCheckStatus, items: [FunnelCheckingItem]) {
//        self.statusType = status
//        self.vContentStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
//        
//        DispatchQueue.main.asyncAfter(
//            deadline: .now() + .seconds(Int(self.loadingInterval)),
//            execute: { [weak self] in
//                self?.loadItems(items)
//            }
//        )
//        
//    }
//    
    func configure(iteration: FunnelScanPhoneIterationModel) {
        if let attributedTitle = iteration.attributedTitle, let attributes = iteration.attributed() {
            let attributedString = NSAttributedString(string: iteration.title, attributes: attributes)
            self.titleLabel.attributedText = attributedString
        } else {
            self.titleLabel.attributedText = nil
            self.titleLabel.text = iteration.title
        }
        
        if let actionString = iteration.actionString {
            self.actionButton.setTitle(actionString, for: .normal)
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
        
        if let statusString = iteration.status {
            self.statusLabel.text = statusString
            self.statusLabel.isHidden = false
        } else {
            self.statusLabel.isHidden = true
        }
        
        if let mode = FunnelFlowCheckMode(rawValue: iteration.key) {
            if let icon = mode.icon {
                self.statusImageView.image = icon
                self.statusImageView.isHidden = false
                self.activityStatusView.isHidden = true
            } else {
                self.statusImageView.isHidden = true
                self.activityStatusView.isHidden = false
            }
            
            if let animation = mode.animation {
                self.lottieIconView.isHidden = false
                self.lottieIconView.animation = LottieAnimation.named(animation)
                self.lottieIconView.play()
            } else {
                self.lottieIconView.isHidden = true
            }

        }

        if let checks = iteration.checks {
            self.vContentStack.isHidden = false
            
            if iteration.key == "checking" {
                self.loadWarningChecks(
                    checks,
                    completion: { [weak self] in
                        self?.didNextTap?()
                    }
                )
            }
        } else {
            self.vContentStack.isHidden = true
        }
        
        if iteration.key == "establishing" {
            let color: UIColor = {
                return .green
            }()
            self.fillWarnings(color: color) { [weak self] in
                self?.didNextTap?()
            }
        }

    }
    
    var availableString: String?
    var moreString: String?
    
    private func loadWarningChecks(_ items: [FunnelCheck], completion: (() -> Void)?) {
        
        let group = DispatchGroup()
        
        for (jndex, item) in items.enumerated() {
            let fCheckView = FunnelCheckWarningView()
            
            fCheckView.configure(item: item)
            fCheckView.tag = jndex
            self.vContentStack.addArrangedSubview(fCheckView)
            let contents = item.contents
            let color = item.error
            
            for (index, item) in contents.enumerated() {
                group.enter()
                let random = Int.random(in: 50...150)
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + .milliseconds(index * random),
                    execute: { [weak self] in
                        fCheckView.addLabel(text: item, color: color)
                        group.leave()
                    }
                )
            }
        }
        
        group.notify(
            queue: .main,
            execute: { [weak self] in
                completion?()
            }
        )
        
    }
    
    func fillWarnings(color: UIColor, completion: (() -> Void)?) {
        let group = DispatchGroup()
        let fViews: [FunnelCheckWarningView] = self.vContentStack.arrangedSubviews.filter({ $0.isKind(of: FunnelCheckWarningView.self) == true }).compactMap({ $0 as? FunnelCheckWarningView })
        fViews.forEach { [weak self] v in
            group.enter()
            v.fill(
                color: color,
                completion: {
                    group.leave()
                }
            )
        }
        
        group.notify(
            queue: .main,
            execute: {
                completion?()
            }
        )
    }
    
    
//    private func loadItems(_ items: [FunnelCheckingItem]) {
//        
//        if let item = items.first {
//            let view = FunnelCheckWarningView()
//            view.configure(item: item)
//            vContentStack.addArrangedSubview(view)
//            var newItems = items.dropFirst()
//            
//            if newItems.count > 0 {
//                Timer.scheduledTimer(withTimeInterval: self.loadingInterval, repeats: false) { [weak self] timer in
//                    self?.loadItems(Array(newItems))
//                }
//            } else {
//                if self.statusType == .firstCheck {
//                    self.statusType = .error
//                }
//                if self.statusType == .secondCheck {
//                    self.statusType = .checkover
//                }
//                
//            }
//        }
//
//    }
    
    private func showErrorStatus() {
        self.statusLabel.isHidden = true
        self.actionButton.isHidden = false
    }
    
    private func updateStatus() {
//        self.titleLabel.text = self.statusType.title
//        self.statusImageView.image = self.statusType.icon
//        self.actionButton.setTitle(self.statusType.buttonTitle, for: .normal)
//        
//        if self.statusType.icon == nil {
//            self.activityStatusView.isHidden = false
//            self.statusImageView.isHidden = true
//            self.actionButton.isHidden = true
//            self.statusLabel.isHidden = false
//        } else {
//            self.activityStatusView.isHidden = true
//            self.statusImageView.isHidden = false
//            self.actionButton.isHidden = false
//            self.statusLabel.isHidden = true
//        }
    }
    
    @objc func onDidTapAction() {
        self.didNextTap?()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
