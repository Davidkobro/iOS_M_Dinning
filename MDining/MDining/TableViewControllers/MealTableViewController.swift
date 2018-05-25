//
//  MealTableViewController.swift
//  MDining
//
//  Created by Elisabeth Furr on 11/28/17.
//  Copyright © 2017 Flamango. All rights reserved.
//
//Viewpage that displays all Meals in different rows and Address and Hours
//Segues to CourseTableViewController or InfoTableViewController

import UIKit
import Foundation
import SystemConfiguration

class MealTableViewController: UITableViewController {
    // variables for activity indicator while data is still loading
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    let loadingView = UIView()
    let loadingLabel = UILabel()
    
    var meals = [Meal]()
    var hoursAndAdd: DiningLocation!
    var product: DiningLocation!
    
    @IBOutlet weak var locationImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAlert()
        setLoadingScreen()
        // call to MenusProvider file which contains preloaded data
        MenusProvider.init()
        // observer for notification, calls function actOnNotification when data
        // is loaded 
        NotificationCenter.default.addObserver(self, selector: #selector(LocationTableViewController.actOnNotification), name: NSNotification.Name(rawValue: notificationKey2), object: nil)
        // assigns image to respective dining location
        if product.name == "Bursley Dining Hall" {
            locationImage.image = #imageLiteral(resourceName: "Bursley")
        } else if product.name == "East Quad Dining Hall" {
            locationImage.image = #imageLiteral(resourceName: "East Quad")
        } else if product.name == "Lawyers Club Dining Hall" {
            locationImage.image = #imageLiteral(resourceName: "Law")
        } else if product.name == "Markley Dining Hall" {
            locationImage.image = #imageLiteral(resourceName: "Markley")
        } else if product.name == "Martha Cook Dining Hall" {
            locationImage.image = #imageLiteral(resourceName: "Martha Cook")
        } else if product.name == "Mosher Jordan Dining Hall" {
            locationImage.image = #imageLiteral(resourceName: "Mojo")
        } else if product.name == "North Quad Dining Hall" {
            locationImage.image = #imageLiteral(resourceName: "North Quad")
        } else if product.name == "South Quad Dining Hall" {
            locationImage.image = #imageLiteral(resourceName: "South Quad")
        } else if product.name == "Twigs at Oxford" {
            locationImage.image = #imageLiteral(resourceName: "Twigs at Oxford")
        } else if product.name == "Blue Apple" {
            locationImage.image = #imageLiteral(resourceName: "Blue Apple")
        } else if product.name.contains("Ugos") {
            locationImage.image = #imageLiteral(resourceName: "Ugos")
        } else if product.name == "Victors" {
            locationImage.image = #imageLiteral(resourceName: "Victors Market")
        } else if product.name == "Beansters League" {
            locationImage.image = #imageLiteral(resourceName: "Beanster's League")
        } else if product.name == "Berts Cafe" {
            locationImage.image = #imageLiteral(resourceName: "Bert's Cafe")
        } else if product.name == "Fields Cafe" {
            locationImage.image = #imageLiteral(resourceName: "Fields Cafe")
        } else if product.name == "Fireside Cafe" {
            locationImage.image = #imageLiteral(resourceName: "Fireside Cafe")
        } else if product.name == "Fireside Roast" {
            locationImage.image = #imageLiteral(resourceName: "Fireside Roast")
        } else if product.name == "MUJO Cafe" {
            locationImage.image = #imageLiteral(resourceName: "Mujo Cafe")
        } else if product.name == "Cafe 32" {
            locationImage.image = #imageLiteral(resourceName: "Cafe 32")
        } else {
            locationImage.image = #imageLiteral(resourceName: "Java Blu")
        }
        self.title = product.name
        
    }
    
    // the next two functions check for internet availability and display an alert
    // if a connection isn't found
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        // flags that notify if internet is reachable and if there needs to be a
        // connection
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func showAlert() {
        if !isInternetAvailable() {
            let alert = UIAlertController(title: "No Connection Detected", message: "Please connect to the internet and restart the app", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // function called in notification observer
    @objc func actOnNotification() {
        // if there are meals for the specified dining location, assings them to the
        // meals array
        if let mealsTest = MenusProvider.shared.diningLocationDict[product.name] {
            meals = mealsTest
            self.tableView.reloadData()
            removeLoadingScreen()
        }
        else {
            print("Not able to get meals from provider")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return meals.count
        } else {
            return 1
        }
    }
    
    //Separates Meal cells and 'Address and Hours' cell to segue to their respective tableviews
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MealTitleCell", for: indexPath)
            let meal = meals[indexPath.row]
            cell.textLabel?.text = meal.description
            cell.backgroundColor = Constants.Colors.tableCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTitleCell", for: indexPath)
            cell.textLabel?.text = "Address and Hours"
            cell.backgroundColor = Constants.Colors.tableCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Meals"
        } else {
            return "Info"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectMealSegue" {
            //Sets courseTVC origin to meal of specific row
            if let courseTVC = segue.destination as? CourseTableViewController {
                
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    let meal = meals[indexPath.row]
                    courseTVC.product = meal
                }
            }
        } else if segue.identifier == "SelectInfoSegue" {
            // sets infoTVC origin to Address and Hours cell
            if let infoTVC = segue.destination as? InfoTableViewController {
                let info = product
                infoTVC.product = info
                
            }
        }
    }
    
    // Set the activity indicator into the main view
    private func setLoadingScreen() {
        
        // Sets the view which contains the loading text and the activityIndicator
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        // dividing by 2.75 sets the indicator and text right above the image of
        // the dining location
        let y = (tableView.frame.height / 2.75) - (height / 2.75) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        // Sets activityIndicator
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activityIndicator.startAnimating()
        
        // Adds text and activityIndicator to the view
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(loadingLabel)
        
        tableView.addSubview(loadingView)
        
    }
    
    // Remove the activity indicator from the main view
    private func removeLoadingScreen() {
        
        // Hides and stops the text and the activityIndicator
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        loadingLabel.isHidden = true
        
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


// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
