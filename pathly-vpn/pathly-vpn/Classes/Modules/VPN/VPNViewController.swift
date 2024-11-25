//
//  VPNViewController.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import UIKit

protocol VPNView: AnyObject, Alertable {
    var presenter: VPNPresenterInterface? { get set }
    
    func display(server: Server?)
    func updateUI(status: ConnectionStatus)
//    func updateUI(time: ConnectionStatus)
    func animate()
}

class VPNViewController: UIViewController {

    var presenter: VPNPresenterInterface?
    
    private lazy var powerView: PowerButtonView = {
        let view = PowerButtonView()
        return view
    }()
    private lazy var statusLabel: UILabel = {
        var label = UILabel()
        label.font = FontFamily.SFProText.medium.font(size: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    private lazy var countryView: CountryView = {
        var view = CountryView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        presenter?.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Pathly VPN"
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    private func setupUI() {
        self.view.backgroundColor = Asset.backgroundColor.color
        
        let contentView = UIView()
        
        self.view.addSubview(countryView)
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.countryView.snp.top)
        }
        self.countryView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(46)
        }
        self.countryView.configure(server: nil)
        
        contentView.addSubview(powerView)
        contentView.addSubview(statusLabel)
        powerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(300)
        }
        statusLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.powerView.snp.top).inset(-40)
        }
        powerView.didTap = { [weak self] in
            self?.presenter?.powerDidTap()
        }
        
        let clearButton = UIButton.init(type: .system)
        clearButton.addAction(UIAction(handler: { [weak self] action in
            self?.presenter?.clearFunnel()
        }), for: .touchUpInside)
        contentView.addSubview(clearButton)
        clearButton.snp.makeConstraints { make in
            make.left.equalTo(self.powerView.snp.right)
            make.right.equalToSuperview()
            make.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        self.countryView.didTap = { [weak self] in
            self?.presenter?.didShowCountry?()
        }
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

extension VPNViewController: VPNView {
    
    func animate() {
        powerView.animate()
    }
    
    func display(server: Server?) {
        self.countryView.configure(server: server)
    }
    
    func updateUI(status: ConnectionStatus) {
        self.statusLabel.attributedText = status.title
        self.powerView.apply(config: status)
    }
    
}
