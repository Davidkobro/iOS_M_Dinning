//
//  CourseTableViewController.swift
//  MDining
//
//  Created by Elisabeth Furr on 11/29/17.
//  Copyright © 2017 Flamango. All rights reserved.
//
//Viewpage that displays all Courses in different rows
//Segues to MenuItemTableViewController

import UIKit

class CourseTableViewController: UITableViewController {
    
    //Initializes empty array of type Course and variable of type meal
    var coursesOfMeal = [Course]()
    var product: Meal!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //if product contains an array of type courses, assign to CourseOfMeal
        if let courses = product.courses {
            self.coursesOfMeal = courses
        }
        self.title = product.description 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    // sets the number of sections to 1 if there are courses to display
    // if there are no courses, displays a message saying nothing is served 
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if coursesOfMeal.count != 0 {
            tableView.separatorStyle = .singleLine
            numOfSections = 1
            tableView.backgroundView = nil
        }else {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "Sorry, nothing is served for this meal today"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesOfMeal.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTitleCell", for: indexPath)
        let course = coursesOfMeal[indexPath.row]
        //if no courses exist for selected meal, display message for the meal,
        // else display course name
        if product.courses == nil {
            cell.textLabel?.text = product.message
            cell.backgroundColor = Constants.Colors.tableCell
            return cell
        } else {
            cell.textLabel?.text = course.description
            cell.backgroundColor = Constants.Colors.tableCell
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectCourseSegue" {
            //sets menuItemTVC origin as course and destination as MenuItemTableViewController
            if let menuItemTVC = segue.destination as? MenuItemTableViewController {
                
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    
                    let course = coursesOfMeal[indexPath.row]
                    menuItemTVC.product = course
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
