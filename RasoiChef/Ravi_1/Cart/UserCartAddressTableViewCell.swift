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

    func updateAddress(with indexpath: IndexPath){
        let address = KitchenDataController.user[indexpath.row]
        userAdressLabel.text = address.address
    }
}
