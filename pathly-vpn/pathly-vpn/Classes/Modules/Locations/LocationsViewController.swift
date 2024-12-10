//
//  LocationsViewController.swift
//  pathly-vpn
//
//  Created by Александр on 08.11.2024.
//

import UIKit

protocol LocationsView: AnyObject, Paylable {
    var presenter: LocationsPresenterInterface? { get set }
    
    func reload()
    func hideKeyboard()
}

class LocationsViewController: UIViewController {

    var presenter: LocationsPresenterInterface?
    
    private lazy var tableView: UITableView = {
        var view = UITableView(frame: .zero, style: .plain)
        view.separatorColor = Asset.separatorColor.color
        view.backgroundColor = .clear
        view.register(LocationCell.self, forCellReuseIdentifier: LocationCell.reuseIdentifier)
        view.dataSource = presenter
        view.delegate = presenter
        return view
    }()
    private lazy var searchField: UITextField = {
        var view = UITextField()
        view.font = FontFamily.SFProText.regular.font(size: 13)
        view.textColor = .white
        view.attributedPlaceholder = L10n.Locations.searchLocations.attr
            .fonted(FontFamily.SFProText.regular.font(size: 13))
            .colored(Asset.textGray.color)
        view.delegate = self
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = L10n.Locations.location
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBindings()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        self.view.backgroundColor = Asset.backgroundColor.color
        
        let searchView = UIView()
        searchView.layer.cornerRadius = 10
        searchView.layer.borderWidth = 0.5
        searchView.layer.borderColor = Asset.textGray.color.cgColor
        
        let hStack = ViewFactory.stack(.horizontal, spacing: 8)
        let searchIconView: UIImageView = {
            let view = UIImageView()
            view.image = UIImage(systemName: "magnifyingglass")
            view.tintColor = Asset.textGray.color
            view.contentMode = .scaleAspectFit
            view.snp.makeConstraints { make in
                make.width.equalTo(22)
            }
            return view
        }()
        
        searchView.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        hStack.addArrangedSubview(searchIconView)
        hStack.addArrangedSubview(searchField)
        
        self.view.addSubview(searchView)
        self.view.addSubview(tableView)
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(8)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(36)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupBindings() {
        self.searchField.addTarget(
            self, action: #selector(searchTextChanged),
            for: .editingChanged
        )
    }
    
    @objc
    private func searchTextChanged() {
        self.presenter?.searchDidChange(string: self.searchField.text)
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

extension LocationsViewController: LocationsView {
    
    func reload() {
        self.tableView.reloadData()
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
}

extension LocationsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
    
}
