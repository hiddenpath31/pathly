//
//  SettingsPresenter.swift
//  pathly-vpn
//
//  Created by Александр on 08.11.2024.
//

import UIKit

protocol SettingsPresenterInterface: UITableViewDelegate, UITableViewDataSource {
    var view: SettingsView? { get set }
}

class SettingsPresenter: NSObject {
    weak var view: SettingsView?
    private var items: [SettingItem] = SettingItem.allCases
    private var storeService: StoreServiceInterface
    
    init(view: SettingsView, storeService: StoreServiceInterface) {
        self.view = view
        self.storeService = storeService
    }
    
    private func handleDidSelect(item: SettingItem) {
        switch item {
            case .subscription:
                self.view?.showPaywall(
                    storeService: self.storeService,
                    type: .multy
                )
            case .support:
                self.view?.openMail(Constants.Support.email)
            case .privacy:
                self.view?.openURL(string: Constants.Support.policy)
            case .terms:
                self.view?.openURL(string: Constants.Support.terms)
        }
    }
    
}

extension SettingsPresenter: SettingsPresenterInterface {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseIdentifier) as? SettingCell {
            let item = self.items[indexPath.row]
            let cornerType: CellCorner = {
                if indexPath.row == 0 {
                    return .up
                }
                if indexPath.row >= (self.items.count - 1) {
                    return .down
                }
                
                return .none
            }()
            cell.configure(item: item, cornerType: cornerType)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        self.handleDidSelect(item: item)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

}
