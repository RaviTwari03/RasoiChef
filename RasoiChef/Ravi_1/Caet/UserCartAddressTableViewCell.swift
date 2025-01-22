//
//  UserCartAddressTableViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

class UserCartAddressTableViewCell: UITableViewCell {

    
    @IBOutlet var userAdressLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    func updateUserAddress(for indexPath:IndexPath){
//        _ = KitchenDataController.cartItems[indexPath.row]
//        userAdressLabel.text = "Galgotias University, Plot No. 2, Yamuna Expy"
//    }
}
