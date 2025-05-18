//
//  ViewController.swift
//  SpeedTracker
//
//  Created by Nikita Shestakov on 07.12.2024.
//

import UIKit
import SwiftUI
import WidgetKit
import CoreLocation
import BackgroundTasks


class ViewController: UIViewController {


    
    //let userDefaults = UserDefaults(suiteName: "group.com.kaska.SpeedTracker")
   
    // переменная чтоб обмениваться данными между виджетом и очновным приложением
    var emojiDataa: Data? {
        didSet {
            // Сохраняем данные в UserDefaults
            saveEmojiData(emojiDataa)
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        print("Action")
              // Генерируем случайный эмодзи (замените EmojiProvider.random() на вашу реализацию)
              let emoji = EmojiProvider.random()
              // Сохраняем эмодзи
              save(emoji)
              // Перезагружаем виджеты
              WidgetCenter.shared.reloadTimelines(ofKind: "MyWidget") // kind одинаковый должен быть!!!
    }
    
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var speedLabel: UILabel!
    var locationManager: CLLocationManager!
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        timeLabel.text = "Time: 00:00:00"
        // Запускаем таймер для обновления времени каждую секунду
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//                // Инициализация CLLocationManager
//                locationManager = CLLocationManager()
//                // Установка делегата
//                locationManager.delegate = self
//                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation  // наивысшая точность
//                locationManager.distanceFilter = 1  // обновление местоположения при движении на 1 метр
//                // Запрашиваем разрешение на доступ к местоположению
//                locationManager.requestWhenInUseAuthorization()
//                // Начинаем обновление местоположения
//                locationManager.startUpdatingLocation()
    }
    
    
    private func save(_ emoji: EmojiDetails) {
        guard let data = try? JSONEncoder().encode(emoji) else {
            return
        }
        emojiDataa = data
    }

    // Функция для сохранения данных в UserDefaults
    private func saveEmojiData(_ data: Data?) {
        // Сохраняем данные в UserDefaults
        let userDefaults = UserDefaults(suiteName: "group.com.kaska.SpeedTracker")
        userDefaults?.set(data, forKey: "emoji")
    }
}


//struct ContentView: View {
//    @AppStorage("emoji", store: UserDefaults(suiteName: "group.com.kaska.SpeedTracker"))
//    var emojiData = Data()
//    
//    var body: some View {
//        Button(action: {
//            print("Action")
//            //save(EmojiProvider.random())
//            WidgetCenter.shared.reloadTimelines(ofKind: "MyEmojiWidget")
//        }, label: {
//            Text("Tap me!")
//        })
//    }
//    
//}
























extension ViewController: CLLocationManagerDelegate {
    // Метод делегата для получения обновлений местоположения
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }

            // Получаем скорость из объекта CLLocation
            let speed = location.speed

            // Если скорость отрицательная, значит, данные GPS не актуальны
            if speed < 0 {
                speedLabel.text = "Speed: 0.0 m/s"
            } else {
                // Обновляем метку с текущей скоростью (в м/с)
                speedLabel.text = String(format: "Speed: %.2f m/s", speed)
            }
        }

        // Обработка ошибок (например, если не удается получить местоположение)
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error: \(error.localizedDescription)")
        }

        // Метод для остановки обновлений местоположения, когда они больше не нужны
        func stopTrackingSpeed() {
            locationManager.stopUpdatingLocation()
        }
    
}

extension ViewController {
    // Метод для запуска таймера
       func startTimer() {
           // Останавливаем старый таймер (если он есть)
           timer?.invalidate()
           
           // Создаем новый таймер, который будет обновлять метку каждую секунду
           timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
       }

       // Метод для обновления времени
       @objc func updateTime() {
           let currentDate = Date() // Получаем текущее время
           let formatter = DateFormatter()
           formatter.dateFormat = "HH:mm:ss" // Форматируем дату до секунд
           
           // Обновляем текст метки
           timeLabel.text = "Time: \(formatter.string(from: currentDate))"
       }

       // Метод для остановки таймера, если нужно
       func stopTimer() {
           timer?.invalidate()
       }
}

