//
//  OnboardPresenter.swift
//  pathly-vpn
//
//  Created by Александр on 07.11.2024.
//

import UIKit

typealias CompletionOnboardEvent = ((OnboardEvent) -> Void)
enum OnboardEvent {
    case next
    case back
    case dismiss
}

protocol OnboardPresenterInterface: UICollectionViewDataSource {
    var view: OnboardView? { get set } 
    var didFinish: Completion? { get set }
    var didEvent: CompletionOnboardEvent? { get set }
    
    func viewDidLoad()
}

class OnboardPresenter: NSObject {
    weak var view: OnboardView?
    var didEvent: CompletionOnboardEvent?
    var didFinish: Completion?
    
    private var onboardingItems = OnboardItem.allCases
    private var selectIndex: Int = 0 {
        didSet {
            self.view?.updateUI(backEnable: selectIndex > 0)
        }
    }
    
    init(view: OnboardView) {
        self.view = view
    }
}

extension OnboardPresenter: OnboardPresenterInterface {
    
    func viewDidLoad() {
        self.didEvent = { [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            switch event {
                case .back:
                    if strongSelf.selectIndex > 0 {
                        strongSelf.selectIndex -= 1
                        strongSelf.view?.unselect(index: strongSelf.selectIndex)
                    }
                case .dismiss:
                    self?.didFinish?()
                case .next:
                    if strongSelf.selectIndex < (strongSelf.onboardingItems.count - 1) {
                        strongSelf.selectIndex += 1
                        strongSelf.view?.select(index: strongSelf.selectIndex)
                    } else {
                        self?.didFinish?()
                    }
            }
        }
    }
    
}

extension OnboardPresenter {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.onboardingItems.count
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardCollectionViewCell", for: indexPath) as? OnboardCollectionViewCell {
            let item = self.onboardingItems[indexPath.item]
            cell.configure(item: item)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}
