//
//  KitchenChefSpecialViewController.swift
//  kitchen
//
//  Created by Ravi Tiwari on 18/01/25.
//

import UIKit

class KitchenChefSpecialViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UISearchBarDelegate,ChefSpecialMenuDetailsCellDelegate{
    

    func MenuListaddButtonTapped(in cell: ChefSpecialMenuCollectionViewCell) {
        guard let indexPath = ChefSpecialMenu.indexPath(for: cell) else { return }

        var selectedMenuItem: MenuItem? = nil
        var selectedChefSpecialtyDish: ChefSpecialtyDish? = nil

        if indexPath.section == 0 {
            // Section 0 contains Chef Specialty Dishes
            selectedChefSpecialtyDish = KitchenDataController.chefSpecialtyDishes[indexPath.row]
            print("Add button tapped for Chef Specialty Dish: \(selectedChefSpecialtyDish?.name ?? "Unknown")")
        } else if indexPath.section == 1 {
            // Section 1 contains Regular Menu Items
            selectedMenuItem = KitchenDataController.menuItems[indexPath.row]
            print("Add button tapped for Menu Item: \(selectedMenuItem?.name ?? "Unknown")")
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "AddItemModallyViewController") as? AddItemModallyViewController {
            detailVC.selectedItem = selectedMenuItem
            detailVC.selectedChefSpecialtyDish = selectedChefSpecialtyDish // Pass the Chef Special dish

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

    
    
    @IBOutlet var ChefSpecialMenu: UICollectionView!
    
    var searchBar: UISearchBar!
    var filterScrollView: UIScrollView!
    var filterStackView: UIStackView!
    var itemCountLabel: UILabel!
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
           self.view.backgroundColor = .white
           self.title = "Chef Speciality Dishes"
        configureSearchBar()
        configureFilterStackView()
        configureItemCountLabel()
        
        ChefSpecialMenu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ChefSpecialMenu)

        NSLayoutConstraint.activate([
            ChefSpecialMenu.topAnchor.constraint(equalTo: itemCountLabel.bottomAnchor, constant: 10),
            ChefSpecialMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ChefSpecialMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ChefSpecialMenu.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        
        let chefSpecialMenuNib = UINib(nibName: "ChefSpecialMenu", bundle: nil)
        ChefSpecialMenu.register(chefSpecialMenuNib, forCellWithReuseIdentifier: "ChefSpecialMenu")
        
        
        // Setting Layout
        ChefSpecialMenu.setCollectionViewLayout(generateLayout(), animated: true)
        ChefSpecialMenu.dataSource = self
        ChefSpecialMenu.delegate = self
        
        updateItemCount()
        
    }
    
    func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal // Removes background lines
        searchBar.backgroundImage = UIImage() // Removes background shadow
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureFilterStackView() {
        filterScrollView = UIScrollView()
        filterScrollView.showsHorizontalScrollIndicator = false
        filterScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        filterStackView = UIStackView()
        filterStackView.axis = .horizontal
        filterStackView.spacing = 15.0
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let sortButton = createFilterButton(title: "Sort ", withChevron: true)
        let nearestButton = createFilterButton(title: "Nearest")
        let ratingsButton = createFilterButton(title: "Ratings 4.0+")
        let pureVegButton = createFilterButton(title: "Pure Veg")
        let costVegButton = createFilterButton(title: "Cost: Low to High")
        
        filterStackView.addArrangedSubview(sortButton)
        filterStackView.addArrangedSubview(nearestButton)
        filterStackView.addArrangedSubview(ratingsButton)
        filterStackView.addArrangedSubview(pureVegButton)
        filterStackView.addArrangedSubview(costVegButton)
        
        filterScrollView.addSubview(filterStackView)
        view.addSubview(filterScrollView)
        
        NSLayoutConstraint.activate([
            filterScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterScrollView.heightAnchor.constraint(equalToConstant: 40),
            
            filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor),
            filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor),
            filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor),
            filterStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
            filterStackView.heightAnchor.constraint(equalTo: filterScrollView.heightAnchor)
        ])
    }
    
// MARK: - Configure Item Count Label
func configureItemCountLabel() {
    itemCountLabel = UILabel()
    itemCountLabel.textAlignment = .center
    itemCountLabel.textColor = .gray
    itemCountLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    itemCountLabel.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(itemCountLabel)
    
    NSLayoutConstraint.activate([
        itemCountLabel.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: 15),
        itemCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        itemCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        itemCountLabel.heightAnchor.constraint(equalToConstant: 20)
    ])
}


func createFilterButton(title: String, withChevron: Bool = false) -> UIButton {
    let button = UIButton(type: .system)
    
    if withChevron {
        let chevronImage = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        let attachment = NSTextAttachment()
        attachment.image = chevronImage
        attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
        
        let attributedString = NSMutableAttributedString(string: title + " ")
        attributedString.append(NSAttributedString(attachment: attachment))
        
        // Apply bold font style with increased size
        let boldFont = UIFont.boldSystemFont(ofSize: 18) // Increased size
        attributedString.addAttribute(.font, value: boldFont, range: NSRange(location: 0, length: attributedString.length))
        
        button.setAttributedTitle(attributedString, for: .normal)
    } else {
        // Apply bold font with increased size
        let boldTitle = NSAttributedString(string: title, attributes: [.font: UIFont.boldSystemFont(ofSize: 18)]) // Increased size
        button.setAttributedTitle(boldTitle, for: .normal)
    }
    
    button.setTitleColor(.black, for: .normal)
    button.backgroundColor = .white
    button.layer.borderWidth = 1.0
    button.layer.borderColor = UIColor.gray.cgColor
    button.layer.cornerRadius = 10
    button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
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
    
    
    // MARK: - Number of Items in Section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return KitchenDataController.chefSpecialtyDishes.count
        
        default:
            return 0
        }
    }
    
    
    
    // MARK: - Update Item Count Label
    func updateItemCount() {
        let count = KitchenDataController.chefSpecialtyDishes.count
        DispatchQueue.main.async {
            self.itemCountLabel.text = "\(count) Dishes Available For You"
        }
    }
    
    
    
    // MARK: - Cell for Item at IndexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChefSpecialMenu", for: indexPath) as! ChefSpecialMenuCollectionViewCell
            cell.updateSpecialDishDetails(for: indexPath)
            cell.layer.cornerRadius = 15.0
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.layer.shadowRadius = 2.5
            cell.layer.shadowOpacity = 0.5
            cell.layer.masksToBounds = false
            cell.delegate = self
            return cell
       
            
        default:
            return UICollectionViewCell()
        }
    }
    
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(345))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16.0, bottom: 8.0, trailing: 16.0)
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }

    
}
    

   


