//
//  KitchenMenuListViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit

class KitchenMenuListViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,MenuDetailsCellDelegate, KitchenMenuDetailsCellDelegate {
    
    var selectedDay: WeekDay = .monday // Default to Monday (Change as needed)
    private let refreshControl = UIRefreshControl()

    func KitchenMenuListaddButtonTapped(in cell: KitchenMenuCollectionViewCell) {
        guard let indexPath = KitchenMenuList.indexPath(for: cell) else { return }
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
    
    @IBOutlet var KitchenMenuList: UICollectionView!
    
    var menuItems: [MenuItem] = []
    override func viewDidLoad() {
        self.navigationItem.largeTitleDisplayMode = .never
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Menu"
        
        // Registering Nibs for Cells
        let kitchenMenuCalenderNib = UINib(nibName: "KitchenMenuCalender", bundle: nil)
        let kitchenMenuNib = UINib(nibName: "KitchenMenu", bundle: nil)
        
        KitchenMenuList.register(kitchenMenuCalenderNib, forCellWithReuseIdentifier: "KitchenMenuCalender")
        KitchenMenuList.register(kitchenMenuNib, forCellWithReuseIdentifier: "KitchenMenu")
        
        // Setting Layout
        KitchenMenuList.setCollectionViewLayout(generateLayout(), animated: true)
        KitchenMenuList.dataSource = self
        KitchenMenuList.delegate = self
        
        // Add refresh control - moved after collection view setup
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        KitchenMenuList.refreshControl = refreshControl
        
        DispatchQueue.main.async {
            let todayIndexPath = IndexPath(item: 0, section: 0)
            self.KitchenMenuList.selectItem(at: todayIndexPath, animated: false, scrollPosition: .centeredHorizontally)
            if let cell = self.KitchenMenuList.cellForItem(at: todayIndexPath) as? KitchenMenuCalenderCollectionViewCell {
                cell.isSelected = true  // Ensure the cell appears selected
            }
        }
    }
    
  

    // MARK: - Number of Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    // MARK: - Number of Items in Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 7 // Assuming 7 days in a week
        case 1:
            return KitchenDataController.menuItems.filter { $0.availableDays.contains(selectedDay) }.count
        default:
            return 0
        }
    }

    
    
    // MARK: - Cell for Item at IndexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KitchenMenuCalender", for: indexPath) as! KitchenMenuCalenderCollectionViewCell
            cell.updateMenuListDate(for: indexPath)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KitchenMenu", for: indexPath) as! KitchenMenuCollectionViewCell
            let filteredMenu = KitchenDataController.menuItems.filter { $0.availableDays.contains(selectedDay) }
            
            if indexPath.row < filteredMenu.count {
                let menuItem = filteredMenu[indexPath.row]
                cell.updateMealDetails(with: menuItem, at: indexPath)
                
                // Check meal availability based on current time
                let currentHour = Calendar.current.component(.hour, from: Date())
                let isAvailable: Bool = {
                    switch menuItem.availableMealTypes.first {
                    case .breakfast where currentHour < 6:   return true  // Until 6 AM
                    case .lunch where currentHour < 11:      return true  // Until 11 AM
                    case .snacks where currentHour < 15:     return true  // Until 3 PM
                    case .dinner where currentHour < 19:     return true  // Until 7 PM
                    default: return false
                    }
                }()
                
                cell.setAvailability(isAvailable)
            }
            
            cell.delegate = self
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 { // If Calendar Section is clicked
            let selectedCell = collectionView.cellForItem(at: indexPath) as? KitchenMenuCalenderCollectionViewCell
            selectedDay = WeekDay.allCases[indexPath.row] // Assuming WeekDay enum follows correct order
            
            // Reload the menu items based on selected date
            KitchenMenuList.reloadSections(IndexSet(integer: 1))
        }
    }

    // Calendar Section Layout
    func generateMenuCalenderSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.20), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading:5.0, bottom: 8.0, trailing: 0.0)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 15.0, leading: 15.0, bottom: 10.0, trailing: 10.0)

        return section
    }
    // Menu List Section Layout
    func generateMenuListSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(235))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5.0, bottom: 0.0, trailing: 5.0)
        group.interItemSpacing = .fixed(0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10.0, bottom: 0, trailing: 8.0)
        section.interGroupSpacing = 0

        return section
    }    
    //    MARK: - For ADD button in the menu items cell
        func MenuListaddButtonTapped(in cell: MenuDetailsCollectionViewCell) {
            guard let indexPath = KitchenMenuList.indexPath(for: cell) else { return }
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

    @objc private func refreshData() {
        print("\n🔄 Refreshing menu data...")
        Task {
            await KitchenDataController.loadData()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                // Check if data was loaded successfully
                if !KitchenDataController.menuItems.isEmpty {
                    self.KitchenMenuList.reloadData()
                    
                    // Show success message
                    let banner = UILabel()
                    banner.text = "✅ Content updated"
                    banner.textAlignment = .center
                } else {
                    // Show error message
                    let banner = UILabel()
                    banner.text = "❌ Failed to update content"
                    banner.textAlignment = .center
                }
                
                self.refreshControl.endRefreshing()
            }
        }
    }
}
