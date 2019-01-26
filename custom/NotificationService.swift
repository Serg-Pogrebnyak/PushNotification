//
//  NotificationService.swift
//  SwiftSofiaPNService
//
//  Created by Veronika Hristozova on 4/19/17.
//  Copyright © 2017 Centroida. All rights reserved.
//

import UserNotifications
import UIKit

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    //комбинируя категории кастомных пушей ShowMap для кастомных кнопок и для mutable-content получаем кастомную вьюху вместе с кнопками
    //типы пушей
    //- обычные
    //- с кастомными кнопками
    //- с кастомной вьюхой которую можно нарисовать самому (но она будет не тапабельна) (но это не точно!)
    //- с кастомным  UI (версия ниже) для видео фото и аудио
    //json  под кастомные пуши
    //{"aps":{"alert":"Testing.. (9)","badge":1,"sound":"default", "category":"ShowMap","mutable-content" :1}}
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            //изменяем тайтл боди бендж и тд

            if bestAttemptContent.categoryIdentifier == "ShowMap" {//проверяем категорию
                print("work")
                //let url = URL(string: "https://s3-us-west-2.amazonaws.com/notificationvideos/recipe2.mp4")
                //let url = URL(string: "http://cdndl.zaycev.net/826872/8453720/rauf_and_faik_-_detstvo_%28zaycev.net%29.mp3")
                let url = URL(string: "https://habrastorage.org/files/ff5/03e/e6b/ff503ee6b45d46ffb092aac33f2f282b.gif")

                downloadWithURL(url: url!, completion: { (complete) in//скачиваем

                    contentHandler(bestAttemptContent)
                })
            } else {
                print("no work")
            }
        }

    }
    func downloadWithURL(url: URL, completion: @escaping (Bool) -> Void) {
        //скачиваем фото/видео/аудио
        let task = URLSession.shared.downloadTask(with: url) { (downloadedUrl, response, error) in//получаем ссылку куда скачали, респонс и ошибку

            guard let downloadedUrl = downloadedUrl else {
                completion(false)
                return
            }
            //получаем путь к документам
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]

            var url = URL(fileURLWithPath: path)
            url = url.appendingPathComponent("sample2.gif")//расширение должно совпадать с тем какой файл фото картинка или аудио gif

            //перемещаем файл
            try? FileManager.default.moveItem(at: downloadedUrl, to: url)

            do {
                //загружаем файл
                let attachment = try UNNotificationAttachment(identifier: "video", url: url, options: nil)
                defer {
                    //откладываем выполнение с помощью defer и присваиваем обьект пушу
                    self.bestAttemptContent?.attachments = [attachment]
                    completion(true)
                }
            }
            catch {
                print("some error")
                completion(true)
            }
        }
        task.resume()
    }

    //вызывается если пуш не успел скачать данные и отображается как простой пуш
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
