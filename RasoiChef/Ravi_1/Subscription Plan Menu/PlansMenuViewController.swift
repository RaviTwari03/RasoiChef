//
//  PlansMenuViewController.swift
//  RasoiChef
//
//  Created by Ravi Tiwari on 29/01/25.
//

import UIKit

class PlansMenuViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.title = "Menu"
//       
//    }
    
    
    @IBOutlet var subscriptionPlan: UICollectionView!
    
    override func viewDidLoad() {
        self.navigationItem.largeTitleDisplayMode = .never
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Menu"
        let seeMoreButton = UIBarButtonItem(title: "Subscribe", style: .plain, target: self, action: #selector(didTapSeeMoreToSubscriptionPlans))
            self.navigationItem.rightBarButtonItem = seeMoreButton
       
        
        // Registering Nibs for Cells
        let PlansMenuNib = UINib(nibName: "PlansMenu", bundle: nil)
        let WeekDaysNib = UINib(nibName: "WeekDays", bundle: nil)
        
        subscriptionPlan.register(PlansMenuNib, forCellWithReuseIdentifier: "PlansMenu")
        subscriptionPlan.register(WeekDaysNib, forCellWithReuseIdentifier: "WeekDays")
        
        // Setting Layout
        subscriptionPlan.setCollectionViewLayout(generateLayout(), animated: true)
        subscriptionPlan.dataSource = self
        subscriptionPlan.delegate = self
    }
    
    
    // MARK: - Number of Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    // MARK: - Number of Items in Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7
        case 1:
            return KitchenDataController.menuItems.count
        default:
            return 0
        }
    }
    
    
    // MARK: - Cell for Item at IndexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekDays", for: indexPath) as! WeekDaysCollectionViewCell
            let days = ["Sunday" ,"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
            let selectedDay = days[indexPath.item]
//            changeScreen(forDay: selectedDay)
                // Call the weekDay() function and pass the corresponding weekday
                cell.weekDay(day: days[indexPath.item])
            cell.layer.cornerRadius = 10.0
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.orange.cgColor
            cell.layer.shadowColor = UIColor.black.cgColor
//            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.shadowRadius = 5.0
//            cell.layer.shadowOpacity = 0.2
            cell.layer.masksToBounds = false
//            cell.layer.shadowColor = UIColor.black.cgColor
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlansMenu", for: indexPath) as! PlansMenuCollectionViewCell
            cell.updateMenuDetails(with: indexPath)
            
            
            return cell
//        case 1:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KitchenMenu", for: indexPath) as! KitchenMenuCollectionViewCell
//            cell.updateMealDetails(with: indexPath)
//            cell.delegate = self
//            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    
    // MARK: - Compositional Layout
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let section: NSCollectionLayoutSection
            switch sectionIndex {
            case 0:
                section = self.generateMenuCalenderSectionLayout()
            case 1:
                section = self.generateMenuListSectionLayout()
                
            default:
                return nil
            }
            
            return section
        }
        return layout
    }
    // Calendar Section Layout
    func generateMenuCalenderSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.20), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 8.0, bottom: 8.0, trailing: 0.0)
        group.interItemSpacing = .fixed(0)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10.0, leading: 8.0, bottom: 10.0, trailing: 8.0)

        return section
    }
    // Menu List Section Layout
    func generateMenuListSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0.0, bottom: 0.0, trailing: 0.0)
        group.interItemSpacing = .fixed(0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0.0, bottom: 0, trailing: 0.0)
        section.interGroupSpacing = 0

        return section
    }
    @objc func didTapSeeMoreToSubscriptionPlans() {
        let alert = UIAlertController(
            title: "", message: "This kitchen provides plans for a minimum of 2 days and a maximum of 7 days.",
                                      preferredStyle: .alert)

        let acceptAction = UIAlertAction(title: "Accept", style: .default) { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "SubscriptionViewController") as? SubscriptionViewController {
                self.navigationController?.pushViewController(firstScreenVC, animated: true)
            }
        }

        alert.addAction(acceptAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
//    func changeScreen(forDay day: String) {
//        switch day {
//        case "Sunday":
//            performSegue(withIdentifier: "showSunday", sender: nil)
//        case "Monday":
//            performSegue(withIdentifier: "showMonday", sender: nil)
//        case "Tuesday":
//            performSegue(withIdentifier: "showTuesday", sender: nil)
//        case "Wednesday":
//            performSegue(withIdentifier: "showWednesday", sender: nil)
//        case "Thursday":
//            performSegue(withIdentifier: "showThursday", sender: nil)
//        case "Friday":
//            performSegue(withIdentifier: "showFriday", sender: nil)
//        case "Saturday":
//            performSegue(withIdentifier: "showSaturday", sender: nil)
//        
//        default:
//            break
//        }
//    }

}
