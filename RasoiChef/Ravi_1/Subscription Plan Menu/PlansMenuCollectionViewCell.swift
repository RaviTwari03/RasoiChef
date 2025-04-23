//
//  PlansMenuCollectionViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 30/01/25.
//

import UIKit
class PlansMenuCollectionViewCell: UICollectionViewCell {
   
    
    @IBOutlet var MenuTiming: UILabel!
    
    @IBOutlet var MealName: UILabel!
    
    @IBOutlet var MealDescription: UILabel!
    
    @IBOutlet var subscriptionView: UIView!
    @IBOutlet var MealImage: UIImageView!
    
    @IBOutlet weak var mealcategoriesImage: UIImageView!
    

    
    
    
    func updateMenuDetails(mealType: String, mealName: String, mealDescription: String, mealImageName: String) {
        applyCardStyle2()
        
        MenuTiming.text = mealType
        MealName.text = mealName
        MealDescription.text = mealDescription
        
        // Load from assets
        MealImage.image = UIImage(named: mealImageName) ?? UIImage(named: "default_meal")
        
        // Set meal category icon directly from assets
        let mealcategoryImage = UIImage(named: "\(mealType)Icon") ?? UIImage(systemName: "clock.fill")
        mealcategoriesImage.image = mealcategoryImage
    }


        func applyCardStyle2() {
            subscriptionView.layer.cornerRadius = 15
            subscriptionView.layer.masksToBounds = false
            subscriptionView.layer.shadowColor = UIColor.black.cgColor
            subscriptionView.layer.shadowOffset = CGSize(width: 0, height: 2)
            subscriptionView.layer.shadowRadius = 2.5
            subscriptionView.layer.shadowOpacity = 0.4
            subscriptionView.backgroundColor = .white
        }
    }
