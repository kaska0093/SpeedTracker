//
//  WidgetView.swift
//  SpeedTracker
//
//  Created by Nikita Shestakov on 07.12.2024.
//


import SwiftUI
import WidgetKit

struct EmojiWidgetView: View {
  let widgetFamily: WidgetFamily  // Размер виджета
  let emojiDetails: EmojiDetails
  var entryDate: Date

  var body: some View {
    ZStack {
      Color(UIColor.systemIndigo)
      VStack {
          if widgetFamily != .systemSmall {
              Text(formatDate(entryDate)) // Используем форматированную строку времени
                  .font(.largeTitle)
                  .bold()
          }
        Text(emojiDetails.emoji)
          .font(.system(size: 56))
        Text(emojiDetails.name)
          .font(.headline)
          .multilineTextAlignment(.center)
          .padding(.top, 5)
          .padding([.leading, .trailing])
          .foregroundColor(.white)
      }
    }
  }
    
    // Функция для форматирования времени с секундами
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss" // Формат: часы:минуты:секунды
        return formatter.string(from: date)
    }
}

