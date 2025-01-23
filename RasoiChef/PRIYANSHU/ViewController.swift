//
//  ViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 17/01/25.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, MenuDetailsCellDelegate,UICollectionViewDelegateFlowLayout {

    
    @IBOutlet var collectionView1: UICollectionView!
    var kitchenData: Kitchen?
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
        self.title = "Kanha Ji Rasoi"
           // Registering Nibs for Cells
           let kitchenDetailsNib = UINib(nibName: "KitchenDetails", bundle: nil)
           let menuDetailsNib = UINib(nibName: "MenuDetails", bundle: nil)
           let chefSpecialDishesNib = UINib(nibName: "ChefSpecialDishes", bundle: nil)
           let subscriptionDetailsNib = UINib(nibName: "SubscriptionDetails", bundle: nil)
           
        collectionView1.register(kitchenDetailsNib, forCellWithReuseIdentifier: "KitchenDetails")
        collectionView1.register(menuDetailsNib, forCellWithReuseIdentifier: "MenuDetails")
        collectionView1.register(chefSpecialDishesNib, forCellWithReuseIdentifier: "ChefSpecialDishes")
        collectionView1.register(subscriptionDetailsNib, forCellWithReuseIdentifier: "SubscriptionDetails")
           
           // Setting Layout
        collectionView1.register(SectionHeader1CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
//            header.button.addTarget(self, action: #selector(sectionbuttonTapped(_:)), for: .touchUpInside)

        collectionView1.setCollectionViewLayout(generateLayout(), animated: true)
        collectionView1.dataSource = self
        collectionView1.delegate = self
       }
       
       // MARK: - Number of Sections
       func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 5
       }
       
       // MARK: - Number of Items in Section
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           switch section {
           case 0:
               return 1 // Single restaurant/kitchen details
           case 1:
               return KitchenDataController.menuItems.count
           case 2:
               return KitchenDataController.chefSpecialtyDishes.count
           case 3:
               return KitchenDataController.subscriptionPlan.count
           default:
               return 0
           }
       }
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionView.elementKindSectionHeader {
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader1CollectionReusableView
//            
//            // Switch case for section headers
//            switch indexPath.section {
//            case 0:
//                header.headerLabel.text = ""
//            case 1:
//                header.headerLabel.text = KitchenDataController.sectionHeaderNames[0]
//            case 2:
//                header.headerLabel.text = KitchenDataController.sectionHeaderNames[1]
//            case 3:
//                header.headerLabel.text = KitchenDataController.sectionHeaderNames[2]
//            default:
//                header.headerLabel.text = "Section \(indexPath.section)" // Default case to prevent out of range error
//            }
//            if header.headerLabel.text == "" {
//                header.actionButton.isHidden = true
//                header.headerLabel.font = UIFont.systemFont(ofSize: 0, weight: .regular)
//            } else {
//                header.actionButton.isHidden = false
//                header.headerLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
//            }
//            
//            header.headerLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
//            header.actionButton.setTitle("See All", for: .normal)
//
//        header.actionButton.tag = indexPath.section
//        header.actionButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
//             
//            
//            return header
//        }
//        print("Supplementary View Not Found")
//        return UICollectionReusableView()
//    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader1CollectionReusableView

            // Set header titles dynamically
            switch indexPath.section {
            case 0:
                header.headerLabel.text = ""
            case 1:
                header.headerLabel.text = KitchenDataController.sectionHeaderNames[0]
            case 2:
                header.headerLabel.text = KitchenDataController.sectionHeaderNames[1]
            case 3:
                header.headerLabel.text = KitchenDataController.sectionHeaderNames[2]
            default:
                header.headerLabel.text = "Section \(indexPath.section)" // Default case
            }

            // Adjust visibility and font
            if header.headerLabel.text?.isEmpty == true {
                header.actionButton.isHidden = true
            } else {
                header.actionButton.isHidden = false
                header.headerLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            }

            header.actionButton.setTitle("See All", for: .normal)
            header.actionButton.tag = indexPath.section
            header.actionButton.addTarget(self, action: #selector(sectionButtonTapped(_:)), for: .touchUpInside)
            return header
        }
        print("Supplementary View Not Found")
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 0) // No header
        case 1:
            let title = KitchenDataController.sectionHeaderNames[0]
            return title.isEmpty ? CGSize(width: collectionView.bounds.width, height: 0) : CGSize(width: collectionView.bounds.width, height: 50)
        case 2:
            let title = KitchenDataController.sectionHeaderNames[1]
            return title.isEmpty ? CGSize(width: collectionView.bounds.width, height: 0) : CGSize(width: collectionView.bounds.width, height: 50)
        case 3:
            let title = KitchenDataController.sectionHeaderNames[2]
            return title.isEmpty ? CGSize(width: collectionView.bounds.width, height: 0) : CGSize(width: collectionView.bounds.width, height: 50)
        default:
            return CGSize(width: collectionView.bounds.width, height: 50) // Default header size
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuDetails", for: indexPath) as! MenuDetailsCollectionViewCell
            cell.delegate = self
            cell.updateMenuDetails(with : indexPath)// Pass indexPath insteadofindexPath.section
            
            cell.layer.cornerRadius = 10.0    // Rounded corners
               cell.layer.borderWidth = 1.0       // Border width
               cell.layer.borderColor = UIColor.gray.cgColor  // Border color
               cell.layer.shadowColor = UIColor.black.cgColor  // Shadow color
               cell.layer.shadowOffset = CGSize(width: 2, height: 2)  // Shadow offset
               cell.layer.shadowRadius = 5.0     // Shadow blur radius
            cell.layer.shadowOpacity = 0.2    // Shadow opacity
               cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.black.cgColor
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChefSpecialDishes", for: indexPath) as! ChefSpecialCollectionViewCell
            cell.updateChefSpecialtyDetails(for: indexPath)
            cell.layer.cornerRadius = 10.0    // Rounded corners
               cell.layer.borderWidth = 1.0       // Border width
               cell.layer.borderColor = UIColor.gray.cgColor  // Border color
               cell.layer.shadowColor = UIColor.black.cgColor  // Shadow color
               cell.layer.shadowOffset = CGSize(width: 2, height: 2)  // Shadow offset
               cell.layer.shadowRadius = 5.0     // Shadow blur radius
               cell.layer.shadowOpacity = 0.2    // Shadow opacity
               cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.black.cgColor
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubscriptionDetails", for: indexPath) as! SubscriptionDetailsCollectionViewCell
            cell.updateSubscriptionPlanData(for: indexPath)
            cell.layer.cornerRadius = 10.0    // Rounded corners
               cell.layer.borderWidth = 1.0       // Border width
               cell.layer.borderColor = UIColor.gray.cgColor  // Border color
               cell.layer.shadowColor = UIColor.black.cgColor  // Shadow color
               cell.layer.shadowOffset = CGSize(width: 2, height: 2)  // Shadow offset
               cell.layer.shadowRadius = 5.0     // Shadow blur radius
               cell.layer.shadowOpacity = 0.2    // Shadow opacity
               cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.black.cgColor
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
                   section = self.generateMenuCategorySectionLayout()
               case 2:
                   section = self.generateChefSpecialSectionLayout()
               case 3:
                   section = self.generateSubscriptionPlanSectionLayout()
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
       
       // Layout for Menu Categories Section
       func generateMenuCategorySectionLayout() -> NSCollectionLayoutSection {
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           
           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .absolute(250))
           let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
           group.interItemSpacing = .fixed(5)
           group.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 0.0)
           let section = NSCollectionLayoutSection(group: group)
           section.orthogonalScrollingBehavior = .groupPaging
           return section
       }
       
       // Layout for Chef's Special Section
       func generateChefSpecialSectionLayout() -> NSCollectionLayoutSection {
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           
           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(150))
           let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
           group.interItemSpacing = .fixed(5)
           group.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 0.0)
           let section = NSCollectionLayoutSection(group: group)
           section.orthogonalScrollingBehavior = .groupPaging
           return section

       }
       
    func generateSubscriptionPlanSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Adjust the height of the section item to a bigger size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 0.0)
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
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

    }
//        case 1: // Menu List
//            if let menuListVC = storyboard?.instantiateViewController(withIdentifier: "KitchenMenuListViewController") as? KitchenMenuListViewController {
//                    // Pass menu items for section 1
//                    menuListVC.menuItems = KitchenDataController.menuItems.filter { $0.kitchenID == "kitchen001" } // Example filter
//                    self.navigationController?.pushViewController(menuListVC, animated: true)
//                } else {
//                    print("Error: Could not instantiate KitchenMenuListViewController")
//                }

   

