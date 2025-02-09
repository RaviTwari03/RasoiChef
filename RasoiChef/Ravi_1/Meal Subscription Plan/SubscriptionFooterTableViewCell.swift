//
//  SubscriptionFooterTableViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 30/01/25.
//

import UIKit

protocol SubscribeYourPlanButtonDelegate: AnyObject {
    func didTapSeeMorePlanYourMeal()
    }

class SubscriptionFooterTableViewCell: UITableViewCell {

    weak var delegate : SubscribeYourPlanButtonDelegate?
    var footerCell: SubscriptionFooterTableViewCell?

    @IBOutlet var PaymentLabel: UILabel!
    @IBOutlet var SubscribeButton: UIButton!
    
    @IBOutlet var addButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateButton(){
        addButton.layer.cornerRadius = 11
    }
    
    @IBAction func subscribePlansButtonClicked(_ sender: Any) {
        delegate?.didTapSeeMorePlanYourMeal()
    }
}
