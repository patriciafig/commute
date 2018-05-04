//
//  VehiclePositionViewController.swift
//  Commute
//
//  Created by Patricia Figueroa on 27/03/18.
//  Copyright © 2018 Patricia Figueroa. All rights reserved.
//

import UIKit
import Alamofire

final class VehiclePositionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    var arrayVehicles = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // (optional) include this line if you want to remove the extra empty cell divider lines
         self.tableView.tableFooterView = UIView()
        
        
        getVehicleData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Vehicle Position Table"
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayVehicles.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        let dict = self.arrayVehicles.object(at: indexPath.row) as! NSDictionary
        let vehicleDict = (dict.object(forKey: "vehicle") as! NSDictionary).object(forKey: "vehicle") as! NSDictionary
//        let positionDict = (dict.object(forKey: "vehicle") as! NSDictionary).object(forKey: "position") as! NSDictionary
        
        // set the text from the data model
        cell.textLabel?.text = String(format: "Vehicle: %@", vehicleDict.object(forKey: "label") as! CVarArg)
//        cell.detailTextLabel?.text = String(format: "Position: %@, %@", positionDict.object(forKey: "latitude") as! CVarArg, positionDict.object(forKey: "longitude") as! CVarArg)
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
    
    
    
    /*
     
     Uses VehiclePosition.json file
     File Location: /GTFS Demo/Server/python/VehiclePosition.json
     
     */
    // Get data from our python API
    func getVehicleData(){
        
        let url = "\(K_WEB_SERVICE_URL)\(K_PATH_VEHICLE)"
        print (url)
        
        Alamofire.request(url, method: .get, parameters: nil)
            .responseJSON { response in
                print("JSON:\(String(describing: response.result.value))")
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        print(data)
                        let dict = data as! NSDictionary
                        self.arrayVehicles = dict.object(forKey: "entity") as! NSArray
                        self.tableView.reloadData()
                    }
                    
                case .failure(_):
                    
                    print("Error message:\(String(describing: response.result.error))")
                    break
                    
                }
            }
            .responseString { response in
                print("String:\(String(describing: response.result.value))")
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        print(data)
                    }
                    
                case .failure(_):
                    print("Error message:\(String(describing: response.result.error))")
                    break
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
