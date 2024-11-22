//
//  FunnelLoaderViewController.swift
//  GrowVPN
//
//  Created by Александр on 27.08.2024.
//

import UIKit
import SnapKit

class FunnelLoaderViewController: UIViewController {

    var didLoad: (() -> Void)?
    
//    private lazy var loaderView: UIImageView = {
//        var view = UIImageView(image: UIImage(named: "funnel-loader"))
//        return view
//    }()
    private lazy var activityView: UIActivityIndicatorView = {
        var view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        self.view.backgroundColor = .black
        self.view.addSubview(self.activityView)
        self.activityView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(134)
        }
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + .seconds(2),
            execute: { [weak self] in
                self?.didLoad?()
            }
        )
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
