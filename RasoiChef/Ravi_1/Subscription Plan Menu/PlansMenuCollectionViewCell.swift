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
        
        
        let mealcategoryImage: String
            switch mealType {
            case "Breakfast":
                mealcategoryImage = "BreakfastIcon"
            case "Lunch":
                mealcategoryImage = "LunchIcon"
            case "Dinner":
                mealcategoryImage = "DinnerIcon"
            case "Snacks":
                mealcategoryImage = "SnacksIcon"
            default:
                mealcategoryImage = "default_meal"
            }
            
            mealcategoriesImage.image = UIImage(named: mealcategoryImage)
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
