
import UIKit
import Toast_Swift
import SDWebImage

class RestaurantSearchViewController: UIViewController, RestaurantsViewProtocol  {
    
    var restDataArray:[Business] = []
    var restData:RestaurantData = RestaurantData()
    var selectedRadius:Int = 100
    var selectedOffset:Int = 0
    
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var selectedRadiusLabel: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    
    @IBAction func radiusValueChanged(_ sender: Any) {
        let slider = (sender as! UISlider)
        let radius = Int(slider.value)
        selectedRadius = radius
        print("Radius value = \(selectedRadius)")
        let value = slider.value/1000
        selectedRadiusLabel.text = String(format: "%.1f", value) + " KM"
        selectedOffset = 0
        restaurantsTableView.setContentOffset(.zero, animated: true)
        
//        restDataArray.removeAll()
//        restaurantsTableView.reloadData()
        self.view.makeToast("Pull to refresh")
    }
    
    @IBOutlet weak var restaurantsTableView: UITableView!
    
    private var restaurantsViewModel:RestaurantsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantsTableView.delegate = self
        restaurantsTableView.dataSource = self
        restaurantsTableView.register(UINib(nibName: "RestaurantsTableViewCell", bundle: nil), forCellReuseIdentifier: "RestaurantsTableViewCell")
        restaurantsTableView.separatorStyle = .none
        
        setupUI()
        
        restaurantsViewModel = RestaurantsViewModel(view: self)
        restaurantsViewModel?.bindRestaurantsViewModelToController = {
            self.updateUI()
        }
    }
    
    func setupUI() {
        radiusSlider.minimumValue = 100
        radiusSlider.maximumValue = 5000
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        restaurantsTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        restDataArray.removeAll()
        restaurantsViewModel?.callAPIToGetRestaurantData(radius: selectedRadius, offset: selectedOffset)
    }
    
    func showActIndicator() {
        DispatchQueue.main.async {
            self.showActivityIndicator()
        }
    }
    
    func hideActIndicator() {
        DispatchQueue.main.async {
            self.hideActivityIndicator()
        }
    }
    
    func showAlertView(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func updateUI() {
        restData = restaurantsViewModel?.restData ?? RestaurantData()
        restDataArray.append(contentsOf: restData.businesses)
        
        DispatchQueue.main.async {
            if self.restDataArray.count == 0 {
                self.view.makeToast("No restaurants found. Please increase the radius and try again.")
            }
            self.restaurantsTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
}

extension RestaurantSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var data:Business = Business()
        if restDataArray.count > 0 {
            data = restDataArray[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantsTableViewCell") as! RestaurantsTableViewCell
        cell.nameLbl.text = data.name
        cell.addressLbl.text = "\(data.location.address1)."
        cell.ratingsLbl.text = "\(data.ratings)"
        cell.distanceLbl.text = String(format: "%.0f", data.distance) + "m."
        cell.currentlyOpenLbl.text = data.isClosed ? "Currently CLOSED" : "Currently OPEN"
        cell.restImageView.sd_setImage(with: URL(string: data.imageURL), placeholderImage: UIImage(named: "food"))
        cell.restImageView.contentMode = .scaleToFill
        cell.ratingsLbl.layer.cornerRadius = cell.ratingsLbl.frame.size.height/2
        cell.ratingsLbl.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == restDataArray.count - 1 { // last cell
            if restData.total > restDataArray.count { // more items to fetch
                selectedOffset += GlobalConstants.pageLimit
                restaurantsViewModel?.callAPIToGetRestaurantData(radius: selectedRadius, offset: selectedOffset)
            }
        }
    }

}

