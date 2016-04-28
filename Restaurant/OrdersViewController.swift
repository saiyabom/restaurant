//
//  OrdersViewController.swift
//  Restaurant
//
//  Created by user on 2/16/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var orderTableView: UITableView!
    
    
    var cellDescriptors: NSMutableArray?
    //var cellMutableArray: NSMutableArray?
    var visibleRowsPerSection = [Int]()
    
    
    
    var orderList : [Order]?
    var selectedIndexPath : NSIndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.orderTableView.delegate = self
        self.orderTableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        //let restaurantInfoAPI = MenuOfRestaurantAPI()
        //restaurantInfoAPI.loadMenuOfRestaurant(didLoadOrder)
        orderTableView.registerNib(UINib(nibName: "OrderMainCell", bundle: nil), forCellReuseIdentifier: "OrderMainCell")
        orderTableView.registerNib(UINib(nibName: "OrderSubCell", bundle: nil), forCellReuseIdentifier: "OrderSubCell")
        let api = OrderAPI()
        api.loadOrderList(didLoadOrder)
        
 
        
        
        
        
        //restaurantInfoAPI.loadRestaurants(didLoadRestaurant)
    }
    
    func didLoadOrder(orderList : [Order]?){
        
        self.orderList = orderList
        self.orderTableView.reloadData()
        self.cellDescriptors = NSMutableArray(array: parseOrdertoDic(self.orderList!))
        //print(getCellDescriptorForIndexPath())
        getIndicesOfVisibleRows()
        self.orderTableView.reloadData()
        

    }
    func parseOrdertoDic(orderList:[Order])->[NSDictionary]{
        var result = [NSDictionary]()
        for var i=0; i<orderList.count; i++ {
            result.append(NSMutableDictionary(dictionary: orderList[i].getDictionaray()))
            for var j=0; j<orderList[i].menu_list?.count; j++ {
                result.append(NSMutableDictionary(dictionary:orderList[i].menu_list![j].getDictionary()))
            }
        }
        return result
    }
    func getCellDescriptorForIndexPath(row:Int) -> NSMutableDictionary {
        //let indexOfVisibleRow = visibleRowsPerSection[indexPath.section][indexPath.row]
        let index = Int(visibleRowsPerSection[row])
        let cellDescriptor = cellDescriptors![index]
        //print("cellDescriptor: \(cellDescriptor)")
        return cellDescriptor as! NSMutableDictionary
    }
    func getIndicesOfVisibleRows() {
        visibleRowsPerSection.removeAll()
        
        /*for currentSectionCells in cellDescriptors {
            var visibleRows = [Int]()
            
            for row in 0...((currentSectionCells as! [[String: AnyObject]]).count - 1) {
                if currentSectionCells[row]["isVisible"] as! Bool == true {
                    visibleRows.append(row)
                }
            }
            
            visibleRowsPerSection.append(visibleRows)
        }*/
        var i = 0
        for currentSectionCells in cellDescriptors!{
            
            let item = currentSectionCells as! [String: AnyObject]
            if item["isVisible"] as! Bool == true {
                visibleRowsPerSection.append(i)
            }
            i++
           
        }
        

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellDesc = getCellDescriptorForIndexPath(indexPath.row)
        //print(cellDesc["type"]!)
       
        if(cellDesc["cellIdentifier"]! as! String == "OrderSubCell"){
            let cell = tableView.dequeueReusableCellWithIdentifier("OrderSubCell", forIndexPath: indexPath) as! CustomCell
            cell.foodName.text! = cellDesc["menu_name"]! as! String
            cell.foodDesc.text! = cellDesc["menu_desc"]! as! String
            cell.foodNumber.text! = String(cellDesc["menu_number"]!)
            cell.foodCost.text! = String(cellDesc["menu_cost"]!)
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("OrderMainCell", forIndexPath: indexPath) as! CustomCell
            cell.restaurantName.text! = cellDesc["restaurant_name"] as! String
            cell.costOrder.text! = String(cellDesc["cost"]!)
            
            cell.orderCreatedDate.text! = cellDesc["created_at_date"] as! String
            cell.orderCreatedTime.text! = cellDesc["created_at_time"] as! String
            
            return cell
        }
       
       
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.visibleRowsPerSection.count ?? 0
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellDesc = getCellDescriptorForIndexPath(indexPath.row)
        if (cellDesc["cellIdentifier"]! as! String == "OrderSubCell"){
            return 50
        }else{
            return 100.0
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexOfTappedRow = visibleRowsPerSection[indexPath.row]
        let cell = self.cellDescriptors![indexOfTappedRow] as! [String:AnyObject]
        if cell["isExpandable"] as! Bool == true {
            var shouldExpandAndShowSubRows = false
            if cell["isExpanded"] as! Bool == false {
                shouldExpandAndShowSubRows = true
            }
            self.cellDescriptors![indexOfTappedRow].setValue(shouldExpandAndShowSubRows, forKey: "isExpanded")
            for i in (indexOfTappedRow + 1)...(indexOfTappedRow + (cell["additionalRows"] as! Int)) {
                cellDescriptors![i].setValue(shouldExpandAndShowSubRows, forKey: "isVisible")
            }
        }
        getIndicesOfVisibleRows()
        orderTableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
        

    }
    
    
    
}