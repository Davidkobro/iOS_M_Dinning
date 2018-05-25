//
//  InfoTableViewController.swift
//  MDining
//
//  Created by Zack Safadi on 11/30/17.
//  Copyright © 2017 Flamango. All rights reserved.
//
//Viewpage that displays address and hours for respected dining location

import MapKit
import UIKit

class InfoTableViewController: UITableViewController {
    
    // conects button to the code
    @IBAction func directions(_ sender: Any) {
        // defining destination - takes coordinates of each dining hall
        let latitude: CLLocationDegrees = product.coordinate.latitude
        let longitude: CLLocationDegrees = product.coordinate.longitude
        let regionDistance:CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        // sets the entire span of the region the map covers.
        let regionSpan =  MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        // enables the dining hall to show up in the middle of the map
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        // has the placemark set at the location defined
        let placemark = MKPlacemark (coordinate: coordinates)
        let mapItem = MKMapItem (placemark: placemark)
       // name of the location on the map is the same as the name in the product.
        mapItem.name = product.name
        //opens this location in maps app
        mapItem.openInMaps(launchOptions: options)
    }
    @IBOutlet weak var mapp: MKMapView!
    // sets basic points for the map view to be on the bottom of the view controller
    var hoursOfLocation = [String]()
    var address: String = ""
    var product: DiningLocation!
    let annotation = MKPointAnnotation()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let locationHour = product {
            self.hoursOfLocation = locationHour.hours
        }
        if let locationAddress = product {
            self.address = locationAddress.address.fullAddress
        }
        let centerLocation = CLLocationCoordinate2DMake(product.coordinate.latitude, product.coordinate.longitude)
        // sets span of the map view
        let mapSpan = MKCoordinateSpanMake(0.01, 0.01)
        let mapRegion = MKCoordinateRegionMake(centerLocation, mapSpan)
        self.mapp.setRegion(mapRegion, animated: true)
        annotation.coordinate = CLLocationCoordinate2D(latitude: product.coordinate.latitude, longitude: product.coordinate.longitude)
       // sets location of the pin
        mapp.addAnnotation(annotation)
        mapp.showsUserLocation = true
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // enables both rows to have one row
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return hoursOfLocation.count
        } else {
            return 1
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
        if indexPath.section == 0 || indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HourAddTitleCell", for: indexPath)
            if indexPath.section == 0 {
                cell.textLabel?.text = hoursOfLocation[indexPath.row]
            } else {
                cell.textLabel?.text = address
            }
            cell.backgroundColor = Constants.Colors.tableCell
            return cell
            }
            else {
            // Identifier for cell that links to directions
            let cell = tableView.dequeueReusableCell(withIdentifier: "takeMeHere", for: indexPath)
            cell.backgroundColor = Constants.Colors.tableCell
            return cell
        }
    }
    // sets the title of the header cells to "Hours", "Address", and "Directions" respectively
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Hours"
        } else if section == 1 {
            return "Address"
        } else {
            return "Directions"
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

