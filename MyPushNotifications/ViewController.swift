//
//  ViewController.swift
//  MyPushNotifications
//
//  Created by Sergey Pogrebnyak on 12/7/18.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        LocalNotificationService().sendLocalNotification(title: "Title", body: "Body", notificationIdentifier: "Identifier", afterNowSeconds: 20) { (isError) in
            if isError {
                print("Some Error")
            } else {
                print("Good work")
            }
        }

    }

}

