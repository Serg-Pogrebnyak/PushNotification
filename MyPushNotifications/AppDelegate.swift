//
//  AppDelegate.swift
//  MyPushNotifications
//
//  Created by Sergey Pogrebnyak on 12/7/18.
//  Copyright © 2018 Sergey Pogrebnyak. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        registerForPushNotifications()//рeгаемся для пушей

        return true
    }

    //дергается когда пуш приходит но приложение в бекграунде
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void ) {
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        //тихий пуш
        if aps["content-available"] as? Int == 1 {
            print("get slient push notifications")
            completionHandler(.noData)
        }
        //json под него
        //{"aps": {"content-available" : 1}}

        //work with aps
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in

            print("Permission granted: \(granted)")

            guard granted else { return }//проверяем разрешено ли отправлять уведомления

            //создаем кнопки
            let viewAction = UNNotificationAction(identifier: "VIEW", title: "View", options: [])//действие без входа в приложение
            let viewAction2 = UNNotificationAction(identifier: "VIEW2", title: "View2", options: [.foreground])//действие с входом в приложение
            let viewAction3 = UNNotificationAction(identifier: "VIEW3", title: "View3", options: [.destructive, .authenticationRequired])//спец действие + обязательно расзблокировка девайса

            let newsCategory = UNNotificationCategory(identifier: "ShowMap", actions: [viewAction, viewAction2, viewAction3], intentIdentifiers: [], options: [])//регистрируем категорию
            //json pod push s knopkami
            //{"aps":{"alert":"Testing.. (2)","badge":1,"sound":"default", "category":"ShowMap"}}

            UNUserNotificationCenter.current().setNotificationCategories([newsCategory])//добавляем в пуш ее
            self?.getNotificationSettings()//получаем настройки пушей
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()//регистрация на сервере APNS
            }
            //print("Notification settings: \(settings)")
        }
    }

    //функции которые вызываются в результате регистрации приложения в APNS когда не успешно и когда успешно все прошло
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("") { $0 + String(format: "%02X", $1) }
        print("APNs device token: \(deviceTokenString)")
    }

}
//extension для работы с пушами которые от кастомных кнопок и тд прилетают! (нужна подписка на делегата!!!!!!!)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {

        // 1
        let userInfo = response.notification.request.content.userInfo

        // 2
        //дергаются функции из кастомных кнопок которые добавлены высше UNNotificationAction(
        if let aps = userInfo["aps"] as? [String: AnyObject] {
            // 3
            if response.actionIdentifier == "VIEW" {
                print("work")
            } else if response.actionIdentifier == "VIEW2" {
                print("work2")
            }
            else if response.actionIdentifier == "VIEW3" {
                print("work3")
            }

        }

        // 4
        completionHandler()
    }
}
