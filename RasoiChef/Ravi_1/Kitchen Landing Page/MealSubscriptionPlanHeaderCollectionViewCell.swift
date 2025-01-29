//
//  MealSubscriptionPlanHeaderCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 29/01/25.
//

import UIKit

protocol MealSubscriptionPlanHeaderDelegate: AnyObject {
    func didTapSeeMore2()
    }

class MealSubscriptionPlanHeaderCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MealSubscriptionPlanHeaderDelegate?
    
    
    @IBAction func seeMoreTapped(_ sender: UIButton) {
        delegate?.didTapSeeMore2()
    }
}
