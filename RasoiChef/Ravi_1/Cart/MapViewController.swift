import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate: AnyObject {
    func didSelectAddress(_ address: String, location: CLLocation)
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: MapViewControllerDelegate?
    var currentLocation: CLLocation?
    private let geocoder = CLGeocoder()
    private let locationManager = CLLocationManager()
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchResults: [MKLocalSearchCompletion] = []
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.mapType = .standard
        return map
    }()
    
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search nearby locations"
        search.translatesAutoresizingMaskIntoConstraints = false
        search.searchBarStyle = .minimal
        search.backgroundColor = .white
        return search
    }()
    
    private lazy var searchResultsTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        table.isHidden = true
        table.layer.cornerRadius = 10
        table.layer.masksToBounds = true
        table.backgroundColor = .white
        table.layer.borderWidth = 1
        table.layer.borderColor = UIColor.systemGray5.cgColor
        return table
    }()
    
    private let searchResultsBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm Location", for: .normal)
        button.backgroundColor = UIColor(named: "AccentColor") ?? .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let centerPinImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mappin.circle.fill"))
        imageView.tintColor = UIColor(named: "AccentColor") ?? .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let currentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = UIColor(named: "AccentColor") ?? .systemBlue
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var isLoadingLocation: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.isLoadingLocation {
                    self.currentLocationButton.setImage(nil, for: .normal)
                    let activityIndicator = UIActivityIndicatorView(style: .medium)
                    activityIndicator.startAnimating()
                    activityIndicator.color = self.currentLocationButton.tintColor
                    self.currentLocationButton.addSubview(activityIndicator)
                    activityIndicator.center = CGPoint(x: self.currentLocationButton.bounds.width/2, y: self.currentLocationButton.bounds.height/2)
                } else {
                    self.currentLocationButton.subviews.forEach { $0.removeFromSuperview() }
                    self.currentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupMapView()
        setupLocationManager()
        setupSearchCompleter()
    }
    
    private func setupNavigationBar() {
        title = "Select Location"
        
        let closeButton = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped)
        )
        navigationItem.leftBarButtonItem = closeButton
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            setDefaultLocation()
        }
    }
    
    private func setDefaultLocation() {
        // Set a default location (e.g., Greater Noida)
        let defaultLocation = CLLocation(latitude: 28.4744, longitude: 77.5040)
        centerMapOnLocation(defaultLocation, regionRadius: 5000) // 5km radius
    }
    
    private func setupSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .query
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        searchBar.delegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        
        // Add subviews
        view.addSubview(mapView)
        view.addSubview(searchResultsBackgroundView)
        view.addSubview(searchBar)
        view.addSubview(searchResultsTableView)
        view.addSubview(confirmButton)
        view.addSubview(centerPinImageView)
        view.addSubview(currentLocationButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchResultsBackgroundView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchResultsBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchResultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchResultsTableView.heightAnchor.constraint(lessThanOrEqualToConstant: 300),
            
            mapView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -16),
            
            centerPinImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            centerPinImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor),
            centerPinImageView.widthAnchor.constraint(equalToConstant: 40),
            centerPinImageView.heightAnchor.constraint(equalToConstant: 40),
            
            currentLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currentLocationButton.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -16),
            currentLocationButton.widthAnchor.constraint(equalToConstant: 40),
            currentLocationButton.heightAnchor.constraint(equalToConstant: 40),
            
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add targets
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTouchDown), for: .touchDown)
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        
        // Add tap gesture to dismiss search results
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSearchResults))
        searchResultsBackgroundView.addGestureRecognizer(tapGesture)
    }
    
    private func setupMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        if let location = currentLocation {
            centerMapOnLocation(location, regionRadius: 1000) // 1km radius
        } else {
            setDefaultLocation()
        }
    }
    
    private func centerMapOnLocation(_ location: CLLocation, regionRadius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc private func currentLocationButtonTouchDown() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        UIView.animate(withDuration: 0.1) {
            self.currentLocationButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func currentLocationButtonTapped() {
        UIView.animate(withDuration: 0.1) {
            self.currentLocationButton.transform = .identity
        }
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            isLoadingLocation = true
            locationManager.startUpdatingLocation()
            
        case .denied, .restricted:
            showLocationPermissionAlert()
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        @unknown default:
            break
        }
    }
    
    private func showLocationPermissionAlert() {
        let alert = UIAlertController(
            title: "Location Access Required",
            message: "Please enable location access in Settings to use your current location.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func confirmButtonTapped() {
        let centerLocation = CLLocation(
            latitude: mapView.centerCoordinate.latitude,
            longitude: mapView.centerCoordinate.longitude
        )
        
        geocoder.reverseGeocodeLocation(centerLocation) { [weak self] placemarks, error in
            guard let self = self,
                  let placemark = placemarks?.first else { return }
            
            let address = [
                placemark.subThoroughfare,
                placemark.thoroughfare,
                placemark.locality,
                placemark.administrativeArea,
                placemark.postalCode
            ].compactMap { $0 }.joined(separator: ", ")
            
            DispatchQueue.main.async {
                self.delegate?.didSelectAddress(address, location: centerLocation)
                self.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - Search Bar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults = []
            hideSearchResults()
        } else {
            searchCompleter.queryFragment = searchText
            showSearchResults()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showSearchResults()
    }
    
    private func showSearchResults() {
        searchResultsBackgroundView.isHidden = false
        searchResultsTableView.isHidden = false
    }
    
    private func hideSearchResults() {
        searchResultsBackgroundView.isHidden = true
        searchResultsTableView.isHidden = true
        searchBar.resignFirstResponder()
    }
    
    @objc private func dismissSearchResults() {
        hideSearchResults()
    }
    
    // MARK: - Table View Data Source & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        let searchResult = searchResults[indexPath.row]
        
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedResult = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { [weak self] (response, error) in
            guard let self = self,
                  let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.centerMapOnLocation(location, regionRadius: 1000)
            self.hideSearchResults()
        }
    }
    
    // MARK: - Location Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        
        // Center map with animation
        centerMapOnLocation(location, regionRadius: 1000)
        
        // Reset loading state
        isLoadingLocation = false
        locationManager.stopUpdatingLocation()
        
        // Show success feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
        
        // Reset loading state
        isLoadingLocation = false
        
        // Show error feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        
        let alert = UIAlertController(
            title: "Location Error",
            message: "Unable to determine your location. Please try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            setDefaultLocation()
        default:
            break
        }
    }
    
    // MARK: - Map View Delegate
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Update the selected location when map stops moving
        let centerLocation = CLLocation(
            latitude: mapView.centerCoordinate.latitude,
            longitude: mapView.centerCoordinate.longitude
        )
        
        geocoder.reverseGeocodeLocation(centerLocation) { [weak self] placemarks, error in
            guard let placemark = placemarks?.first else { return }
            
            DispatchQueue.main.async {
                self?.title = [placemark.locality, placemark.administrativeArea]
                    .compactMap { $0 }
                    .joined(separator: ", ")
            }
        }
    }
}

// MARK: - MKLocalSearchCompleter Delegate

extension MapViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Search completer error: \(error)")
    }
} 