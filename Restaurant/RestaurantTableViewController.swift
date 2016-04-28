//
//  RestaurantTableViewController.swift
//  Restaurant
//
//  Created by user on 2/18/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate {
    
    var restaurants : [Restaurant]?
    @IBOutlet var restaurantTableView: UITableView!
    let locationManager = CLLocationManager()
    
    var refreshController : UIRefreshControl?
    
    var location : CLLocationCoordinate2D?
    

    enum ErrorHandler:ErrorType
    {
        case ErrorFetchingResults
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        restaurantTableView.dataSource = self
        restaurantTableView.delegate = self
        
        self.refreshController = UIRefreshControl()
        self.refreshController!.addTarget(self, action: "didRefreshList", forControlEvents: .ValueChanged)
        self.restaurantTableView.addSubview(self.refreshController!)
        
        
    }
    func didRefreshList(){
        
        let restaurantAPI = RestaurantAPI()
        print("LocationValue=\(location)")
        /*while location==nil {
            sleep(1)
            print("wait dont nil")
        }*/
    
        restaurantAPI.loadRestaurants(location, completion: didLoadRestaurant)
        
       
    }
    
    func didLoadRestaurant(restaurants:[Restaurant]){
        self.restaurants = restaurants
        
        self.restaurantTableView.reloadData()
        self.refreshController!.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.restaurantTableView.reloadData()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        didRefreshList()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell", forIndexPath: indexPath) as! RestaurantTableViewCell
        
        if(self.restaurants!.count > 0){
            let restaurantItem = self.restaurants![indexPath.row]
            cell.nameRestaurant.text = restaurantItem.restaurantName
            cell.typeRestanrant.text = restaurantItem.typeName
          
            Util.loadImage(restaurantItem.imageUrl, image: cell.imageRestaurant)
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.restaurants?.count ?? 0
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMenuRes" {
            let menuResViewController = segue.destinationViewController as! MenuResViewController
            
            // Get cell generate segue
            if let selectRestaurantCell = sender as? RestaurantTableViewCell {
                let indexPath = restaurantTableView.indexPathForCell(selectRestaurantCell)!
                let selectedRestaurant = restaurants![indexPath.row]
                menuResViewController.restaurant = selectedRestaurant
            }
        }
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.location = locValue
    }
    
   


    
    

    
    
  
}
