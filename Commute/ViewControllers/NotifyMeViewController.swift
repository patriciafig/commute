//
//  NotifyMeViewController.swift
//  Commute
//
//  Created by Patricia Figueroa on 27/03/18.
//  Copyright © 2018 Patricia Figueroa. All rights reserved.
//

import UIKit
import UserNotifications

class NotifyMeViewController: UIViewController {

    
    @IBOutlet weak var txtInput: UITextField!
    @IBOutlet weak var btnSetNotification: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.btnSetNotification.layer.cornerRadius = 5
        
        // Configure User Notification Center
        UNUserNotificationCenter.current().delegate = self
    }

    
    @IBAction func setNotificationClick(_ sender: UIButton) {
        
        // Request Notification Settings
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    
                    // Schedule Local Notification
                    self.scheduleLocalNotification()
                })
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotification()
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
        
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    private func scheduleLocalNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Notification Demo"
        notificationContent.subtitle = "Local Notifications"
        notificationContent.body = "This is how to schedule local notifications with the User Notifications framework."
        
        // Add Trigger
        // Change time interval according to user input
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 2.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }

}


extension NotifyMeViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}

