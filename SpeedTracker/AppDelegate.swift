//
//  AppDelegate.swift
//  SpeedTracker
//
//  Created by Nikita Shestakov on 07.12.2024.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("App did finish launching")

//        // Регистрация фоновой задачи
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.kaska.SpeedTracker", using: nil) { task in
//            print("Фоновая задача запущена")
//            // Запуск задачи обновления виджета
//            self.handleBackgroundTask(task)
//        }
        return true
    }
    
    // не уходит в фоновый режим!!! хз почему
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("App entered background")
        scheduleBackgroundTask()
    }
    
    func scheduleBackgroundTask() {
        print("Запланировать фоновую задачу")
        let request = BGAppRefreshTaskRequest(identifier: "com.kaska.SpeedTracker")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60) // Запуск через 1 минуту
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Фоновая задача успешно запланирована.")  // Это тоже должно сработать

        } catch {
            print("Не удалось запланировать задачу фона: \(error)")
        }
    }

    func handleBackgroundTask(_ task: BGTask) {
        // Задача должна завершиться в пределах ограниченного времени
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }
        // Обновление данных для виджета
        updateWidgetData()
        // После выполнения работы, помечаем задачу как завершенную
        task.setTaskCompleted(success: true)
        // Запланировать новую задачу
        scheduleBackgroundTask()
    }

    func updateWidgetData() {
        // Тут можно обновить данные для виджета. Например, использовать UserDefaults или любой другой способ
        let emoji = EmojiProvider.random()
        guard let data = try? JSONEncoder().encode(emoji) else {
            return
        }
        let userDefaults = UserDefaults(suiteName: "group.com.kaska.SpeedTracker")
        userDefaults?.set(data, forKey: "emoji")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

