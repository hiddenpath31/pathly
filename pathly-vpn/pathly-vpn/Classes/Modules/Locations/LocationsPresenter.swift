//
//  LocationsPresenter.swift
//  pathly-vpn
//
//  Created by Александр on 08.11.2024.
//

import UIKit

protocol LocationsPresenterInterface: AnyObject, UITableViewDelegate, UITableViewDataSource {
    var view: LocationsView? { get set }
        
    func viewDidLoad()
    func searchDidChange(string: String?)
}

class LocationsPresenter: NSObject {
    weak var view: LocationsView?
    var didShowPremium: Completion?
    
    private var storageService: StorageServiceInterface
    private var storeService: StoreServiceInterface
    private var servers: [Server]
    private var searchText: String? {
        didSet {
            guard let searchText = searchText, searchText.isEmpty == false else {
                self.servers = storageService.servers ?? []
                self.view?.reload()
                return
            }
            
            self.servers = storageService.servers?.filter({ $0.name.contains(searchText) }) ?? []
            self.view?.reload()
        }
    }
    
    init(view: LocationsView, storageService: StorageServiceInterface, storeService: StoreServiceInterface) {
        self.view = view
        self.storageService = storageService
        self.storeService = storeService
        self.servers = storageService.servers ?? []
    }
    
}

extension LocationsPresenter {
    
    func viewDidLoad() {
        //
    }
    
}

extension LocationsPresenter: LocationsPresenterInterface {
    
    func searchDidChange(string: String?) {
        self.searchText = string
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.servers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseIdentifier) as? LocationCell {
            let server = self.servers[indexPath.item]
            let detail: ServerDetailStyle = {
                if self.storeService.hasUnlockedPro == true {
                    return self.storageService.currentLocationId == "\(server.id)" ? .select : .unselect
                } else {
                    if server.premium == true {
                        return .primary
                    } else {
                        return self.storageService.currentLocationId == "\(server.id)" ? .select : .unselect
                    }
                }
            }()
            cell.configure(item: server, detail: detail)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let server = self.servers[indexPath.row]
        self.view?.hideKeyboard()
        
        if server.premium == true && self.storeService.hasUnlockedPro == false {
            self.view?.showPaywall(storeService: self.storeService, type: .single)
            return
        }
        
        self.storageService.currentLocationId = "\(server.id)"
        tableView.reloadData()
    }
    
}
