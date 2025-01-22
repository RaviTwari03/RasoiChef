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
    @IBOutlet var discountLabel: UILabel!
    @IBOutlet var totalAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
