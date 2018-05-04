//
//  ViewController.swift
//  Commute
//
//  Created by Patricia Figueroa on 26/03/18.
//  Copyright © 2018 Patricia Figueroa. All rights reserved.
//

import UIKit
import Alamofire
//import Mapbox


class ViewController: UIViewController {

    @IBOutlet weak var btnTripUpdate: UIButton!
    @IBOutlet weak var btnVehiclePosition: UIButton!
    @IBOutlet weak var btnSetNotification: UIButton!

    
//    let server_url = "http://127.0.0.1:5000/"
//    let path_trip = "tripUpdate"
//    let path_vehicle = "vehiclePosition"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.btnTripUpdate.layer.cornerRadius = 5
        self.btnVehiclePosition.layer.cornerRadius = 5
        self.btnSetNotification.layer.cornerRadius = 5
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Button Clicks
    
    /*
        Open TripUpdate viewcontroller
     */
    @IBAction func tripUpdateClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TripUpdateViewController") as! TripUpdateViewController
       self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    /*
        Open VehiclePosition viewcontroller
     */
    @IBAction func vehiclePositionClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "VehiclePositionViewController") as! VehiclePositionViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    /*
        Open NotifyMe viewcontroller
     */
    @IBAction func notificationClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NotifyMeViewController") as! NotifyMeViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

