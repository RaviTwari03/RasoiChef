//
//   TrackOrderViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 21/01/25.
//

import Foundation
import UIKit

class TrackOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var order: Order! // Pass this from the previous screen
    private let tableView = UITableView()

    private let statusData = [
        ("Order Placed", "You have successfully placed your order.", "10:35 AM", true),
        ("Order Confirmed", "Your order has been confirmed by the chef.", "10:37 AM", true),
        ("Order Prepared", "Your order has been freshly prepared.", "12:30 PM", true),
        ("Out for Delivery", "", "", false),
        ("Delivered", "", "", false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Track"

        // Configure table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackOrderCell.self, forCellReuseIdentifier: "TrackOrderCell")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        // Add constraints for the table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - TableView DataSource and Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackOrderCell", for: indexPath) as! TrackOrderCell
        let (status, description, time, isCompleted) = statusData[indexPath.row]
        cell.configure(status: status, description: description, time: time, isCompleted: isCompleted)
        return cell
    }
}
