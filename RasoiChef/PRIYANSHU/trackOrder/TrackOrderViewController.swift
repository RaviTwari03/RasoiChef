import UIKit

class TrackOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var order: Order! // Pass this from the previous screen
    private let tableView = UITableView()
    private var timer: Timer?

    private var statusData = [
        ("Order Placed", "You have successfully placed your order.", "", true),
        ("Order Confirmed", "", "", false),
        ("Order Prepared", "", "", false),
        ("Out for Delivery", "", "", false),
        ("Delivered", "", "", false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // Add observer for order status updates
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orderStatusUpdated(_:)),
            name: NSNotification.Name("OrderStatusUpdated"),
            object: nil
        )
        
        // Start timer for status updates
        startStatusUpdateTimer()
        
        // Set initial order placed time
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        statusData[0].2 = formatter.string(from: order.deliveryDate)
    }

    private func startStatusUpdateTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateOrderStatus()
        }
    }
    
    @objc private func orderStatusUpdated(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let orderID = userInfo["orderID"] as? String,
              let newStatusData = userInfo["statusData"] as? [(String, String, String, Bool)],
              orderID == order.orderID else {
            return
        }
        
        statusData = newStatusData
        tableView.reloadData()
    }
    
    private func updateOrderStatus() {
        let currentTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        // Get the order placed time
        let orderTimeStr = statusData[0].2
        if !orderTimeStr.isEmpty,
           let orderTime = formatter.date(from: orderTimeStr) {
            
            let timeElapsed = currentTime.timeIntervalSince(orderTime)
            let currentTimeStr = formatter.string(from: currentTime)
            
            // Update status and descriptions one by one
            if !statusData[1].3 { // Order Confirmed
                if timeElapsed >= 5 {
                    statusData[1].1 = "Your order has been confirmed by the chef."
                    statusData[1].2 = currentTimeStr
                    statusData[1].3 = true
                    tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                }
            }
            else if !statusData[2].3 { // Order Prepared
                if timeElapsed >= 10 {
                    statusData[2].1 = "Your order has been freshly prepared and is ready."
                    statusData[2].2 = currentTimeStr
                    statusData[2].3 = true
                    tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                }
            }
            else if !statusData[3].3 { // Out for Delivery
                if timeElapsed >= 15 {
                    statusData[3].1 = "Your order is on the way to your location."
                    statusData[3].2 = currentTimeStr
                    statusData[3].3 = true
                    tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
                }
            }
            else if !statusData[4].3 { // Delivered
                if timeElapsed >= 20 {
                    statusData[4].1 = "Your order has been delivered. Enjoy your meal!"
                    statusData[4].2 = currentTimeStr
                    statusData[4].3 = true
                    tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
                    
                    // Stop timer when order is delivered
                    timer?.invalidate()
                    timer = nil
                }
            }
        }
    }

    deinit {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
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
