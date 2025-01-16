//
//  MyOrdersViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 15/01/25.
//

import UIKit

class MyOrdersViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        let myOrderNib = UINib(nibName: "MyOrdersTableViewCell", bundle: nil)
        tableView.register(myOrderNib, forCellReuseIdentifier: "MyOrdersTableViewCell")
        
        let pastOrderNib = UINib(nibName: "pastOrderTableViewCell", bundle: nil)
        tableView.register(pastOrderNib, forCellReuseIdentifier: "pastOrderTableViewCell")
        
       
        
    }
    

}


extension MyOrdersViewController:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return OrderDataController.shared.getOrderCount()
        } else {
            return OrderDataController.shared.getPastOrderCount()
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

                   return cell
               } else {
                   // Past Order Cell
                   let cell = tableView.dequeueReusableCell(withIdentifier: "pastOrderTableViewCell", for: indexPath) as! pastOrderTableViewCell

                   return cell
               }
        
      
    }
    
    }
    


extension MyOrdersViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }
   
}
