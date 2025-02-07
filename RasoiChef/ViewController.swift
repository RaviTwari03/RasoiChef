//
//  ViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 17/01/25.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, MenuDetailsCellDelegate,UICollectionViewDelegateFlowLayout, MenuListHeaderDelegate,ChefSpeacialityHeaderDelegate,MealSubscriptionPlanHeaderDelegate {
    
   
    
    
    
    
    
    @IBOutlet var collectionView1: UICollectionView!
    var kitchenData: Kitchen?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Kanha Ji Rasoi"
        self.navigationItem.largeTitleDisplayMode = .never
        
        // Registering Nibs for Cells
        let kitchenDetailsNib = UINib(nibName: "KitchenDetails", bundle: nil)
        let menuDetailsNib = UINib(nibName: "MenuDetails", bundle: nil)
        let chefSpecialDishesNib = UINib(nibName: "ChefSpecialDishes", bundle: nil)
        let subscriptionDetailsNib = UINib(nibName: "SubscriptionDetails", bundle: nil)
        let MenuListHeaderNib = UINib(nibName: "MenuListHeader", bundle: nil)
        let ChefSpecialityDishesHeaderNib = UINib(nibName: "ChefSpecialityDishesHeader", bundle: nil)
        let MealSubscriptionPlanNib = UINib(nibName: "MealSubscriptionPlanHeader", bundle: nil)
        
        
        collectionView1.register(kitchenDetailsNib, forCellWithReuseIdentifier: "KitchenDetails")
        collectionView1.register(menuDetailsNib, forCellWithReuseIdentifier: "MenuDetails")
        collectionView1.register(chefSpecialDishesNib, forCellWithReuseIdentifier: "ChefSpecialDishes")
        collectionView1.register(subscriptionDetailsNib, forCellWithReuseIdentifier: "SubscriptionDetails")
        collectionView1.register(MenuListHeaderNib, forCellWithReuseIdentifier: "MenuListHeader")
        collectionView1.register(ChefSpecialityDishesHeaderNib, forCellWithReuseIdentifier: "ChefSpecialityDishesHeader")
        collectionView1.register(MealSubscriptionPlanNib, forCellWithReuseIdentifier: "MealSubscriptionPlanHeader")
        

        
        collectionView1.setCollectionViewLayout(generateLayout(), animated: true)
        collectionView1.dataSource = self
        collectionView1.delegate = self
    }
    
    // MARK: - Number of Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    // MARK: - Number of Items in Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 // Single restaurant/kitchen details
        case 1:
            return 1
        case 2:
            return KitchenDataController.menuItems.count
        case 3:
            return 1
        case 4:
            return KitchenDataController.chefSpecialtyDishes.count
        case 5:
            return 1
        case 6:
            return KitchenDataController.subscriptionPlan.count
        default:
            return 0
        }
    }
    
    
    
   
    // MARK: - Cell for Item at IndexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KitchenDetails", for: indexPath) as! KitchenDetailsCollectionViewCell
            cell.updateKitchenDetails()
            cell.layer.cornerRadius = 8.0
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuListHeader", for: indexPath) as! MenuListHeaderCollectionViewCell
            cell.delegate = self
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuDetails", for: indexPath) as! MenuDetailsCollectionViewCell
            cell.delegate = self
            cell.updateMenuDetails(with : indexPath)

            return cell
            
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChefSpecialityDishesHeader", for: indexPath) as! ChefSpecialityDishCollectionViewCell
            cell.delegate = self
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChefSpecialDishes", for: indexPath) as! ChefSpecialCollectionViewCell
            cell.updateChefSpecialtyDetails(for: indexPath)
            
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealSubscriptionPlanHeader", for: indexPath) as! MealSubscriptionPlanHeaderCollectionViewCell
            cell.delegate = self
            return cell
            
        case 6:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionDetails", for: indexPath) as! SubscriptionDetailsCollectionViewCell
            cell.updateSubscriptionPlanData(for: indexPath)
            cell.layer.cornerRadius = 15.0 
            return cell
            
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
                section = self.generateKitchenSectionLayout()
            case 1:
                section = self.MenuListHeaderSectionLayout()
            case 2:
                section = self.generateMenuCategorySectionLayout()
            case 3:
                section = self.generateChefSpecialityDishCollectionViewCell()
            case 4:
                section = self.generateChefSpecialSectionLayout()
            case 5:
                section = self.generateMealSubscriptionPlanHeader()
            case 6:
                section = self.generateSubscriptionPlanSectionLayout()
            default:
                return nil
            }
            
           
            return section
        }
        return layout
    }
    
    // Layout for Kitchen Details Section
    func generateKitchenSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    func MenuListHeaderSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Adjust the height of the section item to a bigger size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 0.0)
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
   
    // Layout for Menu Categories Section
    func generateMenuCategorySectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(260))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        //        group.interItemSpacing = .fixed(5)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8.0, bottom: 8, trailing: 0.0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    func generateChefSpecialityDishCollectionViewCell() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Adjust the height of the section item to a bigger size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(55))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 0.0)
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    func generateMealSubscriptionPlanHeader() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Adjust the height of the section item to a bigger size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(90))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 0.0)
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    // Layout for Chef's Special Section
    func generateChefSpecialSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(5)
        group.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 0.0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
        
    }
    
    func generateSubscriptionPlanSectionLayout() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // Define group size and layout
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(140))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            // Add content insets to the group
            group.interItemSpacing = .fixed(5)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8.0, bottom: 20.0, trailing: 8.0) // No insets on 
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 10, trailing: 10)
        return section
    }
    
    //    MARK: - For ADD button in the menu items cell
    func MenuListaddButtonTapped(in cell: MenuDetailsCollectionViewCell) {
        guard let indexPath = collectionView1.indexPath(for: cell) else { return }
        let selectedItem = KitchenDataController.menuItems[indexPath.row]
        print("Add button tapped for meal: \(selectedItem.name)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "AddItemModallyViewController") as? AddItemModallyViewController {
            detailVC.selectedItem = selectedItem
            
            detailVC.modalPresentationStyle = .pageSheet
            
            if let sheet = detailVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            
            present(detailVC, animated: true, completion: nil)
        } else {
            print("Error: Could not instantiate AddItemModallyViewController")
        }
        
    }
    
    
    
    
    
    @objc func sectionButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "KitchenMenuListViewController") as? KitchenMenuListViewController {
                self.navigationController?.pushViewController(firstScreenVC, animated: true)
            } else {
                print("Error: Could not instantiate KitchenMenuListViewController")
            }
            
        case 2:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let secondScreenVC = storyboard.instantiateViewController(withIdentifier: "KitchenChefSpecialViewController") as? KitchenChefSpecialViewController {
                self.navigationController?.pushViewController(secondScreenVC, animated: true)
            } else {
                print("Error: Could not instantiate KitchenChefSpecialViewController")
            }
        case 3:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let thirdScreenVC = storyboard.instantiateViewController(withIdentifier: "SubscriptionViewController") as? SubscriptionViewController {
                self.navigationController?.pushViewController(thirdScreenVC, animated: true)
            } else {
                print("Error: Could not instantiate KitchenChefSpecialViewController")
            }
        default:
            break
        }
    }
    
    
    
    
    @IBAction func cross(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    func didTapSeeMore() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "KitchenMenuListViewController") as? KitchenMenuListViewController {
            self.navigationController?.pushViewController(firstScreenVC, animated: true)
        }
        
    }
    
    func didTapSeeMore1() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "KitchenChefSpecialViewController") as? KitchenChefSpecialViewController {
            self.navigationController?.pushViewController(firstScreenVC, animated: true)
        }
        
        
        
    }
   
    func didTapSeeMorePlansMenu() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "PlansMenuViewController") as? PlansMenuViewController {
            self.navigationController?.pushViewController(firstScreenVC, animated: true)
        }
    }
    func didTapSeeMoreToSubscriptionPlans() {
        let alert = UIAlertController(title: "",
                                      message: "This kitchen provides plans for a minimum of 2 days and a maximum of 7 days.",
                                      preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "SubscriptionViewController") as? SubscriptionViewController {
                self.navigationController?.pushViewController(firstScreenVC, animated: true)
            }
        }
        
        let declineAction = UIAlertAction(title: "Decline", style: .cancel, handler: nil)

        alert.addAction(acceptAction)
        alert.addAction(declineAction)
        
        present(alert, animated: true, completion: nil)
    }

}
