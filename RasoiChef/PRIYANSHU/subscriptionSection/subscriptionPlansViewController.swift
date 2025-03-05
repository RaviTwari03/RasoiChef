//
//  subscriptionPlansViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 22/01/25.
//

import UIKit

class subscriptionPlansModifyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    
    @IBOutlet weak var tableViewSubscriptionPlan: UITableView!
    
    
    var Subscriptionplan:[SubscriptionPlan]=[]
    
    private let noSubscriptionsLabel: UILabel = {
           let label = UILabel()
           label.text = "No Subscriptions Found"
           label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
           label.textColor = .gray
           label.textAlignment = .center
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewSubscriptionPlan.tableHeaderView = UIView(frame: CGRect.zero) // Removes any default spacing

        if #available(iOS 11.0, *) {
            tableViewSubscriptionPlan.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        NSLayoutConstraint.activate([
            tableViewSubscriptionPlan.topAnchor.constraint(equalTo: view.topAnchor, constant: 0), // Attach directly to top
            tableViewSubscriptionPlan.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            tableViewSubscriptionPlan.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
        ])

        tableViewSubscriptionPlan.delegate = self
        tableViewSubscriptionPlan.dataSource = self
        tableViewSubscriptionPlan.register(UINib(nibName: "subscriptionPlansTableViewCell", bundle: nil), forCellReuseIdentifier: "subscriptionPlansTableViewCell")

        view.addSubview(noSubscriptionsLabel)
        NSLayoutConstraint.activate([
            noSubscriptionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noSubscriptionsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            noSubscriptionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noSubscriptionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        noSubscriptionsLabel.isHidden = true
        tableViewSubscriptionPlan.isHidden = true
        loadSubscriptionPlan()
    }

    

    
    func loadSubscriptionPlan(){
        let allSubscription = OrderDataController.shared.getSubscription()
        print("Loaded Subscription Data: \(allSubscription)")
        Subscriptionplan = allSubscription
        if Subscriptionplan.isEmpty {
                   noSubscriptionsLabel.isHidden = false
                   tableViewSubscriptionPlan.isHidden = true
        } else {
                   noSubscriptionsLabel.isHidden = true
                   tableViewSubscriptionPlan.isHidden = false
        }
       tableViewSubscriptionPlan.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Active Plans"
        }

        // Customize Section Header Appearance
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
//            headerView.backgroundColor = .lightGray

            let titleLabel = UILabel()
            titleLabel.text = section == 0 ? "Active Plans" : "Past Plans"
            titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            titleLabel.textColor = .black
            titleLabel.translatesAutoresizingMaskIntoConstraints = false

            headerView.addSubview(titleLabel)

            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])

            return headerView
            
           
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableViewSubscriptionPlan.dequeueReusableCell(withIdentifier: "subscriptionPlansTableViewCell", for: indexPath) as! subscriptionPlansTableViewCell
        
        if Subscriptionplan.count > 0 {
                    let allSubscription1 = Subscriptionplan[indexPath.row]
                    cell.configure(subscription: allSubscription1)
                }
        
        return cell
    }

  

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        230
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadSubscriptionPlan()
        tableViewSubscriptionPlan.reloadData()
    }

    
    

}
