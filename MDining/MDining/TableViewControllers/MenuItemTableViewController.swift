//
//  MenuItemTableViewController.swift
//  MDining
//
//  Created by Zack Safadi on 11/30/17.
//  Copyright © 2017 Flamango. All rights reserved.
//
//Viewpage that displays all MenuItems in different rows
//Segues to NutritionTableViewController

import UIKit

class MenuItemTableViewController: UITableViewController {
    
    var foodFromCourse = [MenuItem]()
    var product: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodFromCourse = product.menuItems
        self.title = product.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodFromCourse.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTitleCell", for: indexPath)
        let food = foodFromCourse[indexPath.row]
        cell.textLabel?.text = food.name
        cell.backgroundColor = Constants.Colors.tableCell
        if food.price == nil {
            cell.detailTextLabel?.text = " "
        } else {
            //Converts price to string and rounds to two decimals
            let priceText = String(format: "%.2f", food.price!)
            cell.detailTextLabel?.text = "$" + priceText
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectMenuItemSegue" {
            //Sets nutritionTVC origin to MenuItem of specific row
            if let nutritionTVC = segue.destination as? NutritionTableViewController {
                
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    
                    let food = foodFromCourse[indexPath.row]
                    nutritionTVC.product = food
                }
            }
        }
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }    
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
