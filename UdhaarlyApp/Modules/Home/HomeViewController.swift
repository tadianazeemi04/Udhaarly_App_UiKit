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

    private func setupGradientBackground() {
        // [Docs] Create a beautiful premium diagonal gradient for the background matching the brand's profile scheme.
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 1.0, green: 0.45, blue: 0.0, alpha: 1.0).cgColor,   // Top Left: Bright Orange
            UIColor(red: 0.96, green: 0.16, blue: 0.0, alpha: 1.0).cgColor   // Bottom Right: Deep Red-Orange
        ]
        
        // [Docs] Set the start and end points to stretch the gradient fully diagonally across the screen bounds.
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.frame = view.bounds
        
        // [Docs] Insert at index 0 so it stays underneath all other UI subviews like the bottom sheet and logo.
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientBackground()
        
        logoImageUI.image = UIImage(resource: .udhaarlyLogo).withRenderingMode(.alwaysTemplate)
        logoImageUI.tintColor = .white
        logoImageUI.clipsToBounds = true
        logoImageUI.contentMode = .scaleAspectFit
        
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
        // Match the deeper red-orange from the text label for visual consistency
        arrowImageUI.tintColor = UIColor(red: 0.85, green: 0.25, blue: 0.15, alpha: 1.0) 
        arrowImageUI.contentMode = .scaleAspectFit
        
        let swipeLabel = UILabel()
        swipeLabel.text = "Swipe Up to Continue"
        swipeLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold) // Increased size and weight
        swipeLabel.textColor = UIColor(red: 0.85, green: 0.25, blue: 0.15, alpha: 1.0) // Deeper/Rich Red-Orange for contrast on white
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
    
    // [Docs] handlePan(_:) manages the interactive upwards-drag transition over the bottomView.
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        // [Docs] Get the precise physical pixel translation distance of the user's dragged finger.
        let translation = gesture.translation(in: view)
        
        switch gesture.state {
        case .changed:
            // [Docs] Allow dragging upwards only (negative translation). Prevent pulling the sheet downward off-screen.
            if translation.y < 0 {
                bottomViewTopConstraint?.constant = -bottomViewHeight + translation.y
            }
        case .ended, .cancelled:
            // [Docs] Navigation Transition Threshold: If pulled up by at least 100 points, execute navigation.
            if translation.y < -100 {
                // [Docs] Animation 1: Animate the bottom sheet visually shooting up entirely off the screen height.
                UIView.animate(withDuration: 0.3, animations: {
                    self.bottomViewTopConstraint?.constant = -self.view.frame.height
                    self.view.layoutIfNeeded()
                }) { _ in
                    let signupVC = SignupViewController()
                    
                    // [Docs] Create a custom CATransition explicitly defining a 'Slide Up' push effect so the next screen slides gracefully instead of pushing from the right.
                    let transition = CATransition()
                    transition.duration = 0.4
                    transition.type = .push
                    transition.subtype = .fromTop
                    transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                    self.navigationController?.view.layer.add(transition, forKey: kCATransition)
                    
                    // [Docs] Push unconditionally (animated: false) because our custom CATransition handles the animation.
                    self.navigationController?.pushViewController(signupVC, animated: false)
                    
                    // [Docs] Reset position silently behind the scenes so the view is intact if the user navigates 'Back'.
                    self.bottomViewTopConstraint?.constant = -self.bottomViewHeight
                }
            } else {
                // [Docs] Animation 2: Threshold not met. Spring the bottom view back to its native resting place smoothly.
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
