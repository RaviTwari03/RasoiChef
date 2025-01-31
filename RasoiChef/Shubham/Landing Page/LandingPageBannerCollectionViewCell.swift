//
//  LandingPageBannerCollectionViewCell.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

class LandingPageBannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var BannerHeaderLAbel: UILabel!
    @IBOutlet var MealDeadline: UILabel!
    @IBOutlet var deliveryExpected: UILabel!
    @IBOutlet var TimeRemainingLabel: UILabel!
    @IBOutlet var BannerImage: UIImageView!
    @IBOutlet var timerIcon: UIImageView!
    
    @IBOutlet weak var mealCategoryLabel: UILabel!
    
    @IBOutlet weak var mealImageTextView: UIView!
    @IBOutlet weak var BannerView: UIView!
    
    func updateBannerDetails(for indexPath : IndexPath){
        let bannerData = KitchenDataController.mealBanner[indexPath.row]
        BannerHeaderLAbel.text = bannerData.title
        MealDeadline.text = bannerData.subtitle
        deliveryExpected.text = bannerData.deliveryTime
        TimeRemainingLabel.text = bannerData.timer
        BannerImage.image = UIImage(named: bannerData.icon)
        timerIcon.image = UIImage(systemName: "timer")
        timerIcon.tintColor = .systemRed
        TimeRemainingLabel.tintColor = .systemRed
        mealCategoryLabel.text = bannerData.mealType
        
        let config = UIImage.SymbolConfiguration(weight: .medium)
        
        timerIcon.image = UIImage(systemName: "timer", withConfiguration: config)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupShadow()
    }
    
    func setupShadow() {
        BannerView.layer.masksToBounds = false  // Allow shadow to be visible outside the cell bounds
        
        BannerView.layer.cornerRadius = 15 // Rounded corners
        BannerView.layer.masksToBounds = true  // Ensure content respects rounded corners
        
        // Apply shadow to contentView
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2.5
        layer.masksToBounds = false
        
        // Set shadow path for better performance
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: BannerView.layer.cornerRadius).cgPath
        
        
        mealImageTextView.layer.shadowColor = UIColor.black.cgColor
        mealImageTextView.layer.shadowOpacity = 0.5
        mealImageTextView.layer.shadowOffset = CGSize(width: 0, height: 2)
        mealImageTextView.layer.shadowRadius = 2.5
        mealImageTextView.layer.masksToBounds = false // Important for shadow visibility
        mealImageTextView.layer.cornerRadius = 14

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: BannerView.layer.cornerRadius).cgPath
        
        
    }
}
