//
//  PlansMenuViewController.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 29/01/25.
//

import UIKit

enum LocalWeekDay: String {
    case sunday, monday, tuesday, wednesday, thursday, friday, saturday
}

class PlansMenuViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource , WeekDaysSelectionDelegate{
    
 
    enum DayOfWeek: String, CaseIterable {
        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
        
        // Convert DayOfWeek to WeekDay
        func toWeekDay() -> WeekDay {
            return WeekDay(rawValue: self.rawValue) ?? .monday
        }
    }


    @IBOutlet var subscriptionPlan: UICollectionView!

    private var selectedDay: String = "Monday" // Default selection
        private var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
        }
        
        // MARK: - Setup UI
        private func setupUI() {
            self.view.backgroundColor = .white
            self.title = "Plan Menu"
            
            let subscribeButton = UIBarButtonItem(title: "Subscribe", style: .plain, target: self, action: #selector(didTapSeeMoreToSubscriptionPlans))
            self.navigationItem.rightBarButtonItem = subscribeButton
            
            // Registering Nibs for Cells
            subscriptionPlan.register(UINib(nibName: "PlansMenu", bundle: nil), forCellWithReuseIdentifier: "PlansMenu")
            subscriptionPlan.register(UINib(nibName: "WeekDays", bundle: nil), forCellWithReuseIdentifier: "WeekDays")
            
            subscriptionPlan.setCollectionViewLayout(generateLayout(), animated: true)
            subscriptionPlan.dataSource = self
            subscriptionPlan.delegate = self
        }

        // MARK: - Number of Sections
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 2
        }

        // MARK: - Number of Items in Section
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            switch section {
            case 0:
                return days.count // 7 Days in a Week
            case 1:
                return getMenuForSelectedDay().count
            default:
                return 0
            }
        }

        // MARK: - Cell Configuration
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch indexPath.section {
            case 0:  // Week Days Section
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDays", for: indexPath) as! WeekDaysCollectionViewCell
                let day = days[indexPath.item]
                
                cell.configure(with: day)
                cell.delegate = self
                cell.highlightSelection(day == selectedDay)
                
                cell.layer.cornerRadius = 10.0
                cell.layer.borderWidth = 1.0
                cell.layer.borderColor = UIColor.accent.cgColor
                return cell
  
            case 1:  // Menu Items Section
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlansMenu", for: indexPath) as! PlansMenuCollectionViewCell
                let meals = getMenuForSelectedDay()
                
                // ✅ Define a fixed meal order
                let orderedMealTypes: [MealType] = [.breakfast, .lunch, .snacks, .dinner]
                
                // ✅ Get meals in fixed order (ignore missing ones)
                let sortedMeals = orderedMealTypes.compactMap { mealType -> (MealType, MenuItem)? in
                    if let mealItem = meals[mealType] ?? nil {  // ✅ Check for nil before using
                        return (mealType, mealItem)
                    }
                    return nil
                }

                // ✅ Prevent out-of-bounds crash if no meals exist
                guard indexPath.item < sortedMeals.count else {
                    return UICollectionViewCell()
                }

                // ✅ Get the current meal for this cell
                let (mealKey, mealItem) = sortedMeals[indexPath.item]

                // ✅ Extract meal details safely
                let mealName = mealItem.name
                let mealDescription = mealItem.description
                let mealImageName = mealItem.imageURL.isEmpty ? "default_meal" : mealItem.imageURL

                // ✅ Update the cell with sorted meal details
                cell.updateMenuDetails(
                    mealType: mealKey.rawValue,
                    mealName: mealName,
                    mealDescription: mealDescription,
                    mealImageName: mealImageName
                )

                return cell


            default:
                return UICollectionViewCell()
            }
        }

        // MARK: - Handling Day Selection
        func didSelectDay(_ day: String) {
            selectedDay = day
            subscriptionPlan.reloadSections(IndexSet(integer: 0)) // Reload Days for Selection Highlight
            subscriptionPlan.reloadSections(IndexSet(integer: 1)) // Reload Menu
        }

        // ✅ FIXED: Returns full MenuItem instead of just meal name
        private func getMenuForSelectedDay() -> [MealType: MenuItem?] {
            guard let plan = KitchenDataController.subscriptionPlan.first else { return [:] }

            // Convert selectedDay string to DayOfWeek
            let selectedDayEnum = DayOfWeek(rawValue: selectedDay.lowercased()) ?? .monday

            // Convert DayOfWeek to WeekDay
            let weekDayEnum = selectedDayEnum.toWeekDay()

            // Fetch meals for the selected day
            return plan.weeklyMeals?[weekDayEnum] ?? [:]  // Returns [MealType: MenuItem?]
        }

        // MARK: - Layout for Sections
        func generateLayout() -> UICollectionViewLayout {
            return UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
                switch sectionIndex {
                case 0:
                    return self.generateMenuCalendarSectionLayout()
                case 1:
                    return self.generateMenuListSectionLayout()
                default:
                    return nil
                }
            }
        }
        
        // MARK: - Week Days Layout
        func generateMenuCalendarSectionLayout() -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.18), heightDimension: .absolute(70))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 8.0, bottom: 8.0, trailing: 5.0)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 15)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }

        // MARK: - Menu List Layout
        func generateMenuListSectionLayout() -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)

            return section
        }

        // MARK: - Navigation Action
        @objc func didTapSeeMoreToSubscriptionPlans() {
            let alert = UIAlertController(title: "", message: "This kitchen provides plans for a minimum of 2 days and a maximum of 7 days.", preferredStyle: .alert)
            let acceptAction = UIAlertAction(title: "Accept", style: .default) { _ in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "SubscriptionViewController") as? SubscriptionViewController {
                    self.navigationController?.pushViewController(firstScreenVC, animated: true)
                }
            }
            alert.addAction(acceptAction)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }
