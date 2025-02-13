//
//  CartBillTableViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

class CartBillTableViewCell: UITableViewCell {

    @IBOutlet var itemPriceLabel: UILabel!
    @IBOutlet var gstLabel: UILabel!
    @IBOutlet var deliveryChargesLabel: UILabel!
    @IBOutlet var discountLabel: UILabel!
    @IBOutlet var totalAmount: UILabel!
   
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCellAppearance()
    }
    
    private func setupCellAppearance() {
           // Apply corner radius
           contentView.layer.cornerRadius = 15
           contentView.layer.masksToBounds = true

           // Add border
           contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let inset: CGFloat = 16 // Set leading and trailing insets
        contentView.frame = contentView.frame.insetBy(dx: inset, dy: 0)
    }

}
