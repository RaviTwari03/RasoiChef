//
//  MyOrdersViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 15/01/25.
//

import UIKit

class MyOrdersViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    
    @IBOutlet weak var subscribedPlansView: UIView!
    
    private let refreshControl = UIRefreshControl()
    
    var currentOrders: [Order] = []
    var pastOrders: [Order] = []
    var displayedOrders: [Order] = [] 
   
    static var shared = MyOrdersViewController()
    
    private let noActiveOrdersLabel: UILabel = {
           let label = UILabel()
           label.text = "No Active Orders"
           label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
           label.textColor = .gray
           label.textAlignment = .center
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
            ])
        
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        let myOrderNib = UINib(nibName: "MyOrdersTableViewCell", bundle: nil)
        tableView.register(myOrderNib, forCellReuseIdentifier: "MyOrdersTableViewCell")
        
        let pastOrderNib = UINib(nibName: "pastOrderTableViewCell", bundle: nil)
        tableView.register(pastOrderNib, forCellReuseIdentifier: "pastOrderTableViewCell")
        
        
        tableView.sectionHeaderTopPadding = 10
        
        // Add the noActiveOrdersLabel to the view
              view.addSubview(noActiveOrdersLabel)
        
               // Set up constraints for the label
                NSLayoutConstraint.activate([
                    noActiveOrdersLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    noActiveOrdersLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    noActiveOrdersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    noActiveOrdersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
               ])
        // Initially hide the label
             noActiveOrdersLabel.isHidden = true
        
        tableView.reloadData()
        loadData()
        
    }
    
    @objc private func refreshData() {
        fetchOrders()
    }
    
    func loadData() {
            let allOrders = OrderDataController.shared.getOrders()
            currentOrders = allOrders.filter { $0.status != .delivered }
            pastOrders = allOrders.filter { $0.status == .delivered }
        
        // Show or hide the "No Active Orders" label and table view
               if currentOrders.isEmpty  && pastOrders.isEmpty{
                   noActiveOrdersLabel.isHidden = false
                   tableView?.isHidden = true // Hide the table view if there are no current orders
                } else {
                   noActiveOrdersLabel.isHidden = true
                    tableView?.isHidden = false // Show the table view if there are current orders
                }
        

            tableView?.reloadData()
        }
    
    func showPricePopup(for order: Order) {
        let popup = PricePopupView(frame: self.view.bounds)
        let totalAmount = order.totalAmount
        let gstAmount = totalAmount * 0.18
        let discountAmount = 20
        let grandTotal = totalAmount + (totalAmount * 0.18) - Double(discountAmount)
        popup.configure(price: "\(totalAmount)", gst: "\(gstAmount)", discount: "\(discountAmount)", grandTotal: "\(grandTotal)")
        self.view.addSubview(popup)
    }
    
    
    
    @IBAction func segmentChanged(_ sender: Any) {
        
        switch (sender as AnyObject).selectedSegmentIndex {
        case 0:
            // Show Orders section
            tableView.isHidden = false
            subscribedPlansView.isHidden = true
            loadData()
          
        case 1:
            // Show Subscribed Plans section
            tableView.isHidden = true
            subscribedPlansView.isHidden = false
            noActiveOrdersLabel.isHidden = true
        default:
            break
            
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        tableView.reloadData()
    }
    
    
    
    private func fetchOrders() {
        // Show loading indicator
        refreshControl.beginRefreshing()
        
        Task {
            do {
                guard let session = try await SupabaseController.shared.getCurrentSession() else {
                    throw NSError(domain: "OrderError", 
                                code: -1, 
                                userInfo: [NSLocalizedDescriptionKey: "No authenticated user found"])
                }
                
                let userID = session.user.id.uuidString
                print("🔄 Fetching orders for authenticated user: \(userID)")
                let orders = try await SupabaseController.shared.fetchOrders(for: userID)
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.currentOrders = orders.filter { $0.status != .delivered }
                    self.pastOrders = orders.filter { $0.status == .delivered }
                    self.updateEmptyState()
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    print("Error fetching orders: \(error.localizedDescription)")
                    self.refreshControl.endRefreshing()
                    // You might want to show an error alert here
                }
            }
        }
    }
    
    private func updateEmptyState() {
        if currentOrders.isEmpty && pastOrders.isEmpty {
            noActiveOrdersLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noActiveOrdersLabel.isHidden = true
            tableView.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
            if indexPath.section == 0 {
                   // Current Order Cell
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersTableViewCell", for: indexPath) as! MyOrdersTableViewCell
                    let order = currentOrders[indexPath.row]
                                cell.configure(order: order)
            
                    cell.delegate = self
                
                    cell.onInfoButtonTapped = { [weak self] in
                    guard let self = self else { return }
                    self.showPricePopup(for: order)
                   }
                    return cell
              

               }
        
        else {
                   // Past Order Cell
                   let cell = tableView.dequeueReusableCell(withIdentifier: "pastOrderTableViewCell", for: indexPath) as! pastOrderTableViewCell
                   
                        let order = pastOrders[indexPath.row]
                        cell.configure(order: order)
                        cell.onInfoButtonTapped = { [weak self] in
                        guard let self = self else { return }
                        self.showPricePopup(for: order)
            }
                    
                               // Configure the past order cell (adjust as needed)
                            return cell

                  
               }
        
      
    }
    
    }
    


extension MyOrdersViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // Force headers to scroll out of view
            let offsetY = scrollView.contentOffset.y
            if offsetY > 0 {
                tableView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
            } else {
                tableView.contentInset = .zero
            }
        }
    
    
       
   
}

extension MyOrdersViewController: MyOrderTableViewCellDelegate {
    func didTapTrackButton(forOrder order: Order) {
        let trackVC = TrackOrderViewController()
        trackVC.order = order
        navigationController?.pushViewController(trackVC, animated: true)
    }
    
}

extension MyOrdersViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2  // Current Orders and Past Orders
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return currentOrders.count
        } else {
            return pastOrders.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        if section == 0 {
            label.text = "Current Orders"
        } else {
            label.text = "Past Orders"
        }
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Only show header if section has rows
        if section == 0 && currentOrders.isEmpty {
            return 0
        }
        if section == 1 && pastOrders.isEmpty {
            return 0
        }
        return 44
    }
}








