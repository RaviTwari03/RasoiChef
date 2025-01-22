////
////  MyOrdersViewController.swift
////  RasoiChef
////
////  Created by Batch - 1 on 15/01/25.
////
//
//import UIKit
//
//class MyOrdersViewController: UIViewController {
//
//    @IBOutlet var tableView: UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.dataSource = self
//        tableView.delegate = self
//        // Do any additional setup after loading the view.
//        
//        let myOrderNib = UINib(nibName: "MyOrdersTableViewCell", bundle: nil)
//        tableView.register(myOrderNib, forCellReuseIdentifier: "MyOrderTableViewCell")
//        
//    }
//    
//
//}
//
//
//extension MyOrdersViewController:UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        OrderDataController.shared.getOrderCount()
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell  = tableView.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell", for: indexPath) as! MyOrdersTableViewCell
//        
//        return cell
//    }
//    
//    
//}
//
//extension MyOrdersViewController:UITableViewDelegate{
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//}
