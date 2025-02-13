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
    
    
    
    // Define the WeekDay enum globally, outside of any class
   

//    enum WeekDay: String {
//        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
//    }

    // Assuming `DayOfWeek` is used somewhere else in your code
//    enum DayOfWeek: String {
//
//        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
//
//        // Convert to WeekDay
//        func toWeekDay() -> WeekDay {
//            return WeekDay(rawValue: self.rawValue) ?? .monday
//        }
//    }

    enum DayOfWeek: String, CaseIterable {
        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
        
        // Convert DayOfWeek to WeekDay
        func toWeekDay() -> WeekDay {
            return WeekDay(rawValue: self.rawValue) ?? .monday
        }
    }


    @IBOutlet var subscriptionPlan: UICollectionView!
//    private var selectedDay: String = "Monday" // Default to Monday
//    
//    
//    override func viewDidLoad() {
//        self.navigationItem.largeTitleDisplayMode = .never
//        super.viewDidLoad()
//        self.view.backgroundColor = .white
//        self.title = "Menu"
//        let seeMoreButton = UIBarButtonItem(title: "Subscribe", style: .plain, target: self, action: #selector(didTapSeeMoreToSubscriptionPlans))
//            self.navigationItem.rightBarButtonItem = seeMoreButton
//       
//        
//        // Registering Nibs for Cells
//        let PlansMenuNib = UINib(nibName: "PlansMenu", bundle: nil)
//        let WeekDaysNib = UINib(nibName: "WeekDays", bundle: nil)
//        
//        subscriptionPlan.register(PlansMenuNib, forCellWithReuseIdentifier: "PlansMenu")
//        subscriptionPlan.register(WeekDaysNib, forCellWithReuseIdentifier: "WeekDays")
//        
//        // Setting Layout
//        subscriptionPlan.setCollectionViewLayout(generateLayout(), animated: true)
//        subscriptionPlan.dataSource = self
//        subscriptionPlan.delegate = self
//    }
//    
//    
//    // MARK: - Number of Sections
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 5
//    }
//    
//    // MARK: - Number of Items in Section
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 7
//        case 1:
//            return KitchenDataController.menuItems.count
//        default:
//            return 0
//        }
//    }
//    
//    
//    // MARK: - Cell for Item at IndexPath
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.section {
//        case 0:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDays", for: indexPath) as! WeekDaysCollectionViewCell
//            let days = ["Sunday" ,"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
//            let selectedDay = days[indexPath.item]
////            changeScreen(forDay: selectedDay)
//                // Call the weekDay() function and pass the corresponding weekday
//                cell.weekDay(day: days[indexPath.item])
//            cell.layer.cornerRadius = 10.0
//            cell.layer.borderWidth = 1.0
//            cell.layer.borderColor = UIColor.orange.cgColor
//            cell.layer.shadowColor = UIColor.black.cgColor
////            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
//            cell.layer.shadowRadius = 5.0
////            cell.layer.shadowOpacity = 0.2
//            cell.layer.masksToBounds = false
////            cell.layer.shadowColor = UIColor.black.cgColor
//            return cell
//        case 1:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlansMenu", for: indexPath) as! PlansMenuCollectionViewCell
//            cell.updateMenuDetails(with: indexPath)
//            
//            
//            return cell
////        case 1:
////            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KitchenMenu", for: indexPath) as! KitchenMenuCollectionViewCell
////            cell.updateMealDetails(with: indexPath)
////            cell.delegate = self
////            return cell
//            
//        default:
//            return UICollectionViewCell()
//        }
//    }
//    
//    
//    // MARK: - Compositional Layout
//    func generateLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
//            let section: NSCollectionLayoutSection
//            switch sectionIndex {
//            case 0:
//                section = self.generateMenuCalenderSectionLayout()
//            case 1:
//                section = self.generateMenuListSectionLayout()
//                
//            default:
//                return nil
//            }
//            
//            return section
//        }
//        return layout
//    }
//    // Calendar Section Layout
//    func generateMenuCalenderSectionLayout() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.20), heightDimension: .absolute(70))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 8.0, bottom: 8.0, trailing: 0.0)
//        group.interItemSpacing = .fixed(0)
//
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
////        section.contentInsets = NSDirectionalEdgeInsets(top: 10.0, leading: 8.0, bottom: 10.0, trailing: 8.0)
//
//        return section
//    }
//    // Menu List Section Layout
//    func generateMenuListSectionLayout() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0.0, bottom: 0.0, trailing: 0.0)
//        group.interItemSpacing = .fixed(0)
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0.0, bottom: 0, trailing: 0.0)
//        section.interGroupSpacing = 0
//
//        return section
//    }
//    @objc func didTapSeeMoreToSubscriptionPlans() {
//        let alert = UIAlertController(
//            title: "", message: "This kitchen provides plans for a minimum of 2 days and a maximum of 7 days.",
//                                      preferredStyle: .alert)
//
//        let acceptAction = UIAlertAction(title: "Accept", style: .default) { _ in
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "SubscriptionViewController") as? SubscriptionViewController {
//                self.navigationController?.pushViewController(firstScreenVC, animated: true)
//            }
//        }
//
//        alert.addAction(acceptAction)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        
//        present(alert, animated: true, completion: nil)
//    }
//
//    func didSelectDay(_ day: String) {
//        selectedDay = day
//        subscriptionPlan.reloadSections(IndexSet(integer: 1))
//        subscriptionPlan.reloadSections(IndexSet(integer: 1))
//
//    }
//    
//}
    private var selectedDay: String = "Monday" // Default to Monday
        private var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            self.title = " Plan Menu"
            
            let seeMoreButton = UIBarButtonItem(title: "Subscribe", style: .plain, target: self, action: #selector(didTapSeeMoreToSubscriptionPlans))
            self.navigationItem.rightBarButtonItem = seeMoreButton

            // Registering Nibs for Cells
            let plansMenuNib = UINib(nibName: "PlansMenu", bundle: nil)
            let weekDaysNib = UINib(nibName: "WeekDays", bundle: nil)
            
            subscriptionPlan.register(plansMenuNib, forCellWithReuseIdentifier: "PlansMenu")
            subscriptionPlan.register(weekDaysNib, forCellWithReuseIdentifier: "WeekDays")
            
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

        // MARK: - Cell for Item at IndexPath
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch indexPath.section {
            case 0:  // Week Days
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDays", for: indexPath) as! WeekDaysCollectionViewCell
                let day = days[indexPath.item]
                
                cell.configure(with: day)
                cell.delegate = self  // Assign delegate
                cell.highlightSelection(day == selectedDay) // Highlight if selected
                cell.layer.cornerRadius = 10.0
                            cell.layer.borderWidth = 1.0
                            cell.layer.borderColor = UIColor.orange.cgColor
                          //  cell.layer.shadowColor = UIColor.black.cgColor
                //            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
                         //   cell.layer.shadowRadius = 5.0
                //            cell.layer.shadowOpacity = 0.2
                        //    cell.layer.masksToBounds = false
                //            cell.layer.shadowColor = UIColor.black.cgColor
                return cell
                
            case 1:  // Menu Items
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlansMenu", for: indexPath) as! PlansMenuCollectionViewCell
                cell.updateMenuDetails(with: indexPath)
//                let meals = getMenuForSelectedDay()
//                let mealKey = Array(meals.keys)[indexPath.item]
//                let mealValue = meals[mealKey] ?? ""
//                
//                cell.updateMenuDetails(mealType: mealKey.rawValue, mealName: mealValue, mealDescription: "iii")
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
        
        // MARK: - Get Menu for Selected Day
//        private func getMenuForSelectedDay() -> [MealType: String] {
//            guard let plan = KitchenDataController.subscriptionPlan.first else { return [:] }
//            let selectedDayEnum = DayOfWeek(rawValue: selectedDay.lowercased()) ?? .monday
//            return plan.weeklyMeals[selectedDayEnum] ?? [:]
//        }
//    private func getMenuForSelectedDay() -> [MealType: String] {
//        guard let plan = KitchenDataController.subscriptionPlan.first else { return [:] }
//        
//        // Convert DayOfWeek to WeekDay
//        let selectedDayEnum = DayOfWeek(rawValue: selectedDay.lowercased()) ?? .monday
//        let weekDayEnum = selectedDayEnum.toWeekDay()  // Conversion to WeekDay
//        
//        return plan.weeklyMeals[weekDayEnum] ?? [:]
//    }
//    private func getMenuForSelectedDay() -> [MealType: String] {
//        guard let plan = KitchenDataController.subscriptionPlan.first else { return [:] }
//        
//        // Convert selectedDay string to DayOfWeek
//        let selectedDayEnum = DayOfWeek(rawValue: selectedDay.lowercased()) ?? .monday
//        
//        // Convert DayOfWeek to WeekDay
//        let weekDayEnum = selectedDayEnum.toWeekDay()
//        
//        // Fetch the meals for the selected day
//        return plan.weeklyMeals[weekDayEnum] ?? [:]
//    }
    private func getMenuForSelectedDay() -> [MealType: String] {
        guard let plan = KitchenDataController.subscriptionPlan.first else { return [:] }
        
        // Convert selectedDay string to DayOfWeek
        let selectedDayEnum = DayOfWeek(rawValue: selectedDay.lowercased()) ?? .monday
        
        // Convert DayOfWeek to WeekDay
        let weekDayEnum = selectedDayEnum.toWeekDay()
        
        // Fetch the meals for the selected day
        guard let mealsForDay = plan.weeklyMeals?[weekDayEnum] else { return [:] }
        
        // Map MenuItem? to its name string, filtering out nil values
        return mealsForDay.compactMapValues { menuItem in
            menuItem?.name ?? ""  // Return an empty string if MenuItem is nil
        }
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

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.20), heightDimension: .absolute(80))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 8.0, bottom: 8.0, trailing: 0.0)

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }

        // MARK: - Menu List Layout
        func generateMenuListSectionLayout() -> NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
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
