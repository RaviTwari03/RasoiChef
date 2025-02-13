//
//  SubscriptionCartBillTableViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 13/02/25.
//

import UIKit

class SubscriptionCartBillTableViewCell: UITableViewCell {

    
    @IBOutlet weak var SubscriptionPrice: UILabel!
    @IBOutlet weak var gstLabel: UILabel!
    @IBOutlet weak var deliveryCharges: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
