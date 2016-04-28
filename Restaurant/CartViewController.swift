//
//  CartViewController.swift
//  Restaurant
//
//  Created by user on 2/16/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import UIKit
import RealmSwift

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var id_user:String?
    
    var orderFoods : [Menu]? = nil
    

    @IBOutlet weak var cartTableView: UITableView!
    
    @IBOutlet weak var costOfAllFoods: UILabel!
    
    
    @IBOutlet weak var costDelivery: UILabel!
    
    
    @IBOutlet weak var totalOfCart: UILabel!
    
    
    
    
    @IBAction func confirmOrder(sender: UIButton) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Cart", image: UIImage(named: "second"), tag: 1)
        
        // Configure Tab Bar Item
        tabBarItem.badgeValue = "8"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableView.dataSource = self
        cartTableView.delegate = self
        print("CartView->user_id:\(Util.getUserID())")
        let api = CartAPI(user_id: Util.getUserID()!)
        api.loadItemsInCart(didLoadItemsInCart)
        
    }
    func didLoadItemsInCart(items:[Menu]){
        self.orderFoods = items
        var costOfFoods = 0
        for var i=0; i<items.count; i=i+1{
            costOfFoods = costOfFoods + items[i].menu_cost!
        }
        self.costOfAllFoods.text = String(costOfFoods)
        self.cartTableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CartItem", forIndexPath: indexPath) as! CartCell
        if(self.orderFoods?.count>0){
            let item = self.orderFoods![indexPath.row]
            cell.nameFood.text = item.menu_name
            cell.numberOfFood.text = String(item.menu_number!)
            cell.costPerFood.text = String(item.getTotalCostofFood())
                
            //Util.loadImage(item.menu_image_url!, image: cell.imageFood)
            
        }
        return cell
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.orderFoods?.count ?? 0
    }
    
    
    
    
        
    
}
