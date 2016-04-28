//
//  MenuController.swift
//  Restaurant
//
//  Created by user on 2/23/16.
//  Copyright © 2016 Imsi. All rights reserved.
//

import UIKit

class MenuController: UIViewController {
    
    var menuItem : Menu?
    @IBOutlet weak var imageMenu: UIImageView!
    @IBOutlet weak var nameMenu: UILabel!
    @IBOutlet weak var costMenu: UILabel!
    
    @IBOutlet weak var numberMenu: UILabel!
    @IBOutlet weak var costTotal: UILabel!
    
    
    @IBOutlet weak var moreInfoTextView: UITextView!
    
    @IBAction func addToCartButton(sender: AnyObject) {
        let api = MenutoCartAPI()
        if menuItem != nil{
            api.postMenuToCart(Util.getUserID()!,menu: self.menuItem!, number: Int(numberMenu.text!)!, des: self.moreInfoTextView.text, completion: didPosttoCart)
        }
        
    }
    
    
    @IBAction func decreaseNumber(sender: UIButton) {
        var number = Int(numberMenu.text!)
        number = checkNumber(number! - 1)
        
        numberMenu.text = String(number!)
        calculateTotal()
    }
    @IBAction func increaseNumber(sender: UIButton) {
        var number = Int(numberMenu.text!)
        number = checkNumber(number! + 1)
        numberMenu.text = String(number!)
        calculateTotal()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let menu = menuItem{
            nameMenu.text = menu.menu_name
            costMenu.text = "ราคา \(menu.menu_cost!) บาท"
        }
        Util.loadImage((menuItem?.menu_image_url)!, image: imageMenu)
        numberMenu.text = String(1)
        calculateTotal()
    
        
    }
    override func viewDidAppear(animated: Bool) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func didPosttoCart(isPost:Bool){
        if(isPost){
            navigationController?.popViewControllerAnimated(true)
            let tabarray = self.tabBarController?.tabBar.items as NSArray!
            let tabItem = tabarray.objectAtIndex(1) as! UITabBarItem
            tabItem.badgeValue = "3"
        }
        else{
            //code for post failed
        }
        
        
    }
    /*func didPosttoCart(isPost:Bool,number:Int){
        if(isPost){
            navigationController?.popViewControllerAnimated(true)
            let tabarray = self.
        }
        else{
            //code for post failed
        }
        
        
    }*/
    func calculateTotal(){
        let cost : Int = (menuItem?.menu_cost)!
        let total = cost * Int(numberMenu.text!)!
        print("Cost: \(cost) and \(numberMenu.text!)")
        self.costTotal.text = String(total)
    }
    func checkNumber(count : Int) ->Int{
        if count <= 0{
            return 1
        }
        return count
    }

}
