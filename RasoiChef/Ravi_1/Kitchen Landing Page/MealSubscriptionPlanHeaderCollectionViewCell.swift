//
//  MealSubscriptionPlanHeaderCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 29/01/25.
//

import UIKit

protocol MealSubscriptionPlanHeaderDelegate: AnyObject {
    func didTapSeeMore2()
    func didTapSeeMore3()
    }

class MealSubscriptionPlanHeaderCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MealSubscriptionPlanHeaderDelegate?
    
    @IBAction func menuPlans(_ sender: UIButton) {
        delegate?.didTapSeeMore3()
    }
    
    @IBAction func seeMoreTapped(_ sender: UIButton) {
        delegate?.didTapSeeMore2()
    }
}
