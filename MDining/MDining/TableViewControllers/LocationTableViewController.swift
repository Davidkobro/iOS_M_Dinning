//
//  LocationTableViewController.swift
//  TableView
//
//  Created by David Kob on 11/27/17.
//  Copyright © 2017 David Kobrosky. All rights reserved.
//
//Viewpage that displays all Dining locations separated into sections for dininghall, market, and cafes. Also displays the meal balance button that redirects to the internet
//Segues to MealTableViewController

import UIKit
import Foundation
import SystemConfiguration

class LocationTableViewController: UITableViewController {
    
    // variables for activity indicators
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    let loadingView = UIView()
    let loadingLabel = UILabel()

    // Initializes dininghall, cafe, and market arrays
    var diningLocations = [DiningLocation]()
    var diningHallLocations = [DiningLocation]()
    var cafeLocations = [DiningLocation]()
    var marketLocations = [DiningLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAlert()
        setLoadingScreen()
        // calls preloading file
        MenusProvider.init()
        self.tableView.backgroundColor = Constants.Colors.sectionHeader
        // observer for post notification in MenusProvider for dining locations
        NotificationCenter.default.addObserver(self, selector: #selector(LocationTableViewController.actOnNotification), name: NSNotification.Name(rawValue: notificationKey1), object: nil)
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
        // assings dining locations pulled from API to diningLocations array
        diningLocations = MenusProvider.shared.diningLocations
        //Organizes locations by type
        self.diningHallLocations = diningLocations.filter({ (Location) -> Bool in
            if Location.type == DiningLocation.DiningLocationType.diningHall {
                return true
            } else {
                return false
            }
        })
        self.cafeLocations = diningLocations.filter({ (Location) -> Bool in
            if Location.type == DiningLocation.DiningLocationType.cafe {
                return true
            } else {
                return false
            }
        })
        self.marketLocations = diningLocations.filter({ (Location) -> Bool in
            if Location.type == DiningLocation.DiningLocationType.market {
                return true
            } else {
                return false
            }
        })
        self.tableView.reloadData()
        removeLoadingScreen()
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
            return diningHallLocations.count
        } else if section == 1 {
            return marketLocations.count
        } else  {
            return cafeLocations.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTitleCell", for: indexPath)
        if indexPath.section == 0 {
            let diningLocation = diningHallLocations[indexPath.row]
            cell.textLabel?.text = diningLocation.name
        } else if indexPath.section == 1 {
            let diningLocation = marketLocations[indexPath.row]
            cell.textLabel?.text = diningLocation.name
        } else {
            let diningLocation = cafeLocations[indexPath.row]
            cell.textLabel?.text = diningLocation.name
        }
        cell.backgroundColor = Constants.Colors.tableCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Dining Halls"
        } else if section == 1 {
            return "Markets"
        } else {
            return "Cafés"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectLocationSegue" {
            
            if let locationTVC = segue.destination as? MealTableViewController {
                
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    if indexPath.section == 0 {
                        //Sets locationTVC origin to dining location of specific row
                        let diningLocation = diningHallLocations[indexPath.row]
                        locationTVC.product = diningLocation
                    } else if indexPath.section == 1 {
                        //Sets locationTVC origin to market location of specific row
                        let diningLocation = marketLocations[indexPath.row]
                        locationTVC.product = diningLocation
                    } else {
                        //Sets locationTVC origin to cafe location of specific row
                        let diningLocation = cafeLocations[indexPath.row]
                        locationTVC.product = diningLocation
                    }
                }
            }
        }
    }
    
    // function connected to Meal Balance button, redirects to URL
    @IBAction func mealbalancelink(_ sender: UIButton) {
        let url = URL(string: "https://www.myplan.housing.umich.edu/login.php")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    private func setLoadingScreen() {
        // Sets the view which contains the loading text and the activityIndicator
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (tableView.frame.width / 2) - (width / 2)
        let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
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

