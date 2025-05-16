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
    
    // Keep track of current image loading task
    private var currentImageTask: URLSessionDataTask?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Cancel any pending image download
        currentImageTask?.cancel()
        // Reset the image views to prevent showing old images
        MealImage.image = nil
        mealcategoriesImage.image = nil
    }
    
    func updateMenuDetails(mealType: String, mealName: String, mealDescription: String, mealImageName: String) {
        applyCardStyle2()
        
        // Cancel any existing image loading task
        currentImageTask?.cancel()
        
        MenuTiming.text = mealType
        MealName.text = mealName
        MealDescription.text = mealDescription
        
        // Set default image immediately while loading
        MealImage.image = UIImage(named: "default_meal")
        
        // Load image from URL if it's a valid URL
        if let url = URL(string: mealImageName) {
            currentImageTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                // Check if the cell is still interested in this image
                guard let self = self,
                      error == nil,
                      let data = data,
                      let image = UIImage(data: data) else {
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.MealImage.image = image
                }
            }
            currentImageTask?.resume()
        }
        
        // Set meal category icon
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
