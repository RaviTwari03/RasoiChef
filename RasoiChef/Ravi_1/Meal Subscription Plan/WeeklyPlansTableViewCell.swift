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
    @IBOutlet var expectedRangeCalender: UIDatePicker!
    
    @IBOutlet var pricesAlert: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureDatePickers()
        configurePriceAlertButton()
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
        endDateCalender.addTarget(self, action: #selector(datePickerDismissed), for: .valueChanged)
        
        // Configure expectedRangeCalender
        expectedRangeCalender.minimumDate = currentDate
        expectedRangeCalender.date = currentDate
        expectedRangeCalender.addTarget(self, action: #selector(datePickerDismissed), for: .valueChanged)
    }
    
    private func configurePriceAlertButton() {
        pricesAlert.addTarget(self, action: #selector(showPriceAlert), for: .touchUpInside)
    }
    
    @objc private func startDateSelected() {
        // Update the endDateCalender's minimum and maximum dates based on the start date
        let selectedStartDate = startDateCalender.date
        let calendar = Calendar.current
        let sevenDaysLater = calendar.date(byAdding: .day, value: 7, to: selectedStartDate)
        
        endDateCalender.minimumDate = selectedStartDate
        endDateCalender.maximumDate = sevenDaysLater
        endDateCalender.date = sevenDaysLater ?? selectedStartDate
        
        // Dismiss the date picker
        startDateCalender.resignFirstResponder()
    }
    
    @objc private func datePickerDismissed(_ sender: UIDatePicker) {
        sender.resignFirstResponder()
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


    
//           @objc private func showPriceAlert() {
//               guard let parentVC = self.parentViewController else { return }
//    
//               let alert = UIAlertController(
//                   title: "Meal Prices",
//                   message: "Breakfast and Snacks: ₹40\nLunch and Dinner: ₹60",
//                   preferredStyle: .alert
//               )
//               alert.addAction(UIAlertAction(title: "OK", style: .default))
//    
//               parentVC.present(alert, animated: true, completion: nil)
//           }
       }
//    @objc private func showPriceAlert() {
//        guard let parentVC = self.parentViewController else { return }
//        
//        // Create an alert controller
//        let alert = UIAlertController(title: "Meal Prices", message: nil, preferredStyle: .alert)
//        
//        // Create an attributed string with emojis
//        let attributedMessage = NSMutableAttributedString()
//        
//        let meals = [
//            ("Breakfast", "☀️", "₹40"),
//            ("Lunch", "🌞", "₹60"),
//            ("Snacks", "🍔", "₹40"),
//            ("Dinner", "🌙", "₹60")
//        ]
//        
//        for (meal, emoji, price) in meals {
//            let mealLine = NSAttributedString(string: "\(meal) \(emoji) \(price)\n", attributes: [
//                .font: UIFont.systemFont(ofSize: 16),
//                .foregroundColor: UIColor.black
//            ])
//            attributedMessage.append(mealLine)
//        }
//        
//        // Set the attributed string as the alert message
//        alert.setValue(attributedMessage, forKey: "attributedMessage")
//        
//        // Add an OK action
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        
//        // Present the alert
//        parentVC.present(alert, animated: true, completion: nil)
//    }
    
    // Extension to get the parent view controller
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

