//
//  UserCartAddressTableViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

protocol UserCartAddressDelegate: AnyObject {
    func didTapChangeAddress()
}

class UserCartAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var userAdressLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var userCartView: UIView!
    
    weak var delegate: UserCartAddressDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
        configureChangeButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateAddress(with address: String) {
        userAdressLabel.text = address
    }
    
    private func configureChangeButton() {
        guard let button = changeButton else { return }
        
        button.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
        button.setTitle("Change", for: .normal)
        button.setTitleColor(UIColor(named: "AccentColor") ?? .systemBlue, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = (UIColor(named: "AccentColor") ?? .systemBlue).cgColor
        button.backgroundColor = .clear
    }
    
    @objc private func changeButtonTapped() {
        delegate?.didTapChangeAddress()
    }
    
    private func setupCellAppearance() {
        guard let cartView = userCartView else { return }
        
        cartView.layer.cornerRadius = 15
        cartView.layer.masksToBounds = true
        cartView.layer.shadowColor = UIColor.black.cgColor
        cartView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cartView.layer.shadowRadius = 2.5
        cartView.layer.shadowOpacity = 0.4
        cartView.layer.masksToBounds = false
        cartView.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
        cartView.backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset: CGFloat = 10
        contentView.frame = contentView.frame.insetBy(dx: inset, dy: 0)
    }
}
