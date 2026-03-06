//
//  HomeViewController.swift
//  UdhaarlyApp
//
//  Created by Tadian Ahmad Azeemi on 23/02/2026.
//

import UIKit

class HomeViewController: UIViewController {
    private var logoImageUI = UIImageView()
    private var bottomViewTopConstraint: NSLayoutConstraint?
    private let bottomViewHeight: CGFloat = 200

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageUI.image = UIImage(resource: .udhaarlyLogo)
        logoImageUI.clipsToBounds = true
        logoImageUI.contentMode = .scaleAspectFit
        
        view.backgroundColor = UIColor(red: 255/255, green: 245/255, blue: 235/255, alpha: 1.0)
        view.addSubview(logoImageUI)
        logoImageUI.translatesAutoresizingMaskIntoConstraints = false
        logoImageUI.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageUI.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoImageUI.widthAnchor.constraint(equalToConstant: 220).isActive = true
        
        setupBottomView()
    }
    
    /*private func setupSwipeGesture(){
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeUp))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
    }*/
    
    @objc private func didSwipeUp(){
        let signupVC = SignupViewController()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    private func setupBottomView(){
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.layer.cornerRadius = 30
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //        bottomView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        //        bottomView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.layer.shadowColor = UIColor.black.cgColor
        bottomView.layer.shadowOpacity = 0.2
        bottomView.layer.shadowOffset = CGSize(width: 0, height: -4)
        bottomView.layer.shadowRadius = 10
        bottomView.layer.masksToBounds = false
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        bottomView.addGestureRecognizer(panGesture)
        
        view.addSubview(bottomView)
        
        let topConstraint = bottomView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomViewHeight)
        bottomViewTopConstraint = topConstraint
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topConstraint,
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let arrowImageUI = UIImageView()
        arrowImageUI.image = UIImage(systemName: "chevron.up.2")
        arrowImageUI.tintColor = .brandOrange // Your brand orange
        arrowImageUI.contentMode = .scaleAspectFit
        
        let swipeLabel = UILabel()
        swipeLabel.text = "Swipe Up to Continue"
        swipeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        swipeLabel.textColor = .brandOrange
        swipeLabel.textAlignment = .center
        
        let swipeStackView = UIStackView(arrangedSubviews: [arrowImageUI, swipeLabel])
        swipeStackView.axis = .vertical
        swipeStackView.spacing = 8
        swipeStackView.alignment = .center
        swipeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.addSubview(swipeStackView)
        
        NSLayoutConstraint.activate([
            swipeStackView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            swipeStackView.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20),
            arrowImageUI.heightAnchor.constraint(equalToConstant: 22),
            arrowImageUI.widthAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            // Allow dragging upwards (negative translation)
            if translation.y < 0 {
                bottomViewTopConstraint?.constant = -bottomViewHeight + translation.y
            }
        case .ended, .cancelled:
            // Threshold to trigger transition (e.g. dragged up by 100 points)
            if translation.y < -100 {
                // Complete the swipe visually then transition
                UIView.animate(withDuration: 0.3, animations: {
                    self.bottomViewTopConstraint?.constant = -self.view.frame.height
                    self.view.layoutIfNeeded()
                }) { _ in
                    let signupVC = SignupViewController()
                    
                    // Create sliding up transition
                    let transition = CATransition()
                    transition.duration = 0.4
                    transition.type = .push
                    transition.subtype = .fromTop
                    transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                    self.navigationController?.view.layer.add(transition, forKey: kCATransition)
                    
                    self.navigationController?.pushViewController(signupVC, animated: false)
                    
                    // Reset position silently for when user comes back
                    self.bottomViewTopConstraint?.constant = -self.bottomViewHeight
                }
            } else {
                // Snap back
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.bottomViewTopConstraint?.constant = -self.bottomViewHeight
                    self.view.layoutIfNeeded()
                })
            }
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // This hides the top bar so it doesn't interfere with your design
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

#Preview{
    HomeViewController()
}
