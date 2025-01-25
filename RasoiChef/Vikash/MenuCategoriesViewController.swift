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
    
//    var MenuCategories: MenuItem?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//     
//        // Registering Nibs for Cells
//        let kitchenDetailsNib = UINib(nibName: "MealCategories", bundle: nil)
//        
//        MealCategories.register(kitchenDetailsNib, forCellWithReuseIdentifier: "MealCategories")
//
//        MealCategories.setCollectionViewLayout(generateLayout(), animated: true)
//        MealCategories.dataSource = self
//        MealCategories.delegate = self
//    }
//    
//    // MARK: - Number of Sections
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    // MARK: - Number of Items in Section
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 1 // Single restaurant/kitchen details
//
//        default:
//            return 0
//        }
//    }
////    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
////        if kind == UICollectionView.elementKindSectionHeader {
////            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader1CollectionReusableView
////
////            // Switch case for section headers
////            switch indexPath.section {
////            case 0:
////                header.headerLabel.text = ""
////            case 1:
////                header.headerLabel.text = KitchenDataController.sectionHeaderNames[0]
////            case 2:
////                header.headerLabel.text = KitchenDataController.sectionHeaderNames[1]
////            case 3:
////                header.headerLabel.text = KitchenDataController.sectionHeaderNames[2]
////            default:
////                header.headerLabel.text = "Section \(indexPath.section)" // Default case to prevent out of range error
////            }
////            if header.headerLabel.text == "" {
////                header.actionButton.isHidden = true
////                header.headerLabel.font = UIFont.systemFont(ofSize: 0, weight: .regular)
////            } else {
////                header.actionButton.isHidden = false
////                header.headerLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
////            }
////
////            header.headerLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
////            header.actionButton.setTitle("See All", for: .normal)
////
////        header.actionButton.tag = indexPath.section
////        header.actionButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
////
////
////            return header
////        }
////        print("Supplementary View Not Found")
////        return UICollectionReusableView()
////    }
//// func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
////     if kind == UICollectionView.elementKindSectionHeader {
////         let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MenuCategories", for: indexPath) as! MenuCategoriesCollectionViewCell
//
//         // Set header titles dynamically
////         switch indexPath.section {
////         case 0:
////             header.headerLabel.text = ""
////         case 1:
////             header.headerLabel.text = KitchenDataController.sectionHeaderNames[0]
////         case 2:
////             header.headerLabel.text = KitchenDataController.sectionHeaderNames[1]
////         case 3:
////             header.headerLabel.text = KitchenDataController.sectionHeaderNames[2]
////         default:
////             header.headerLabel.text = "Section \(indexPath.section)" // Default case
////         }
////
////         // Adjust visibility and font
////         if header.headerLabel.text?.isEmpty == true {
////             header.actionButton.isHidden = true
////         } else {
////             header.actionButton.isHidden = false
////             header.headerLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
////         }
////
////         header.actionButton.setTitle("See All", for: .normal)
////         header.actionButton.tag = indexPath.section
////         header.actionButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
////         return header
////     }
////     print("Supplementary View Not Found")
////     return UICollectionReusableView()
//// }
//
// func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//     switch section {
//     case 0:
//         return CGSize(width: collectionView.bounds.width, height: 0) // No header
//
//     default:
//         return CGSize(width: collectionView.bounds.width, height: 50) // Default header size
//     }
// }
//
//
//    // MARK: - Cell for Item at IndexPath
// func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//     switch indexPath.section {
//     case 0:
//         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCategories", for: indexPath) as! MenuCategoriesCollectionViewCell
//         cell.updateMealDetails(with: indexPath)
//         cell.layer.cornerRadius = 8.0
//         return cell
//
//     default:
//         return UICollectionViewCell()
//     }
// }
//
//    
//    // MARK: - Compositional Layout
//    func generateLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
//            let section: NSCollectionLayoutSection
//            switch sectionIndex {
//            case 0:
//                section = self.generateKitchenSectionLayout()
//           
//            default:
//                return nil
//            }
//            
//            // Add Header
//            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
//            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//            section.boundarySupplementaryItems = [header]
//            
//            return section
//        }
//        return layout
//    }
//    
//    // Layout for Kitchen Details Section
//    func generateKitchenSectionLayout() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .groupPaging
//        return section
//    }
//    
// 
////    MARK: - For ADD button in the menu items cell
//// func MenuListaddButtonTapped(in cell: MenuDetailsCollectionViewCell) {
////     guard let indexPath = collectionView1.indexPath(for: cell) else { return }
////     let selectedItem = KitchenDataController.menuItems[indexPath.row]
////     print("Add button tapped for meal: \(selectedItem.name)")
////
////     let storyboard = UIStoryboard(name: "Main", bundle: nil)
////     if let detailVC = storyboard.instantiateViewController(withIdentifier: "AddItemModallyViewController") as? AddItemModallyViewController {
////         detailVC.selectedItem = selectedItem
////
////         detailVC.modalPresentationStyle = .pageSheet
////
////         if let sheet = detailVC.sheetPresentationController {
////             sheet.detents = [.medium(), .large()]
////             sheet.prefersGrabberVisible = true
////         }
////
////         present(detailVC, animated: true, completion: nil)
////     } else {
////         print("Error: Could not instantiate AddItemModallyViewController")
////     }
//// }
//
//
//
// 
//
// @objc func sectionButtonTapped(_ sender: UIButton) {
//     switch sender.tag {
//     case 1:
//         let storyboard = UIStoryboard(name: "Main", bundle: nil)
//         if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "KitchenMenuListViewController") as? KitchenMenuListViewController {
//             self.navigationController?.pushViewController(firstScreenVC, animated: true)
//         } else {
//             print("Error: Could not instantiate KitchenMenuListViewController")
//         }
//
//     case 2:
//         let storyboard = UIStoryboard(name: "Main", bundle: nil)
//         if let secondScreenVC = storyboard.instantiateViewController(withIdentifier: "KitchenChefSpecialViewController") as? KitchenChefSpecialViewController {
//             self.navigationController?.pushViewController(secondScreenVC, animated: true)
//         } else {
//             print("Error: Could not instantiate KitchenChefSpecialViewController")
//         }
//     case 3:
//         let storyboard = UIStoryboard(name: "Main", bundle: nil)
//         if let thirdScreenVC = storyboard.instantiateViewController(withIdentifier: "SubscriptionViewController") as? SubscriptionViewController {
//             self.navigationController?.pushViewController(thirdScreenVC, animated: true)
//         } else {
//             print("Error: Could not instantiate KitchenChefSpecialViewController")
//         }
//     default:
//         break
//     }
// }
//
// }
//    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           // Register the custom cell XIB
           let menuCategoriesNib = UINib(nibName: "MealCategories", bundle: nil)
           MealCategories.register(menuCategoriesNib, forCellWithReuseIdentifier: "MealCategories")
           
           // Set up collection view layout
           MealCategories.collectionViewLayout = generateLayout()
           
           // Set the delegate and data source
           MealCategories.delegate = self
           MealCategories.dataSource = self
           
           // Debug: Check if data is received correctly
           print("Received Menu Categories: \(MenuCategories)")
       }

       // MARK: - UICollectionViewDataSource

       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return MenuCategories.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealCategories", for: indexPath) as! MenuCategoriesCollectionViewCell
           
           // Configure the cell with the menu item data
           let menuItem = MenuCategories[indexPath.row]
           cell.configure(with: indexPath)
           
           return cell
       }

       // MARK: - Layout Setup
       private func generateLayout() -> UICollectionViewLayout {
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)

           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
           let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

           let section = NSCollectionLayoutSection(group: group)
           return UICollectionViewCompositionalLayout(section: section)
       }
   }
