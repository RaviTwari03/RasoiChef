//
//  SubscriptionFooterTableViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 30/01/25.
//

import UIKit

protocol SubscribeYourPlanButtonDelegate: AnyObject {
    func didTapSeeMorePlanYourMeal()
    func didAddItemToSubscriptionCart(_ item : SubscriptionPlan)
    }

class SubscriptionFooterTableViewCell: UITableViewCell {
    var subscriptionItem : SubscriptionPlan?
    weak var delegate : SubscribeYourPlanButtonDelegate?
    var footerCell: SubscriptionFooterTableViewCell?

    @IBOutlet var PaymentLabel: UILabel!
    @IBOutlet var SubscribeButton: UIButton!
    
    @IBOutlet var addButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
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
        
        //var subscriptionCartItem : SubscriptionPlan?
        let subscriptionCartItem = SubscriptionPlan(
                   planID: UUID().uuidString,
                   userID: "user001",
                   kitchenID: "kitchen001",
                   startDate: "2025-02-13",
                   endDate: "2025-02-20",
                   totalPrice: 1400.0, // Example price, replace as needed
                   details: "Your customized meal plan",
                   mealCountPerDay: 3, // Example meal count, replace as needed
                   planImage: nil,
                   weeklyMeals: nil
               )

               // Pass subscriptionCartItem to the delegate (CartViewController)
               delegate?.didAddItemToSubscriptionCart(subscriptionCartItem)
           }
    }
   
    
  
   
       
        
    

