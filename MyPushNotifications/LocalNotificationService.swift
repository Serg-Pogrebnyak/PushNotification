//
//  LocalNotificationModel.swift
//  MyPushNotifications
//
//  Created by Sergey Pogrebnyak on 1/26/19.
//  Copyright © 2019 Sergey Pogrebnyak. All rights reserved.
//

import Foundation
import UserNotifications

struct LocalNotificationService {
    //local notifications
    func sendLocalNotification(title: String, body: String, notificationIdentifier:String, afterNowSeconds seconds: TimeInterval, compleation: @escaping (Bool) -> ()) {
        //compleation - successfully added to Notification queue or no
        let date = Date(timeIntervalSinceNow: seconds)

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
        center.add(request) { (error) in
            compleation(error == nil ? false : true)
        }
    }

    func removeNotification(withIdentifier identifiers: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
