//
//  NotificationViewController.swift
//  CusomView
//
//  Created by Sergey Pogrebnyak on 12/14/18.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import MapKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {


    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var textForUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        guard let latitude = userInfo["latitude"] as? CLLocationDistance,
            let longitude = userInfo["longitude"] as? CLLocationDistance,
            let radius = userInfo["radius"] as? CLLocationDistance else {
                return
        }
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: radius,
                                        longitudinalMeters: radius)
        textForUser.text = userInfo["textForUser"] as? String
        myMap.setRegion(region, animated: true)
    }

}
