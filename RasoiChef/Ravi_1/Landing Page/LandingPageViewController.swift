//
//  LandingPageViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 19/01/25.
//

import UIKit

class LandingPageViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var LandingPage: UICollectionView!
    
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
        self.title = "Home"
           // Registering Nibs for Cells
           let BannerDetailsNib = UINib(nibName: "LandingPageBanner", bundle: nil)
           let LandingPageChefSpecialNib = UINib(nibName: "LandingPageChefSpecial", bundle: nil)
           let LandingPageKitchenNib = UINib(nibName: "LandingPageKitchen", bundle: nil)
           
           
        LandingPage.register(BannerDetailsNib, forCellWithReuseIdentifier: "LandingPageBanner")
        LandingPage.register(LandingPageChefSpecialNib, forCellWithReuseIdentifier: "LandingPageChefSpecial")
        LandingPage.register(LandingPageKitchenNib, forCellWithReuseIdentifier: "LandingPageKitchen")
        
           
           // Setting Layout
        LandingPage.register(SectionHeaderLandingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderLanding")
//        header.actionButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)


        LandingPage.setCollectionViewLayout(generateLayout(), animated: true)
        LandingPage.dataSource = self
        LandingPage.delegate = self
       }
       
       // MARK: - Number of Sections
       func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 5
       }
       
       // MARK: - Number of Items in Section
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           switch section {
           case 0:
               return KitchenDataController.mealBanner.count
           case 1:
               return KitchenDataController.chefSpecialtyDishes.count
           case 2:
               return KitchenDataController.kitchens.count
           
           default:
               return 0
           }
       }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderLanding", for: indexPath) as! SectionHeaderLandingCollectionReusableView
            
            // Switch case for section headers
            switch indexPath.section {
            case 0:
                header.headerLabel.text = KitchenDataController.sectionHeaderLandingNames[0]
            case 1:
                header.headerLabel.text = KitchenDataController.sectionHeaderLandingNames[1]
            case 2:
                header.headerLabel.text = KitchenDataController.sectionHeaderLandingNames[2]
           
            default:
                header.headerLabel.text = "Section \(indexPath.section)" // Default case to prevent out of range error
            }
            if header.headerLabel.text == "" {
                header.actionButton.isHidden = true
                header.headerLabel.font = UIFont.systemFont(ofSize: 0, weight: .regular)
            } else {
                header.actionButton.isHidden = false
                header.headerLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
            }
            if header.headerLabel.text == "Meal Categories" {
                header.actionButton.isHidden = true
                header.headerLabel.font = UIFont.systemFont(ofSize: 0, weight: .regular)
            } else {
                header.actionButton.isHidden = false
                header.headerLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
            }
            
            header.headerLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
            header.actionButton.setTitle("See All", for: .normal)

        header.actionButton.tag = indexPath.section
        header.actionButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
             
            
            return header
        }
        print("Supplementary View Not Found")
        return UICollectionReusableView()
    }

       // MARK: - Cell for Item at IndexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandingPageBanner", for: indexPath) as! LandingPageBannerCollectionViewCell
            cell.updateBannerDetails(for: indexPath)
            cell.layer.cornerRadius = 15.0    // Rounded corners
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1.0
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandingPageChefSpecial", for: indexPath) as! LandingPageChefSpecialCollectionViewCell
            cell.updateSpecialDishDetails(for: indexPath)
            cell.layer.cornerRadius = 15.0    // Rounded corners
            cell.layer.borderWidth = 1.0       // Border width
            cell.layer.borderColor = UIColor.black.cgColor
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandingPageKitchen", for: indexPath) as! LandingPageKitchenCollectionViewCell
            cell.updateLandingPageKitchen(for: indexPath)
            cell.layer.cornerRadius = 15.0    // Rounded corners
            cell.layer.borderWidth = 1.0       // Border width
            cell.layer.borderColor = UIColor.black.cgColor  // Border color
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
                   section = self.generateBannerSectionLayout()
               case 1:
                   section = self.generateLandingChefSpecialSectionLayout()
               case 2:
                   section = self.generateLandingPageKitchenSectionLayout()
              
               default:
                   return nil
               }
               
               // Add Header
               let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
               let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
               section.boundarySupplementaryItems = [header]
               
               return section
           }
           return layout
       }
       
//       // Layout for Kitchen Details Section
       func generateBannerSectionLayout() -> NSCollectionLayoutSection {
//
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           
           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(100))
           let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
           group.interItemSpacing = .fixed(5) // Space between items within the section
           group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10.0, bottom: 0, trailing: 8.0)
           let section = NSCollectionLayoutSection(group: group)
           section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 20) // Minimize insets
           section.orthogonalScrollingBehavior = .groupPaging
           return section
       }
   
       
       // Layout for Menu Categories Section

    func generateLandingChefSpecialSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(145))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(5) // Space between items within the section
        group.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 10.0, bottom: 0, trailing: 8.0)
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 8, bottom: 0, trailing: 10) // Minimize insets
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 20)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }

       
       // Layout for Chef's Special Section
       func generateLandingPageKitchenSectionLayout() -> NSCollectionLayoutSection {

           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
               let item = NSCollectionLayoutItem(layoutSize: itemSize)

               // Define group size and layout
               let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
               let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

               // Add content insets to the group
               group.interItemSpacing = .fixed(5)
               group.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 5.0, bottom: 8.0, trailing: 5.0) // No insets on the left/right

               // Create the section
               let section = NSCollectionLayoutSection(group: group)
               section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

           return section
       }
       
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 { // Section 2 corresponds to the "LandingPageKitchen" section
            // Initialize the destination view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
            if let kitchenDetailVC = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
                
                // Pass data to the destination view controller if needed
                kitchenDetailVC.kitchenData = KitchenDataController.kitchens[indexPath.item]
                
                // Navigate to the view controller
                self.navigationController?.pushViewController(kitchenDetailVC, animated: true)
                
//                kitchenDetailVC.modalPresentationStyle = .pageSheet
//                
//                if let sheet = kitchenDetailVC.sheetPresentationController {
//                    sheet.detents = [.medium(),.large()]
//                }
//                present(kitchenDetailVC,animated: true)
                
            }
        }
    }
    
    
    @objc func sectionButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let firstScreenVC = storyboard.instantiateViewController(withIdentifier: "LandingPageChefSpecialitySeeMoreViewController") as? LandingPageChefSpecialitySeeMoreViewController {
                self.navigationController?.pushViewController(firstScreenVC, animated: true)
            } else {
                print("Error: Could not instantiate KitchenMenuListViewController")
            }

        default:
            break
        }
    }


    

}
