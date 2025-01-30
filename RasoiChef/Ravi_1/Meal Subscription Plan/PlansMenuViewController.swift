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
       
        
        // Registering Nibs for Cells
        let PlansMenuNib = UINib(nibName: "PlansMenu", bundle: nil)
//        let kitchenMenuNib = UINib(nibName: "KitchenMenu", bundle: nil)
        
        subscriptionPlan.register(PlansMenuNib, forCellWithReuseIdentifier: "PlansMenu")
//        KitchenMenuList.register(kitchenMenuNib, forCellWithReuseIdentifier: "KitchenMenu")
        
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
//        case 0:
//            return KitchenDataController.dateItem.count
        case 1:
            return KitchenDataController.menuItems.count
        default:
            return 0
        }
    }
    
    
    // MARK: - Cell for Item at IndexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlansMenu", for: indexPath) as! PlansMenuCollectionViewCell
            cell.updateMenuDetails(with: indexPath)
//            cell.layer.cornerRadius = 10.0
//            cell.layer.borderWidth = 1.0
//            cell.layer.borderColor = UIColor.gray.cgColor
//            cell.layer.shadowColor = UIColor.black.cgColor
//            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
//            cell.layer.shadowRadius = 5.0
//            cell.layer.shadowOpacity = 0.2
//            cell.layer.masksToBounds = false
//            cell.layer.shadowColor = UIColor.black.cgColor
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
//            case 0:
//                section = self.generateMenuCalenderSectionLayout()
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
//    func generateMenuCalenderSectionLayout() -> NSCollectionLayoutSection {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.20), heightDimension: .absolute(100))
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
    // Menu List Section Layout
    func generateMenuListSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0.0, bottom: 0.0, trailing: 0.0)
        group.interItemSpacing = .fixed(0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0.0, bottom: 0, trailing: 0.0)
        section.interGroupSpacing = 0

        return section
    }
}
