//
//  UserCartAddressTableViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

class UserCartAddressTableViewCell: UITableViewCell {

    
    @IBOutlet var userAdressLabel: UILabel!
    
    @IBOutlet weak var userCartView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCellAppearance()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateAddress(with indexpath: IndexPath){
        let address = KitchenDataController.user[indexpath.row]
        userAdressLabel.text = address.address
    }
    
    
    private func setupCellAppearance() {
        // Apply corner radius
        userCartView.layer.cornerRadius = 15
        userCartView.layer.masksToBounds = true
            // Add shadow to create a card-like appearance
        userCartView.layer.shadowColor = UIColor.black.cgColor
        userCartView.layer.shadowOffset = CGSize(width: 0, height: 2)
        userCartView.layer.shadowRadius = 2.5
        userCartView.layer.shadowOpacity = 0.4
        userCartView.layer.masksToBounds = false
            // Add padding by adjusting the content insets
        userCartView.layoutMargins = UIEdgeInsets(top: 15, left: 16, bottom: 15, right: 16)
            
            // Optionally, you can add a background color for the card
        userCartView.backgroundColor = .white
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let inset: CGFloat = 10 // Set leading and trailing insets
        contentView.frame = contentView.frame.insetBy(dx: inset, dy: 0)
    }
}
