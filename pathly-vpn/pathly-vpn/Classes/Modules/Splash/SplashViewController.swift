//
//  SplashViewController.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import UIKit
import SnapKit

protocol SplashView: AnyObject {
    var presenter: SplashPresenterInterface? { get set }
    
    func updateUI(mode: SplashMode)
}

class SplashViewController: UIViewController {

    var presenter: SplashPresenterInterface?
    
    private lazy var activityView: UIActivityIndicatorView = {
        var view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter?.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func organicSetupUI() {
        self.view.backgroundColor = Asset.backgroundColor.color
        
        let vStack = ViewFactory.stack(.vertical, spacing: 0)
        self.view.addSubview(vStack)
        vStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(150)
        }
        
        let logoView = UIImageView(image: Asset.logo.image)
        logoView.contentMode = .scaleAspectFit
        vStack.addArrangedSubview(logoView)
        
        let pageControlView = PageProgressView()
        let progressContainer = UIView()
        progressContainer.addSubview(pageControlView)
        vStack.addArrangedSubview(progressContainer)
        pageControlView.snp.makeConstraints { make in
            make.width.equalTo(125)
            make.centerX.top.bottom.equalToSuperview()
            make.height.equalTo(8)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            pageControlView.fill(duration: 1.25)
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
                self.presenter?.viewDidFinish()
            }
        }
    }
    
    private func funnelSetupUI() {
        self.view.addSubview(self.activityView)
        self.activityView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(134)
        }
    }
    
    private func setupUI() {
        self.view.backgroundColor = .black
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

extension SplashViewController: SplashView {
    
    func updateUI(mode: SplashMode) {
        switch mode {
            case .organic:
                self.organicSetupUI()
            case .funnel:
                self.funnelSetupUI()
        }
    }
    
}
