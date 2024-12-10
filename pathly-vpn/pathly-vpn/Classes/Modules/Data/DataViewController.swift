//
//  DataViewController.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import UIKit

protocol DataView: AnyObject {
    var presenter: DataPresenterInterface? { get set }
    
    func display(checkButtonEnable: Bool)
    func reloadData()
}

class DataViewController: UIViewController {

    var presenter: DataPresenterInterface?
    
    private lazy var tableView: UITableView = {
        var view = UITableView(frame: .zero, style: .plain)
        view.register(DataCell.self, forCellReuseIdentifier: DataCell.reuseIdentifier)
        view.delegate = presenter
        view.dataSource = presenter
        view.separatorColor = Asset.separatorColor.color
        view.separatorInset.left = 36
        view.backgroundColor = .clear
        return view
    }()
    private lazy var checkButton: UIButton = {
        let button = ViewFactory.Buttons.base()
        button.setTitle(L10n.Data.checkIPData, for: .normal)
        button.addAction(UIAction(handler: { [weak self] action in
            self?.presenter?.checkDidTap()
        }), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        presenter?.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        self.view.backgroundColor = Asset.backgroundColor.color
        self.navigationItem.title = L10n.Data.ipData
        
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
        self.view.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(self.tableView.snp.bottom)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(36)
            make.height.equalTo(56)
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

extension DataViewController: DataView {
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func display(checkButtonEnable: Bool) {
        self.checkButton.isEnabled = checkButtonEnable
    }
    
}
