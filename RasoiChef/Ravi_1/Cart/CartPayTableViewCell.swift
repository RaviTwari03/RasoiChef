//
//  CartPayTableViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit
protocol CartPayCellDelegate: AnyObject {
    func didTapPlaceOrder()
}

class CartPayTableViewCell: UITableViewCell {
    weak var delegate: CartPayCellDelegate?

    
    @IBOutlet var addButton: UIButton!
    @IBOutlet var TotalAmountLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addButtonUpdate(){
        addButton.layer.cornerRadius = 11
    }
   
    @IBAction func placeOrderButton(_ sender: Any) {
        delegate?.didTapPlaceOrder()
        

    }
    

}
