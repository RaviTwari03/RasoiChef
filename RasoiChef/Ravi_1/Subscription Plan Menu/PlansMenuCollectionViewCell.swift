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
    
 
//    func updateMenuDetails(mealType: String, mealName: String, mealDescription: String) {
//            applyCardStyle2()
//            
//            MenuTiming.text = mealType
//            MealName.text = mealName
//            MealDescription.text = mealDescription  // ✅ FIXED: Show the correct meal description
//            
//            // Set default image if no image is available
//            let imageName = mealName.replacingOccurrences(of: " ", with: "_").lowercased()
//            MealImage.image = UIImage(named: imageName) ?? UIImage(named: "default_meal")
//        }
    func updateMenuDetails(mealType: String, mealName: String, mealDescription: String, mealImageURL: String) {
        applyCardStyle2()
        
        MenuTiming.text = mealType
        MealName.text = mealName
        MealDescription.text = mealDescription

        print("Meal Image URL: \(mealImageURL)") // Debugging

        // Load image from URL (Use default if missing)
        if let url = URL(string: mealImageURL), !mealImageURL.isEmpty {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.MealImage.image = UIImage(data: data)
                    }
                } else {
                    print("Failed to load image data from: \(mealImageURL)")
                }
            }
        } else {
            MealImage.image = UIImage(named: "default_meal")
            print("Invalid URL, using default image")
        }
    }

        func applyCardStyle2() {
            subscriptionView.layer.cornerRadius = 16
            subscriptionView.layer.masksToBounds = false
            subscriptionView.layer.shadowColor = UIColor.black.cgColor
            subscriptionView.layer.shadowOffset = CGSize(width: 0, height: 4)
            subscriptionView.layer.shadowRadius = 5
            subscriptionView.layer.shadowOpacity = 0.4
            subscriptionView.backgroundColor = .white
        }
    }
