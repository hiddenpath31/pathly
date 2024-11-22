//
//  FunnelFlowScanPhoneViewController.swift
//  GrowVPN
//
//  Created by Александр on 29.08.2024.
//

import UIKit
import JGProgressHUD
import ScreenshotPreventing

class FunnelFlowScanPhoneViewController: UIViewController {

    var presenter: FunnelFlowPresenterInterface?
    var funnelView = FunnelFlowScanPhoneView()
    lazy var screenshotPreventView = ScreenshotPreventingView(contentView: funnelView)
    
    var hud: JGProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        presenter?.viewDidLoad()
//        ScreenShield.shared.protect(view: self.view)
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        view.addSubview(screenshotPreventView)
        screenshotPreventView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(12)
        }
        
    }
    
    private func setupBindings() {
        funnelView.didNextTap = { [weak self] in
            self?.presenter?.nextIteration()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewDidEnterBackgroundNotification),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil, queue: OperationQueue.main
        ) { [weak self] notification in
            self?.presenter?.viewCaptureScreen()
            print("Screenshot taken!")
        }
        NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil, queue: OperationQueue.main
        ) { [weak self] notification in
            self?.presenter?.viewCaptureScreen()
            print("Screenshot taken!")
        }
    }
    
    @objc
    private func viewDidEnterBackgroundNotification() {
        self.presenter?.viewDidEnterBackground()
    }
    
    func showTryAgainError() {
        let protectionError = ProtectionError(title: Localize.Error.TryAgain.title,
                                              subtitle: Localize.Error.TryAgain.subtitle,
                                              buttonTitle: Localize.Error.TryAgain.okButton)

        let alertController = UIAlertController(error: protectionError) { [weak self] in
            self?.presenter?.subscribe()
        }
        
        present(alertController, animated: true, completion: nil)
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

extension FunnelFlowScanPhoneViewController: FunnelFlowView {
    
    func show(_ error: Error) {
        let alert = UIAlertController(
            title: L10n.error,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showRCAlert(alert: FailAlert) {
        let protectionError = ProtectionError(title: alert.title,
                                              subtitle: alert.description,
                                              buttonTitle: alert.okButton)

        let alertController = UIAlertController(error: protectionError) { [weak self] in
            self?.presenter?.subscribe()
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func show(iteration: FunnelScanPhoneIterationModel) {
        self.funnelView.configure(iteration: iteration)
    }
    
    func initial(firstIteration: FunnelScanPhoneIterationModel) {
        self.funnelView.configure(iteration: firstIteration)
    }
    
    func showHUD() {
        self.hud = JGProgressHUD(style: .dark)
        self.hud?.show(in: view)
    }
    
    func hideHUD() {
        self.hud?.dismiss()
    }
    
}
