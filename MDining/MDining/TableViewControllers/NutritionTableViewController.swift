//
//  NutritionTableViewController.swift
//  MDining
//
//  Created by Zack Safadi on 11/30/17.
//  Copyright © 2017 Flamango. All rights reserved.
//
//Viewpage that displays Serving size, description, and nutrional info

import UIKit

class NutritionTableViewController: UITableViewController {
    
    var product: MenuItem!
    var nutritionInfo = [MenuItem.NutritionFact]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nutrition = product {
            self.nutritionInfo = nutrition.nutritionInfoArray
        }
        self.title = product.name
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        }
        else {
            return nutritionInfo.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionTitleCell", for: indexPath)
        if nutritionInfo.count > 0 {
            let nutrition = nutritionInfo[indexPath.row]
            if indexPath.section == 0 {
                if product.infoLabel == nil{
                    cell.textLabel?.text = "No Description"
                    cell.detailTextLabel?.text = nil
                } else {
                    cell.textLabel?.text = product.infoLabel
                    cell.detailTextLabel?.text = nil
                }
            } else if indexPath.section == 1 {
                let servingInGrams = product.servingSizeInGrams!
                let gramText = String(describing: servingInGrams)
                if product.servingSize == nil && product.servingSizeInGrams == nil {
                    cell.textLabel?.text = "No Info Available"
                } else if product.servingSizeInGrams == nil && product.servingSize != nil {
                    cell.textLabel?.text = product.servingSize
                } else if product.servingSize == nil && product.servingSizeInGrams != nil {
                    cell.textLabel?.text =  gramText + "g"
                } else {
                    cell.textLabel?.text = product.servingSize! + " (" + gramText + "g)"
                }
                cell.detailTextLabel?.text = nil
            } else {
                cell.textLabel?.text = nutrition.name
                cell.detailTextLabel?.text = nutrition.value
            }
        } else {
            if indexPath.section == 0 {
                cell.textLabel?.text = "No Description Available"
                cell.detailTextLabel?.text = nil
            } else {
                cell.textLabel?.text = "No Info Available"
                cell.detailTextLabel?.text = nil
            }
        }
        cell.backgroundColor = Constants.Colors.tableCell
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Description"
        } else if section == 1 {
            return "Serving Size"
        } else{
            return "Nutrition Information"
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
}
