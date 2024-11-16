//
//  PageControlView.swift
//  odola-app
//
//  Created by Александр on 11.09.2024.
//

import UIKit
import SnapKit

class PageControlView: UIView {

    var pages: Int
    
    private lazy var hStack: UIStackView = {
        var view = UIStackView()
        view.spacing = 12
        view.distribution = .fillEqually
        view.axis = .horizontal
        return view
    }()
    
    init(numberOfPages: Int) {
        self.pages = numberOfPages
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func common() {
        self.addSubview(hStack)
        
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        for _ in 0...pages {
            let progressView = PageProgressView()
            hStack.addArrangedSubview(progressView)
        }
    }
    
    func configure(numberOfPages: Int) {
        self.pages = numberOfPages
        self.hStack.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        for _ in 1...pages {
            let progressView = PageProgressView()
            progressView.backColor = .white
            progressView.progressColor = Asset.accentColor.color
            progressView.layer.cornerRadius = 8
            hStack.addArrangedSubview(progressView)
        }
    }
    
    func fill(page: Int) {
        if self.hStack.arrangedSubviews.count > page {
            if let subView = hStack.arrangedSubviews[page] as? PageProgressView {
                subView.fill(duration: 0.25)
            }
        }
    }
    
    func unfill(page: Int) {
        if self.hStack.arrangedSubviews.count > page {
            if let subView = hStack.arrangedSubviews[page] as? PageProgressView {
                subView.unfill()
            }
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

class PageProgressView: UIView {
    
    private lazy var backView: UIView = {
        var view = UIView()
        view.backgroundColor = self.backColor
        return view
    }()
    private lazy var progressView: UIView = {
        var view = UIView()
        view.backgroundColor = self.progressColor
        return view
    }()
    
    var backColor: UIColor = .white {
        didSet {
            self.backView.backgroundColor = self.backColor
        }
    }
    var progressColor: UIColor = Asset.accentColor.color {
        didSet {
            self.progressView.backgroundColor = self.progressColor
        }
    }
    
    init() {
        super.init(frame: .zero)
        common()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backView.layoutIfNeeded()
        self.progressView.layoutIfNeeded()
        self.progressView.layer.cornerRadius = self.progressView.frame.height / 2
        self.backView.layer.cornerRadius = self.backView.frame.height / 2
    }
    
    var progressContstraint: Constraint?
    
    private func common() {
        let containerView = UIView()
        
        self.addSubview(containerView)
        containerView.addSubview(backView)
        containerView.addSubview(progressView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        progressView.snp.makeConstraints { [weak self] make in
            make.left.top.bottom.equalToSuperview()
            self?.progressContstraint = make.width.equalTo(0).constraint
        }
    }
    
}

extension PageProgressView {
    
    func fill(duration: CGFloat) {
        self.progressView.snp.updateConstraints({(make) in
            make.width.equalTo(self.frame.width)
        })
        UIView.animate(withDuration: duration) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    func unfill() {
        self.progressView.snp.updateConstraints({(make) in
            self.progressContstraint = make.width.equalTo(0).constraint
        })
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
}
