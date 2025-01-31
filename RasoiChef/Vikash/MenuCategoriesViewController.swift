//
//  MenuCategoriesViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 24/01/25.
//

import UIKit

class MenuCategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    @IBOutlet weak var MealCategories: UICollectionView!
    
    var MenuCategories: [MenuItem] = []
 
           func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
               return 4
           }
    
           func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCategories", for: indexPath) as! MenuCategoriesCollectionViewCell
   
               cell.updateMealDetails(with: indexPath)
    
    
               return cell
           }
    //
    //       // MARK: - Layout Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Menu Categories"
        self.navigationItem.largeTitleDisplayMode = .never
        
        // Register the custom cell XIB
        let menuCategoriesNib = UINib(nibName: "MealCategories", bundle: nil)
        MealCategories.register(menuCategoriesNib, forCellWithReuseIdentifier: "MealCategories")
        
        // Set up collection view layout
        MealCategories.collectionViewLayout = generateLayout()
        
        // Set the delegate and data source
        MealCategories.delegate = self
        MealCategories.dataSource = self
        
        // Reload data
        MealCategories.reloadData()
        
        // Debugging
        print("Received Menu Categories: \(MenuCategories)")
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 { // Banner tapped
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let mealCategoriesVC = storyboard.instantiateViewController(withIdentifier: "MenuCategoriesViewController") as? MenuCategoriesViewController {
                
                // Pass data (Make sure `MenuCategories` is set properly)
                mealCategoriesVC.MenuCategories = KitchenDataController.menuItems
                
                self.navigationController?.pushViewController(mealCategoriesVC, animated: true)
            }
        }
    }
     func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}

