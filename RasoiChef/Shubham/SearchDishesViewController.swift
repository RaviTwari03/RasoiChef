//
//  SearchDishesViewController.swift
//  RasoiChef
//
//  Created by Shubham Jaiswal on 04/03/25.
//

import UIKit

class SearchDishesViewController: UIViewController {

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupSearchBar()
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.navigationBar.prefersLargeTitles = false // Disable large title for this page
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            navigationController?.navigationBar.prefersLargeTitles = true // Restore large title when going back
        }
    
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for dishes..."
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}


// MARK: - UISearchResultsUpdating
extension SearchDishesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Handle search filtering here
    }
}



