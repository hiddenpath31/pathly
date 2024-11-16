//
//  DataPresenter.swift
//  pathly-vpn
//
//  Created by Александр on 08.11.2024.
//

import UIKit
import Combine

struct DataInfoDTO {
    var item: DataItem
    var dataString: String
}

protocol DataPresenterInterface: UITableViewDelegate, UITableViewDataSource {
    var view: DataView? { get set }
    
    func viewDidLoad()
    func checkDidTap()
}

class DataPresenter: NSObject {
    var view: DataView?
    
    private var cancellables = Set<AnyCancellable>()
    private var items: [DataInfoDTO] = DataItem.allCases.map { item in
        let info = DataInfoDTO(item: item, dataString: "-")
        return info
    }
    private var apiService: APINetworkServiceInterface
    
    init(view: DataView, apiService: APINetworkServiceInterface) {
        self.view = view
        self.apiService = apiService
    }
    
    private func getInfo(completion: ((Result<Info, ErrorResponse>) -> Void)?) {
        self.apiService.base.info().sink { completionHandler in
            switch completionHandler {
                case .failure(let error):
                    completion?(.failure(error))
                default:
                    break
            }
        } receiveValue: { response in
            completion?(.success(response))
        }.store(in: &cancellables)
    }
    
    private func getInfo() {
        self.view?.display(checkButtonEnable: false)
        self.getInfo { [weak self] result in
            self?.view?.display(checkButtonEnable: true)
            switch result {
                case .success(let info):
                    self?.items = info.toItems()
                    self?.view?.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
}

extension DataPresenter {
    
    func viewDidLoad() {
        self.getInfo()
    }
    
    func checkDidTap() {
        self.getInfo()
    }
    
}

extension DataPresenter: DataPresenterInterface {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DataCell.reuseIdentifier) as? DataCell {
            let item = self.items[indexPath.row]
            cell.configure(item: item)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
