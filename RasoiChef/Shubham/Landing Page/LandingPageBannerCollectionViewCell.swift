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
    
    private var imageLoadTask: URLSessionDataTask?
    
    func updateBannerDetails(for indexPath : IndexPath){
        let bannerData = KitchenDataController.mealBanner[indexPath.row]
        BannerHeaderLAbel.text = bannerData.title
        MealDeadline.text = bannerData.subtitle
        deliveryExpected.text = bannerData.deliveryTime
        mealCategoryLabel.text = bannerData.mealType
        timerIcon.image = UIImage(systemName: "timer")
        
        // Cancel any existing image load task
        imageLoadTask?.cancel()
        
        // Load image from URL if available
        if let imageUrl = URL(string: bannerData.icon) {
            BannerImage.image = UIImage(named: "placeholderImage") // Set placeholder while loading
            
            imageLoadTask = URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error loading image: \(error)")
                        self?.BannerImage.image = UIImage(named: bannerData.icon) // Fallback to local image
                        return
                    }
                    
                    if let data = data, let image = UIImage(data: data) {
                        self?.BannerImage.image = image
                    } else {
                        // If failed to load from URL, try loading from local assets
                        self?.BannerImage.image = UIImage(named: bannerData.icon)
                    }
                }
            }
            imageLoadTask?.resume()
        } else {
            // If URL is invalid, try loading from local assets
            BannerImage.image = UIImage(named: bannerData.icon)
        }
        
        // Get current date and time
        let currentDate = Date()
        
        // If current time is past 9 PM, adjust the date to the next day
        let calendar = Calendar.current
        let ninePM = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: currentDate)!
        var effectiveDate = currentDate
        
        if currentDate > ninePM {
            effectiveDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        var deadlineDate: Date?
        var deadlineTime: String?
        var timerTextColor: UIColor = .systemGreen
        var iconColor: UIColor = .systemGreen
        
        switch bannerData.mealType {
        case "Breakfast":
            deadlineDate = getDeadlineTime(for: effectiveDate, hour: 7, minute: 0) // 7 AM
            deadlineTime = "7 am"
            
        case "Lunch":
            deadlineDate = getDeadlineTime(for: effectiveDate, hour: 11, minute: 0) // 12 AM
            deadlineTime = "11 am"
            
        case "Snacks":
            deadlineDate = getDeadlineTime(for: effectiveDate, hour: 16, minute: 0) // 4 PM
            deadlineTime = "4 pm"
            
        case "Dinner":
            deadlineDate = getDeadlineTime(for: effectiveDate, hour: 20, minute: 0) // 8 PM
            deadlineTime = "8 pm"
            
        default:
            break
        }
        
        guard let deadline = deadlineDate else { return }
        
        // Time difference
        let timeRemaining = deadline.timeIntervalSince(currentDate)
        
        if timeRemaining <= 0 {
            // Time has passed
            TimeRemainingLabel.text = "00 min"
            timerTextColor = .gray
            iconColor = .gray
        } else {
            let minutesRemaining = Int(timeRemaining / 60) % 60
            let hoursRemaining = Int(timeRemaining / 3600)
            
            TimeRemainingLabel.text = "\(hoursRemaining)h \(minutesRemaining) min"
            
            if currentDate >= deadline.addingTimeInterval(-60 * 60) { // One hour before deadline
                timerTextColor = .red
                iconColor = .red
            }
        }
        
        // Update label colors based on remaining time
        TimeRemainingLabel.textColor = timerTextColor
        timerIcon.tintColor = iconColor
        
        // Set the timer icon
        let config = UIImage.SymbolConfiguration(weight: .medium)
        timerIcon.image = UIImage(systemName: "timer", withConfiguration: config)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Cancel any pending image load when cell is reused
        imageLoadTask?.cancel()
        imageLoadTask = nil
        BannerImage.image = nil
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
    
    
    func getDeadlineTime(for date: Date, hour: Int, minute: Int) -> Date {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: date)
        let currentMonth = calendar.component(.month, from: date)
        let currentDay = calendar.component(.day, from: date)

        // Create a date for the deadline for the specified time of the day
        let deadlineComponents = DateComponents(year: currentYear, month: currentMonth, day: currentDay, hour: hour, minute: minute)
        return calendar.date(from: deadlineComponents)!
    }
}
