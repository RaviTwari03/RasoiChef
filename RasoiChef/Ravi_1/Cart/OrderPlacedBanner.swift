import UIKit

class CustomBannerView: UIView {

    private let messageLabel = UILabel()
    private let iconImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.backgroundColor = UIColor.systemGreen
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4

        // Set initial frame offscreen below the view (it won't drop from top now)
        self.frame = CGRect(x: 20, y: -80, width: UIScreen.main.bounds.width - 40, height: 80)
        self.alpha = 0

        // Icon
        iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.frame = CGRect(x: 15, y: 25, width: 30, height: 30)
        self.addSubview(iconImageView)

        // Message Label
        messageLabel.textColor = .white
        messageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        messageLabel.textAlignment = .left
        messageLabel.frame = CGRect(x: 55, y: 0, width: self.frame.width - 70, height: self.frame.height)
        self.addSubview(messageLabel)
    }

    func show(in view: UIView, message: String) {
        messageLabel.text = message

        // Ensure the banner is on top of all other views
        if self.superview == nil {
            view.addSubview(self)
        }

        // Position the banner below the tab bar
        let tabBarHeight = view.safeAreaInsets.bottom
        let bannerYPosition = view.bounds.height - tabBarHeight - self.frame.height - 10 // 10px above the tab bar

        self.frame.origin.y = bannerYPosition // Set the banner position instantly
        self.alpha = 1 // Show the banner with instant fade-in effect

        // Hide banner after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hide()
        }
    }

    private func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

