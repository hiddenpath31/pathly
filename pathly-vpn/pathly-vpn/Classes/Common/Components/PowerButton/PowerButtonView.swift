//
//  PowerButtonView.swift
//  pathly-vpn
//
//  Created by Александр on 15.11.2024.
//

import UIKit

class PowerButtonView: UIView {
    
    struct PowerButtonConfiguration {
        var title: NSAttributedString
        var glowEnable: Bool
        var powerEnable: Bool
    }
    
    var didTap: Completion?
    
    private lazy var circularView: CircularProgress = {
        var view = CircularProgress()
        view.trackThickness = 0.15
        view.progressThickness = 0.15
        view.startAngle = -90
        view.glowMode = .constant
        view.glowAmount = 24
        view.trackColor = Asset.textGray.color
        view.roundedCorners = false
        view.trackColor = Asset.vpnBackColor.color
        view.progressColors = [Asset.accentColor.color]
        return view
    }()
    private lazy var coverView: UIView = {
        var view = UIView()
        view.backgroundColor = Asset.gray.color
        return view
    }()
    private lazy var powerLogoView: UIImageView = {
        let power = UIImageView(image: Asset.vpnPower.image)
        return power
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
        
        circularView.layoutIfNeeded()
        coverView.layoutIfNeeded()
        coverView.cornered()
    }
    
    private func common() {
        let containerView = UIView()
        self.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(circularView)
        circularView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(coverView)
        coverView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(38)
        }
        containerView.addSubview(powerLogoView)
        powerLogoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(onDidRecognizeTap(recognizer:))
        )
        containerView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc
    private func onDidRecognizeTap(recognizer: UITapGestureRecognizer) {
        self.didTap?()
        
//        switch recognizer.state {
//        case .began, .ended:
//                self.coverView.backgroundColor = Asset.vpnBackColor.color
//            default:
//                self.coverView.backgroundColor = Asset.gray.color
//        }
    }
    
    func animate() {
        circularView.animate(fromAngle: 0, toAngle: 360, duration: 7, completion: nil)
    }
    
    func apply(config: ConnectionStatus) {
        switch config {
        case .connect:
            self.powerLogoView.tintColor = Asset.accentColor.color
            if self.circularView.progress == 0 {
                self.circularView.animate(toAngle: 360, duration: 0, completion: nil)
            } else if self.circularView.progress > 0 && self.circularView.progress < 1 {
                self.circularView.animate(toAngle: 360, duration: 0.5, completion: nil)
            }
        case .connection:
            self.powerLogoView.tintColor = Asset.textGray.color
            self.circularView.animate(toAngle: 330, duration: 3) { complete in
                //
            }
        case .disconnect:
            self.powerLogoView.tintColor = Asset.textGray.color
            self.circularView.stopAnimation_generalManufactor()
        case .fail:
            self.powerLogoView.tintColor = Asset.textGray.color
            self.circularView.stopAnimation_generalManufactor()
        }
    }
    
}
