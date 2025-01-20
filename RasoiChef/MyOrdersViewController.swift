//
//  MyOrdersViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 15/01/25.
//

import UIKit

class MyOrdersViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
        var currentOrders: [Order] = []  // Orders still in progress
        var pastOrders: [Order] = []     // Delivered orders
        var displayedOrders: [Order] = [] // Orders shown based on the selected segment
        static var shared = MyOrdersViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        let myOrderNib = UINib(nibName: "MyOrdersTableViewCell", bundle: nil)
        tableView.register(myOrderNib, forCellReuseIdentifier: "MyOrdersTableViewCell")
        
        let pastOrderNib = UINib(nibName: "pastOrderTableViewCell", bundle: nil)
        tableView.register(pastOrderNib, forCellReuseIdentifier: "pastOrderTableViewCell")
        
        loadData()
        
    }
    func loadData() {
            let allOrders = OrderDataController.shared.getOrders()
            currentOrders = allOrders.filter { $0.status != .delivered }
            pastOrders = allOrders.filter { $0.status == .delivered }
            tableView.reloadData()
        }
    
    func showPricePopup(for order: Order) {
        let popup = PricePopupView(frame: self.view.bounds)
        popup.configure(getPrice: "\(order.totalAmount)", grandTotal: "\(order.totalAmount)")
        self.view.addSubview(popup)
    }

    

}


extension MyOrdersViewController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return currentOrders.count
        } else {
            return pastOrders.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Current Orders"
        } else {
            return "Past Orders"
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
               header.textLabel?.textColor = .black
               header.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: header.frame.height)
              
           }
    }
   

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        
        if indexPath.section == 0 {
                   // Current Order Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersTableViewCell", for: indexPath) as! MyOrdersTableViewCell
             let order = currentOrders[indexPath.row]
                        cell.configure(order: order)
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
   
}
