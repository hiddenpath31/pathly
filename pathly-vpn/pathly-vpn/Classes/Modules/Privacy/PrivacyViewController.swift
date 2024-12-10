//
//  PrivacyViewController.swift
//  pathly-vpn
//
//  Created by Александр on 10.11.2024.
//

import UIKit

class PrivacyViewController: UIViewController {

    var didDismiss: Completion?
    
    private lazy var textView: UITextView = {
        var view = UITextView()
        view.font = FontFamily.SFProText.regular.font(size: 18)
        view.backgroundColor = .clear
        view.textColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.didDismiss?()
    }
    
    private func setupUI() {
        self.navigationItem.title = L10n.Settings.privacyPolicy
        self.view.backgroundColor = Asset.backgroundColor.color
        
        self.view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
        }
        textView.text = Constants.Support.privacyContent
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
