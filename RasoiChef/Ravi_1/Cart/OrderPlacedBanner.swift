import UIKit

class BannerView: UIView {

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

        // Start the banner offscreen
        self.frame = CGRect(x: 20, y: -80, width: UIScreen.main.bounds.width - 40, height: 60)
        self.alpha = 0

        iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.frame = CGRect(x: 15, y: 15, width: 30, height: 30)
        self.addSubview(iconImageView)

        messageLabel.textColor = .white
        messageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        messageLabel.textAlignment = .left
        messageLabel.frame = CGRect(x: 55, y: 0, width: self.frame.width - 70, height: 60)
        self.addSubview(messageLabel)
    }

    func show(in view: UIView, message: String) {
        messageLabel.text = message
        
        // Ensure the banner is on top
        if self.superview == nil {
            view.addSubview(self)
        }

        // Position the banner at the top (offscreen initially)
        self.frame.origin.y = -80

        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
            self.frame.origin.y = view.safeAreaInsets.top + 10
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.hide()
            }
        }
    }

    private func hide() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
            self.frame.origin.y = -80
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
