//
//  MenuResViewController.swift
//  Restaurant
//
//  Created by user on 2/22/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import UIKit

class MenuResViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    
    var restaurantInfo : RestaurantInfo?
    var restaurant : Restaurant?

    @IBOutlet var restaurantImage: UIImageView!
    
    @IBAction func searchField(sender: UITextField) {
    
    }
    
    @IBOutlet var menuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        if restaurant != nil{
            let restaurantInfoAPI = MenuOfRestaurantAPI(restaurant: self.restaurant!)
            restaurantInfoAPI.loadMenuOfRestaurant(didLoadRestaurant)
        }
       

        
        
        
        
        
        //restaurantInfoAPI.loadRestaurants(didLoadRestaurant)
    }
    
    
    
    
    
    func didLoadRestaurant(restaurantsInfo : RestaurantInfo){
        self.restaurantInfo = restaurantsInfo
        
        
        
        self.menuTableView.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuTableCell
        
        if((self.restaurantInfo) != nil){
            //cell.nameMenu.text = self.restaurantInfo.id
            let menu : Menu = (self.restaurantInfo?.listMenu[indexPath.row])!
            cell.nameMenu.text = menu.menu_name
            cell.costMenu.text = "Cost : \(menu.menu_cost!) Bath"
            if let checkedUrl = NSURL(string: menu.menu_image_url!) {
                cell.imageMenuCell.contentMode = .ScaleAspectFill
                downloadImage(checkedUrl, imageRestaurant: cell.imageMenuCell)
            }
            
            
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantInfo?.listMenu.count ?? 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    func downloadImage(url: NSURL,imageRestaurant: UIImageView){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                imageRestaurant.image = UIImage(data: data)
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMenuItem" {
            let menuController = segue.destinationViewController as! MenuController
            
            // Get cell generate segue
            if let selectedMenuCell = sender as? MenuTableCell {
                let indexPath = menuTableView.indexPathForCell(selectedMenuCell)!
                let selectedMenu = self.restaurantInfo?.listMenu[indexPath.row]
                menuController.menuItem = selectedMenu
            }
        }
    }


}
