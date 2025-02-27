import UIKit

class TrackOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var order: Order! // Pass this from the previous screen
    private let tableView = UITableView()
    private var timer: Timer?
    private var startTime: Date?

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
        
        // Add observers for app state changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        // Initialize tracking
        initializeTracking()
    }

    private func initializeTracking() {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        // If we already have a start time stored, use that
        if let storedStartTime = UserDefaults.standard.object(forKey: "orderStartTime_\(order.orderID)") as? Date {
            startTime = storedStartTime
        } else {
            // Otherwise, use the current time and store it
            startTime = Date()
            UserDefaults.standard.set(startTime, forKey: "orderStartTime_\(order.orderID)")
        }
        
        // Set initial order placed time
        statusData[0].2 = formatter.string(from: startTime!)
        
        // Restore saved status times
        let orderKey = "orderTimes_\(order.orderID)"
        if let statusTimes = UserDefaults.standard.dictionary(forKey: orderKey) as? [String: String] {
            if let confirmedTime = statusTimes["confirmed"] {
                statusData[1].1 = "Your order has been confirmed by the chef."
                statusData[1].2 = confirmedTime
                statusData[1].3 = true
            }
            if let preparedTime = statusTimes["prepared"] {
                statusData[2].1 = "Your order has been freshly prepared and is ready."
                statusData[2].2 = preparedTime
                statusData[2].3 = true
            }
            if let deliveryTime = statusTimes["delivery"] {
                statusData[3].1 = "Your order is on the way to your location."
                statusData[3].2 = deliveryTime
                statusData[3].3 = true
            }
            if let deliveredTime = statusTimes["delivered"] {
                statusData[4].1 = "Your order has been delivered. Enjoy your meal!"
                statusData[4].2 = deliveredTime
                statusData[4].3 = true
            }
        }
        
        // Only start timer if order is not delivered
        if !statusData[4].3 {
            startStatusUpdateTimer()
        }
        
        tableView.reloadData()
    }

    @objc private func appDidEnterBackground() {
        // Store the current status in UserDefaults
        UserDefaults.standard.set(statusData.map { $0.3 }, forKey: "orderStatus_\(order.orderID)")
        timer?.invalidate()
    }

    @objc private func appWillEnterForeground() {
        // Restore status and restart timer
        if let savedStatus = UserDefaults.standard.array(forKey: "orderStatus_\(order.orderID)") as? [Bool] {
            for (index, isCompleted) in savedStatus.enumerated() where index < statusData.count {
                statusData[index].3 = isCompleted
            }
        }
        updateOrderStatus()
        startStatusUpdateTimer()
    }

    private func startStatusUpdateTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.updateOrderStatus()
        }
    }
    
    private func updateOrderStatus() {
        guard let startTime = startTime else { return }
        
        let currentTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let timeElapsed = currentTime.timeIntervalSince(startTime)
        let currentTimeStr = formatter.string(from: currentTime)
        
        // Get saved status times from UserDefaults
        let defaults = UserDefaults.standard
        let orderKey = "orderTimes_\(order.orderID)"
        var statusTimes = defaults.dictionary(forKey: orderKey) as? [String: String] ?? [:]
        
        // Save initial placed time if not already saved
        if statusTimes["placed"] == nil {
            statusTimes["placed"] = formatter.string(from: startTime)
//import UIKit
        }
        
        // Update status and descriptions one by one, only if not already completed
        if timeElapsed >= 5 && !statusData[1].3 && statusTimes["confirmed"] == nil {
            statusData[1].1 = "Your order has been confirmed by the chef."
            statusData[1].2 = currentTimeStr
            statusData[1].3 = true
            statusTimes["confirmed"] = currentTimeStr
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }
        
        if timeElapsed >= 10 && !statusData[2].3 && statusTimes["prepared"] == nil {
            statusData[2].1 = "Your order has been freshly prepared and is ready."
            statusData[2].2 = currentTimeStr
            statusData[2].3 = true
            statusTimes["prepared"] = currentTimeStr
            tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
        }
        
        if timeElapsed >= 15 && !statusData[3].3 && statusTimes["delivery"] == nil {
            statusData[3].1 = "Your order is on the way to your location."
            statusData[3].2 = currentTimeStr
            statusData[3].3 = true
            statusTimes["delivery"] = currentTimeStr
            tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
        }
        
        if timeElapsed >= 20 && !statusData[4].3 && statusTimes["delivered"] == nil {
            statusData[4].1 = "Your order has been delivered. Enjoy your meal!"
            statusData[4].2 = currentTimeStr
            statusData[4].3 = true
            statusTimes["delivered"] = currentTimeStr
            tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
            
            // Stop timer when order is delivered
            timer?.invalidate()
            timer = nil
        }
        
        // Save updated times
        defaults.set(statusTimes, forKey: orderKey)
    }

    deinit {
        timer?.invalidate()
        NotificationCenter.default.removeObserver(self)
        
        // Don't clear data on deinit anymore, only clear when order is actually delivered
        if statusData[4].3 {
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "orderStartTime_\(order.orderID)")
            defaults.removeObject(forKey: "orderTimes_\(order.orderID)")
        }
    }

    // MARK: - TableView DataSource and Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackOrderCell", for: indexPath) as! TrackOrderCell
        let (status, description, time, isCompleted) = statusData[indexPath.row]
        
        // Don't show line for the last item when it's completed
        let hideLastLine = indexPath.row == statusData.count - 1 && isCompleted
        cell.configure(status: status, description: description, time: time, isCompleted: isCompleted, hideLastLine: hideLastLine)
        return cell
    }
} 
