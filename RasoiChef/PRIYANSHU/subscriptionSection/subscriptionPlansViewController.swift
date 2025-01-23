//
//  subscriptionPlansViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 22/01/25.
//

import UIKit

class subscriptionPlansModifyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    
    @IBOutlet weak var tableViewSubscriptionPlan: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSubscriptionPlan.delegate = self
        tableViewSubscriptionPlan.dataSource = self
        
        
        let subscriptionPlan=UINib(nibName: "subscriptionPlansTableViewCell", bundle: nil)
        tableViewSubscriptionPlan.register(subscriptionPlan, forCellReuseIdentifier: "subscriptionPlansTableViewCell")

        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableViewSubscriptionPlan.dequeueReusableCell(withIdentifier: "subscriptionPlansTableViewCell", for: indexPath) as! subscriptionPlansTableViewCell
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        190
    }
    
    

}
