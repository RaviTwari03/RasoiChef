//
//  LandingPageChefSpecialityViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 23/01/25.
//

import UIKit

class LandingPageChefSpecialitySeeMoreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UISearchBarDelegate {
    
    @IBOutlet var ChefsSpecialDishes: UICollectionView!
    var searchBar: UISearchBar!
    var filterStackView: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        self.view.backgroundColor = .white
        self.title = "Chef Speciality Dishes"
         configureSearchBar()
         configureFilterStackView()
     
     
     
     let chefSpecialMenuNib = UINib(nibName: "ChefSpecialMenuSeeMore", bundle: nil)
     
     
        ChefsSpecialDishes.register(chefSpecialMenuNib, forCellWithReuseIdentifier: "ChefSpecialMenuSeeMore")
     
     
     // Setting Layout
        ChefsSpecialDishes.setCollectionViewLayout(generateLayout(), animated: true)
        ChefsSpecialDishes.dataSource = self
        ChefsSpecialDishes.delegate = self

        // Do any additional setup after loading the view.
    }

    func configureSearchBar() {
            searchBar = UISearchBar()
            searchBar.delegate = self
            searchBar.placeholder = "Search"
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            
            // Add the search bar below the navigation bar
            view.addSubview(searchBar)
            
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
                searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                searchBar.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        func configureFilterStackView() {
            let sortButton = createFilterButton(title: "Sort")
            let nearestButton = createFilterButton(title: "Nearest")
            let ratingsButton = createFilterButton(title: "Ratings 4.0+")
            let pureVegButton = createFilterButton(title: "Pure Veg")
            
            filterStackView = UIStackView(arrangedSubviews: [sortButton, nearestButton, ratingsButton, pureVegButton])
            filterStackView.axis = .horizontal
            filterStackView.distribution = .fillEqually
            filterStackView.spacing = 8.0
            filterStackView.translatesAutoresizingMaskIntoConstraints = false
            
            // Add the filter stack view below the search bar
            view.addSubview(filterStackView)
            
            NSLayoutConstraint.activate([
                filterStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
                filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                filterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("Search query: \(searchText)")
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return KitchenDataController.globalChefSpecial.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChefSpecialMenuSeeMore", for: indexPath) as! ChefSeeMoreCollectionViewCell
            cell.updateSpecialDishDetails(for: indexPath)
            cell.updateSpecialDishDetails(for: indexPath)
            cell.layer.cornerRadius = 10.0
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 2, height: 2)
            cell.layer.shadowRadius = 5.0
            cell.layer.shadowOpacity = 0.2
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.black.cgColor
            return cell
        }
        
//        func generateLayout() -> UICollectionViewLayout {
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//            
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(350))
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//            
//            let section = NSCollectionLayoutSection(group: group)
//            return UICollectionViewCompositionalLayout(section: section)
//        }
    
    
        func generateLayout() -> UICollectionViewLayout {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(350))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
            group.interItemSpacing = .fixed(10)
    
            let section = NSCollectionLayoutSection(group: group)
            let layout = UICollectionViewFlowLayout()
    
    
    //        section.contentInsets = NSDirectionalEdgeInsets(top: 10.0, leading: 8.0, bottom: 10.0, trailing: 8.0)
    
            return UICollectionViewCompositionalLayout(section: section)
        }
    }
