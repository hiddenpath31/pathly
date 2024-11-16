//
//  TabViewController.swift
//  odola-app
//
//  Created by Александр on 27.09.2024.
//

import UIKit

class TabNavigationController: UINavigationController {

    private let tabItem: TabItem
    
    init(tab: TabItem, root: UIViewController) {
        self.tabItem = tab
        super.init(rootViewController: root)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        self.tabBarItem.title = self.tabItem.title
        self.tabBarItem.image = self.tabItem.icon
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
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
