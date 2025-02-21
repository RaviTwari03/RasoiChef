//
//  WeeklyPlansTableViewCell.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 22/01/25.
//

import UIKit

//protocol WeeklyPlansDelegate: AnyObject {
//    func didSelectStartAndEndDate(startDate: String, endDate: String, dayCount: Int)
//}
protocol WeeklyPlansDelegate: AnyObject {
    func didSelectStartAndEndDate(startDate: String, endDate: String, dayCount: Int, orderedDays: [String])
}

class WeeklyPlansTableViewCell: UITableViewCell {
    
    weak var delegate: WeeklyPlansDelegate?
    
    @IBOutlet var startDateCalender: UIDatePicker!
    @IBOutlet var endDateCalender: UIDatePicker!
    
    @IBOutlet weak var selectedRangeLabel: UILabel!
    
    @IBOutlet var pricesAlert: UIButton!
    
    
   
//    var dayCount: Int = 0
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        configureStartDatePicker()
//        configureEndDatePicker()
//        configurePriceAlertButton()
//        selectedRangeLabel.isHidden = true
//        self.selectionStyle = .none
//    }
//    
//    private func configureStartDatePicker() {
//        let currentDate = Date()
//        let calendar = Calendar.current
//        let sevenDaysLater = calendar.date(byAdding: .day, value: 7, to: currentDate) ?? currentDate
//        
//        startDateCalender.minimumDate = currentDate
//        startDateCalender.maximumDate = sevenDaysLater
//        startDateCalender.date = currentDate
//        startDateCalender.addTarget(self, action: #selector(startDateSelected), for: .valueChanged)
//    }
//    
//    private func configureEndDatePicker() {
//        let currentDate = Date()
//        let calendar = Calendar.current
//        let sevenDaysLater = calendar.date(byAdding: .day, value: 7, to: currentDate) ?? currentDate
//        
//        endDateCalender.minimumDate = currentDate
//        endDateCalender.maximumDate = sevenDaysLater
//        endDateCalender.date = currentDate
//        endDateCalender.addTarget(self, action: #selector(endDateSelected), for: .valueChanged)
//    }
//    
//    private func configurePriceAlertButton() {
//        pricesAlert.addTarget(self, action: #selector(showPriceAlert), for: .touchUpInside)
//    }
//    
//    @objc private func startDateSelected() {
//        let selectedStartDate = startDateCalender.date
//        let calendar = Calendar.current
//        let sevenDaysLater = calendar.date(byAdding: .day, value: 7, to: selectedStartDate)
//        
//        endDateCalender.minimumDate = selectedStartDate
//        endDateCalender.maximumDate = sevenDaysLater
//        endDateCalender.date = sevenDaysLater ?? selectedStartDate
//    }
//    
//    @objc private func endDateSelected(_ sender: UIDatePicker) {
//        updateSelectedRangeLabel()
//        checkIfEndDateIsSelected()
//        print("End date selected: \(endDateCalender.date)")
//    }
//    
//    private func updateSelectedRangeLabel() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMM yyyy"
//        
//        let startDateString = dateFormatter.string(from: startDateCalender.date)
//        let endDateString = dateFormatter.string(from: endDateCalender.date)
//        dayCount = Calendar.current.dateComponents([.day], from: startDateCalender.date, to: endDateCalender.date).day ?? 0
//        let startDate = startDateCalender.date
//        let endDate = endDateCalender.date
//        selectedRangeLabel.text = "\(startDateString) - \(endDateString) (Total Days: \(dayCount + 1))"
//        selectedRangeLabel.isHidden = false
//        let calendar = Calendar.current
//        if let daysCount = calendar.dateComponents([.day], from: startDate, to: endDate).day {
//            print("Selected range: \(startDateString) - \(endDateString) (\(daysCount + 1) days)")
//            print("Total days count: \(daysCount + 1)")
//        }
//    }
//
//    private func checkIfEndDateIsSelected() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMM yyyy"
//        
//        let startDateString = dateFormatter.string(from: startDateCalender.date)
//        let endDateString = dateFormatter.string(from: endDateCalender.date)
//        let totalDays = dayCount + 1  // Ensures end date is included
//
//        delegate?.didSelectStartAndEndDate(startDate: startDateString, endDate: endDateString, dayCount: totalDays)
//        
//        print("Start Date: \(startDateString), End Date: \(endDateString), Total Days: \(totalDays)")
//    }
//
//
//    
//    @objc private func showPriceAlert() {
//        guard let parentVC = self.parentViewController else { return }
//        
//        let alertController = UIAlertController(title: "Meal Prices", message: nil, preferredStyle: .alert)
//        let customView = createMealPricesView()
//        alertController.view.addSubview(customView)
//        
//        customView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            customView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 60),
//            customView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -70),
//            customView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 0),
//            customView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -20),
//        ])
//        
//        alertController.addAction(UIAlertAction(title: "OK", style: .default))
//        parentVC.present(alertController, animated: true)
//    }
//    
//    private func createMealPricesView() -> UIView {
//        let meals = [
//            ("Breakfast", "sun.max", "₹30"),
//            ("Lunch", "fork.knife", "₹40"),
//            ("Snacks", "cup.and.saucer", "₹50"),
//            ("Dinner", "moon", "₹60")
//        ]
//        
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .fill
//        stackView.spacing = 10
//        
//        for (meal, iconName, price) in meals {
//            let mealRow = createMealRow(title: meal, iconName: iconName, price: price)
//            stackView.addArrangedSubview(mealRow)
//        }
//        
//        return stackView
//    }
//    
//    private func createMealRow(title: String, iconName: String, price: String) -> UIView {
//        let iconImageView = UIImageView()
//        iconImageView.image = UIImage(systemName: iconName)
//        iconImageView.contentMode = .scaleAspectFit
//        iconImageView.translatesAutoresizingMaskIntoConstraints = false
//        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        
//        let titleLabel = UILabel()
//        titleLabel.text = title
//        titleLabel.font = UIFont.systemFont(ofSize: 16)
//        titleLabel.textColor = .black
//        
//        let priceLabel = UILabel()
//        priceLabel.text = price
//        priceLabel.font = UIFont.systemFont(ofSize: 16)
//        priceLabel.textColor = .black
//        
//        let horizontalStack = UIStackView(arrangedSubviews: [iconImageView, titleLabel, priceLabel])
//        horizontalStack.axis = .horizontal
//        horizontalStack.alignment = .center
//        horizontalStack.spacing = 10
//        horizontalStack.distribution = .fill
//        
//        return horizontalStack
//    }
//}
//extension UIView {
//    var parentViewController: UIViewController? {
//        var parentResponder: UIResponder? = self
//        while parentResponder != nil {
//            parentResponder = parentResponder?.next
//            if let viewController = parentResponder as? UIViewController {
//                return viewController
//            }
//        }
//        return nil
//    }
//}
//    
    var dayCount: Int = 0
        
        override func awakeFromNib() {
            super.awakeFromNib()
            configureStartDatePicker()
            configureEndDatePicker()
            configurePriceAlertButton()
            selectedRangeLabel.isHidden = true
            self.selectionStyle = .none
        }
        
        private func configureStartDatePicker() {
            let currentDate = Date()
            let calendar = Calendar.current
            let sevenDaysLater = calendar.date(byAdding: .day, value: 7, to: currentDate) ?? currentDate
            
            startDateCalender.minimumDate = currentDate
            startDateCalender.maximumDate = sevenDaysLater
            startDateCalender.date = currentDate
            startDateCalender.addTarget(self, action: #selector(startDateSelected), for: .valueChanged)
        }
        
        private func configureEndDatePicker() {
            let currentDate = Date()
            let calendar = Calendar.current
            let sevenDaysLater = calendar.date(byAdding: .day, value: 7, to: currentDate) ?? currentDate
            
            endDateCalender.minimumDate = currentDate
            endDateCalender.maximumDate = sevenDaysLater
            endDateCalender.date = currentDate
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
            checkIfEndDateIsSelected()
        }
        
        private func updateSelectedRangeLabel() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            let startDateString = dateFormatter.string(from: startDateCalender.date)
            let endDateString = dateFormatter.string(from: endDateCalender.date)
            dayCount = Calendar.current.dateComponents([.day], from: startDateCalender.date, to: endDateCalender.date).day ?? 0
            let startDate = startDateCalender.date
            let endDate = endDateCalender.date
            selectedRangeLabel.text = "\(startDateString) - \(endDateString) (Total Days: \(dayCount + 1))"
            selectedRangeLabel.isHidden = false
            let calendar = Calendar.current
            if let daysCount = calendar.dateComponents([.day], from: startDate, to: endDate).day {
                print("Selected range: \(startDateString) - \(endDateString) (\(daysCount + 1) days)")
                print("Total days count: \(daysCount + 1)")
            }
        }

        private func checkIfEndDateIsSelected() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            
            let startDateString = dateFormatter.string(from: startDateCalender.date)
            let endDateString = dateFormatter.string(from: endDateCalender.date)
            let totalDays = dayCount + 1  // Ensures end date is included
            
            let orderedDays = reorderWeeklyDays(startDate: startDateCalender.date)
            
            print("Reordered Days: \(orderedDays)")
            
            delegate?.didSelectStartAndEndDate(startDate: startDateString, endDate: endDateString, dayCount: totalDays, orderedDays: orderedDays)
        }
        
        private func reorderWeeklyDays(startDate: Date) -> [String] {
            let calendar = Calendar.current
            let selectedWeekday = calendar.component(.weekday, from: startDate) // Sunday = 1, Monday = 2, etc.

            let allDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
            
            let startIndex = selectedWeekday - 1 // Convert to zero-based index
            let reorderedDays = allDays[startIndex...] + allDays[..<startIndex] // Rearrange days
            
            return Array(reorderedDays)
        }

        @objc private func showPriceAlert() {
            guard let parentVC = self.parentViewController else { return }
            
            let alertController = UIAlertController(title: "Meal Prices", message: nil, preferredStyle: .alert)
            let customView = createMealPricesView()
            alertController.view.addSubview(customView)
            
            customView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                customView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 60),
                customView.bottomAnchor.constraint(equalTo: alertController.view.bottomAnchor, constant: -70),
                customView.leadingAnchor.constraint(equalTo: alertController.view.leadingAnchor, constant: 0),
                customView.trailingAnchor.constraint(equalTo: alertController.view.trailingAnchor, constant: -20),
            ])
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            parentVC.present(alertController, animated: true)
        }
        
        private func createMealPricesView() -> UIView {
            let meals = [
                ("Breakfast", "sun.max", "₹30"),
                ("Lunch", "fork.knife", "₹40"),
                ("Snacks", "cup.and.saucer", "₹50"),
                ("Dinner", "moon", "₹60")
            ]
            
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
            let iconImageView = UIImageView()
            iconImageView.image = UIImage(systemName: iconName)
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            titleLabel.textColor = .black
            
            let priceLabel = UILabel()
            priceLabel.text = price
            priceLabel.font = UIFont.systemFont(ofSize: 16)
            priceLabel.textColor = .black
            
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
