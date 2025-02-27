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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableViewSubscriptionPlan.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                tableViewSubscriptionPlan.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
                tableViewSubscriptionPlan.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9)
            ])
        
        
        tableViewSubscriptionPlan.delegate = self
        tableViewSubscriptionPlan.dataSource = self
        
        
//        let subscriptionPlan=UINib(nibName: "subscriptionPlansTableViewCell", bundle: nil)
//        tableViewSubscriptionPlan.register(SubscriptionPlans, forCellReuseIdentifier: "subscriptionPlansTableViewCell")

        tableViewSubscriptionPlan.register(UINib(nibName: "subscriptionPlansTableViewCell", bundle: nil), forCellReuseIdentifier: "subscriptionPlansTableViewCell")
//        CartItem.register(UINib(nibName: "CartPay", bundle: nil), forCellReuseIdentifier: "CartPay")

        // Do any additional setup after loading the view.
        tableViewSubscriptionPlan.reloadData()
        loadSubscriptionPlan( )
    }
    
    func loadSubscriptionPlan(){
        let allSubscription = OrderDataController.shared.getSubscription()
        print("Loaded Subscription Data: \(allSubscription)")
        Subscriptionplan = allSubscription
        
       tableViewSubscriptionPlan.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
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
