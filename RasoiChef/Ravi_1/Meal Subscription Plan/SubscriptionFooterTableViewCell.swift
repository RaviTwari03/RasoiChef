//
//  SubscriptionFooterTableViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 30/01/25.
//

import UIKit

class SubscriptionFooterTableViewCell: UITableViewCell {

    var footerCell: SubscriptionFooterTableViewCell?

    @IBOutlet var PaymentLabel: UILabel!
    @IBOutlet var SubscribeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
