//
//  cartViewController.swift
//  RasoiChef
//
//  Created by Batch - 1 on 20/01/25.
//

import UIKit

class cartViewController: UIViewController {

    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var table2View: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 10
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.2
        tableView.layer.shadowOffset = CGSize(width: 0, height: 2)
        tableView.layer.shadowRadius = 4
        
        
        
        table2View.backgroundColor = .white
        table2View.layer.cornerRadius = 10
        table2View.layer.shadowColor = UIColor.black.cgColor
        table2View.layer.shadowOpacity = 0.2
        table2View.layer.shadowOffset = CGSize(width: 0, height: 2)
        table2View.layer.shadowRadius = 4
        
    }
    

    

}
