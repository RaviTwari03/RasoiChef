//import UIKit
//
//class BannerView: UIView {
//    private let containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 25
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    private let messageLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.text = "1 item added"
//        label.font = .systemFont(ofSize: 16, weight: .medium)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let viewCartButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("View Cart", for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
//        button.setTitleColor(.black, for: .normal)
//        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
//        button.tintColor = .black
//        button.semanticContentAttribute = .forceRightToLeft
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    private weak var presentingVC: UIViewController?
//    private var bottomConstraint: NSLayoutConstraint?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//    }
//    
//    private func setupView() {
//        addSubview(containerView)
//        containerView.addSubview(messageLabel)
//        containerView.addSubview(viewCartButton)
//        
//        containerView.layer.shadowColor = UIColor.black.cgColor
//        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        containerView.layer.shadowRadius = 4
//        containerView.layer.shadowOpacity = 0.1
//        
//        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: topAnchor),
//            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            
//            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
//            messageLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
//            
//            viewCartButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
//            viewCartButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
//            viewCartButton.leadingAnchor.constraint(greaterThanOrEqualTo: messageLabel.trailingAnchor, constant: 16)
//        ])
//        
//        viewCartButton.addTarget(self, action: #selector(viewCartTapped), for: .touchUpInside)
//    }
//    
//    func show(message: String = "1 item added", in viewController: UIViewController) {
//        presentingVC = viewController
//        translatesAutoresizingMaskIntoConstraints = false
//        viewController.view.addSubview(self)
//        
//        let safeArea = viewController.view.safeAreaLayoutGuide
//        let tabBarHeight = viewController.tabBarController?.tabBar.frame.height ?? 0
//        
//        if let tabBar = viewController.tabBarController?.tabBar {
//            bottomConstraint = bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -60) // Moves it further up
//        } else {
//            bottomConstraint = bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -60)
//        }
//        
//        NSLayoutConstraint.activate([
//            bottomConstraint!,
//            leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 16),
//            trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -16),
//            heightAnchor.constraint(equalToConstant: 50)
//        ])
//        
//        transform = CGAffineTransform(translationX: 0, y: 100)
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
//            self.transform = .identity
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.hide()
//        }
//    }
//    
//    private func hide() {
//        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
//            self.transform = CGAffineTransform(translationX: 0, y: 100)
//        } completion: { _ in
//            self.removeFromSuperview()
//        }
//    }
//    
//    @objc private func viewCartTapped() {
//        guard let viewController = presentingVC, let tabBarController = viewController.tabBarController else { return }
//        
//        tabBarController.selectedIndex = 2
//        
//        if viewController.presentingViewController != nil {
//            viewController.dismiss(animated: true)
//        }
//        
//        hide()
//    }
//}
import UIKit

class BannerView: UIView {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30 // Increased corner radius for better appearance
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "1 item added"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("View Cart", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black
        button.semanticContentAttribute = .forceRightToLeft
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private weak var presentingVC: UIViewController?
    private var bottomConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(containerView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(viewCartButton)
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            messageLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            viewCartButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            viewCartButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            viewCartButton.leadingAnchor.constraint(greaterThanOrEqualTo: messageLabel.trailingAnchor, constant: 16)
        ])
        
        viewCartButton.addTarget(self, action: #selector(viewCartTapped), for: .touchUpInside)
    }
    
    func show(message: String = "1 item added", in viewController: UIViewController) {
        presentingVC = viewController
        translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(self)
        
        let safeArea = viewController.view.safeAreaLayoutGuide
        
        if let tabBar = viewController.tabBarController?.tabBar {
            bottomConstraint = bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -60) // Moves it further up
        } else {
            bottomConstraint = bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -60)
        }
        
        NSLayoutConstraint.activate([
            bottomConstraint!,
            leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 16),
            trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -16),
            heightAnchor.constraint(equalToConstant: 70) // **Increased height from 50 to 70**
        ])
        
        transform = CGAffineTransform(translationX: 0, y: 120) // Adjusted for smooth animation
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.transform = .identity
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hide()
        }
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
            self.transform = CGAffineTransform(translationX: 0, y: 120)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }

    @objc private func viewCartTapped() {
        guard let viewController = presentingVC else { return }

        // 1️⃣ Try to switch tabs if inside a tab bar controller
        if let tabBarController = viewController.view.window?.rootViewController as? UITabBarController {
            DispatchQueue.main.async {
                tabBarController.selectedIndex = 2  // Switch to Cart tab
            }
            hide()
            return
        }
        
        // 2️⃣ If tab bar controller is NOT found, manually navigate (fallback)
        let storyboard = UIStoryboard(name: "Vikash", bundle: nil)
        if let cartVC = storyboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
            
            // Check if navigation controller is available
            if let navController = viewController.navigationController {
                navController.pushViewController(cartVC, animated: true)
            } else {
                cartVC.modalPresentationStyle = .fullScreen
                viewController.present(cartVC, animated: true)
            }
        } else {
            print("CartViewController not found in storyboard")
        }

        hide()
    }


}
