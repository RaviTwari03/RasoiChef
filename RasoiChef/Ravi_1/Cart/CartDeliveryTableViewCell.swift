//
//  CartDeliveryTableViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

protocol CartDeliveryDelegate: AnyObject {
    func deliveryOptionChanged(isDelivery: Bool)
}

class CartDeliveryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deliverySegmentedControl: UISegmentedControl!
    weak var delegate: CartDeliveryDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        deliverySegmentedControl.selectedSegmentIndex = 0 // Default to Self-Pickup
        deliverySegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc private func segmentedControlValueChanged() {
        let isDelivery = deliverySegmentedControl.selectedSegmentIndex == 1
        delegate?.deliveryOptionChanged(isDelivery: isDelivery)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
