//
//  MainTabBarController.swift
//  UdhaarlyApp
//
//  Created by Antigravity on 11/03/2026.
//

import UIKit

class MainTabBarController: UITabBarController {

    private let middleButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        btn.backgroundColor = .brandOrange
        btn.layer.cornerRadius = 32
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold)
        btn.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        btn.addDropShadow(color: .brandOrange, opacity: 0.5, radius: 8, offset: CGSize(width: 0, height: 4))
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupMiddleButton()
        customizeAppearance()
    }

    private func setupTabs() {
        let homeVC = DashboardViewController()
        let chatsVC = ChatsViewController()
        let userVC = UserSettingViewController()
        let myAdsVC = MyAdsViewController()

        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        chatsVC.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "bubble.left"), tag: 1)
        // Middle button space holder
        let middlePlaceholder = UIViewController()
        middlePlaceholder.tabBarItem = UITabBarItem(title: "", image: nil, tag: 2)
        middlePlaceholder.tabBarItem.isEnabled = false
        
        userVC.tabBarItem = UITabBarItem(title: "User", image: UIImage(systemName: "person"), tag: 3)
        myAdsVC.tabBarItem = UITabBarItem(title: "My Ads", image: UIImage(systemName: "square.grid.2x2"), tag: 4)

        viewControllers = [
            UINavigationController(rootViewController: homeVC),
            UINavigationController(rootViewController: chatsVC),
            middlePlaceholder,
            UINavigationController(rootViewController: userVC),
            UINavigationController(rootViewController: myAdsVC)
        ]
    }

    private func setupMiddleButton() {
        middleButton.center = CGPoint(x: tabBar.bounds.width / 2, y: 0)
        middleButton.addTarget(self, action: #selector(didTapMiddleButton), for: .touchUpInside)
        tabBar.addSubview(middleButton)
    }

    private func customizeAppearance() {
        tabBar.tintColor = .brandOrange
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .white
        
        // Remove top border/line
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 10
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
    }

    @objc private func didTapMiddleButton() {
        let alert = UIAlertController(title: "Add New Product", message: "Would you like to post a new advertisement?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add Product", style: .default, handler: { [weak self] _ in
            let addProductVC = AddProductViewController()
            let nav = UINavigationController(rootViewController: addProductVC)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true)
        }))
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Ensure middle button stays centered after layout changes
        middleButton.center = CGPoint(x: tabBar.bounds.width / 2, y: 5)
    }
}
