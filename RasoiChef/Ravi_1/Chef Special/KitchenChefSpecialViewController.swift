//
//  KitchenChefSpecialViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit

class KitchenChefSpecialViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UISearchBarDelegate{
    
    
    
    @IBOutlet var ChefSpecialMenu: UICollectionView!
    var searchBar: UISearchBar!
    var filterStackView: UIStackView!
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
           self.view.backgroundColor = .white
           self.title = "Chef Speciality Dishes"
          configureSearchBar()
            configureFilterStackView()
        
        
        
        let chefSpecialMenuNib = UINib(nibName: "ChefSpecialMenu", bundle: nil)
        
        
        ChefSpecialMenu.register(chefSpecialMenuNib, forCellWithReuseIdentifier: "ChefSpecialMenu")
        
        
        // Setting Layout
        ChefSpecialMenu.setCollectionViewLayout(generateLayout(), animated: true)
        ChefSpecialMenu.dataSource = self
        ChefSpecialMenu.delegate = self
    }
    
    func configureSearchBar() {
            searchBar = UISearchBar()
            searchBar.delegate = self
            searchBar.placeholder = "Search"
            searchBar.sizeToFit()
           // self.navigationItem.titleView = searchBar
        if let navigationBarHeight = navigationController?.navigationBar.frame.height {
               let statusBarHeight = UIApplication.shared.statusBarFrame.height
               let yPosition = navigationBarHeight + statusBarHeight
               searchBar.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: searchBar.frame.height)
           } else {
               searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: searchBar.frame.height)
           }

           // Add the search bar to the view
           view.addSubview(searchBar)
        }

    func configureFilterStackView() {
        let sortButton = createFilterButton(title: "Sort")
        let nearestButton = createFilterButton(title: "Nearest")
        let ratingsButton = createFilterButton(title: "Ratings 4.0+")
        let pureVeg = createFilterButton(title: "Pure Veg")
        
        filterStackView = UIStackView(arrangedSubviews: [sortButton, nearestButton, ratingsButton])
        filterStackView.axis = .horizontal
        filterStackView.distribution = .fillEqually
        filterStackView.spacing = 8.0
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
//        self.view.addSubview(filterStackView)
        self.view.addSubview(filterStackView)

            NSLayoutConstraint.activate([
                filterStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
                filterStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
                filterStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
                filterStackView.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        // Ensure the search bar is configured and added to the view first
        guard let searchBar = searchBar else {
            print("Search bar is not configured or added to the view yet.")
            return
        }
        
        // Add constraints
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            filterStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            filterStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            filterStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func createFilterButton(title: String) -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .systemOrange
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
            return button
        }
        
        @objc func filterButtonTapped(_ sender: UIButton) {
            guard let title = sender.title(for: .normal) else { return }
            print("Filter tapped: \(title)")
            // Handle filter logic here
        }
        
        // MARK: - Search Bar Delegate
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("Search query: \(searchText)")
            // Filter collection view data based on the search query
        }
        
    // MARK: - Number of Sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    // MARK: - Number of Items in Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return KitchenDataController.chefSpecialtyDishes.count
        
        default:
            return 0
        }
    }
    
    // MARK: - Cell for Item at IndexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChefSpecialMenu", for: indexPath) as! ChefSpecialMenuCollectionViewCell
            cell.updateSpecialDishDetails(for: indexPath)
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
                section = self.generateChefSpecialMenuSectionLayout()
            
            default:
                return nil
            }
            
            return section
        }
        return layout
    }
    

//
//    
//    // Calendar Section Layout
    func generateChefSpecialMenuSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(350))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewFlowLayout()
        

//        section.contentInsets = NSDirectionalEdgeInsets(top: 10.0, leading: 8.0, bottom: 10.0, trailing: 8.0)

        return section
    }
    
   
    

    
       }
    

   


