//
//  WeeklyPlansTableViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 22/01/25.
//

import UIKit

class WeeklyPlansTableViewCell: UITableViewCell {
    
    
    @IBOutlet var startDateCalender: UIDatePicker!
    @IBOutlet var endDateCalender: UIDatePicker!
    
    @IBOutlet weak var selectedRangeLabel: UILabel!
    
    @IBOutlet var pricesAlert: UIButton!
    
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureDatePickers()
        configurePriceAlertButton()
        
        // Initially, hide the label
        selectedRangeLabel.isHidden = true
    }
    
    private func configureDatePickers() {
        let currentDate = Date()
        let calendar = Calendar.current
        let sevenDaysLater = calendar.date(byAdding: .day, value: 7, to: currentDate)
        
        // Configure startDateCalender
        startDateCalender.minimumDate = currentDate
        startDateCalender.date = currentDate
        startDateCalender.addTarget(self, action: #selector(startDateSelected), for: .valueChanged)
        
        // Configure endDateCalender
        endDateCalender.minimumDate = currentDate
        endDateCalender.maximumDate = sevenDaysLater
        endDateCalender.date = sevenDaysLater ?? currentDate
        endDateCalender.addTarget(self, action: #selector(endDateSelected), for: .valueChanged)
    }
    
    private func configurePriceAlertButton() {
        pricesAlert.addTarget(self, action: #selector(showPriceAlert), for: .touchUpInside)
    }
    
    @objc private func startDateSelected() {
        let selectedStartDate = startDateCalender.date
        let calendar = Calendar.current
        let sevenDaysLater = calendar.date(byAdding: .day, value: 7, to: selectedStartDate)
        
        endDateCalender.minimumDate = selectedStartDate
        endDateCalender.maximumDate = sevenDaysLater
        endDateCalender.date = sevenDaysLater ?? selectedStartDate
    }
    
    @objc private func endDateSelected(_ sender: UIDatePicker) {
        updateSelectedRangeLabel()
    }
    
    private func updateSelectedRangeLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        let startDateString = dateFormatter.string(from: startDateCalender.date)
        let endDateString = dateFormatter.string(from: endDateCalender.date)
        
        selectedRangeLabel.text = "\(startDateString) - \(endDateString)"
        selectedRangeLabel.isHidden = false  // Show the label when end date is selected
    }
    
    @objc private func showPriceAlert() {
        guard let parentVC = self.parentViewController else { return }
        
        // Create a custom alert view
        let alertController = UIAlertController(title: "Meal Prices", message: nil, preferredStyle: .alert)
        
        // Create a custom view with a stack view
        let customView = createMealPricesView()
        alertController.view.addSubview(customView)
        
        // Adjust layout for the custom view inside the alert
        customView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 60),
            customView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -70),
            customView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 0),
            customView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -20),
        ])
        
        // Add an OK button
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        // Present the alert
        parentVC.present(alertController, animated: true)
    }
    
    private func createMealPricesView() -> UIView {
        // Meals data: title, icon name, and price
        let meals = [
            ("Breakfast", "BreakfastIcon", "₹40"),
            ("Lunch", "LunchIcon", "₹60"),
            ("Snacks", "SnacksIcon", "₹40"),
            ("Dinner", "DinnerIcon", "₹60")
        ]
        
        // Stack view for the list of meals
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10
        
        for (meal, iconName, price) in meals {
            let mealRow = createMealRow(title: meal, iconName: iconName, price: price)
            stackView.addArrangedSubview(mealRow)
        }
        
        return stackView
    }
    
    private func createMealRow(title: String, iconName: String, price: String) -> UIView {
        // Image View
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: iconName) // Replace with custom image assets
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .black
        
        // Price Label
        let priceLabel = UILabel()
        priceLabel.text = price
        priceLabel.font = UIFont.systemFont(ofSize: 16)
        priceLabel.textColor = .black
        
        // Horizontal Stack View for each row
        let horizontalStack = UIStackView(arrangedSubviews: [iconImageView, titleLabel, priceLabel])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.spacing = 10
        horizontalStack.distribution = .fill
        
        return horizontalStack
    }
}
    
    extension UIView {
        var parentViewController: UIViewController? {
            var parentResponder: UIResponder? = self
            while parentResponder != nil {
                parentResponder = parentResponder?.next
                if let viewController = parentResponder as? UIViewController {
                    return viewController
                }
            }
            return nil
        }
    }


