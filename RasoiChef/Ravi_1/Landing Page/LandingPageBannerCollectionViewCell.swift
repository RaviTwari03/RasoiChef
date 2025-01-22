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
    
    
    func updateBannerDetails(for indexPath : IndexPath){
        let bannerData = KitchenDataController.mealBanner[indexPath.row]
        BannerHeaderLAbel.text = bannerData.title
        MealDeadline.text = bannerData.subtitle
        deliveryExpected.text = bannerData.deliveryTime
        TimeRemainingLabel.text = bannerData.timer
        BannerImage.image = UIImage(named: bannerData.icon)
    }
    
    
    
}
