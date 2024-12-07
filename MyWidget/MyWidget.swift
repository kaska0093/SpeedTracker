//
//  MyWidget.swift
//  MyWidget
//
//  Created by Nikita Shestakov on 07.12.2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    @AppStorage("emoji", store: UserDefaults(suiteName: "group.com.kaska.SpeedTracker"))
    var emojiData = Data()
    //let currentDate: Date
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emojiDetails: EmojiProvider.random(), widgetFamily: context.family)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {

            guard let emoji = try? JSONDecoder().decode(EmojiDetails.self, from: emojiData) else {
                print("Failed to decode emoji data in snapshot")
                return
            }
            let entry = SimpleEntry(date: Date(), emojiDetails: emoji, widgetFamily: context.family)
            completion(entry)

    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Попытка декодировать emoji
        guard let emoji = try? JSONDecoder().decode(EmojiDetails.self, from: emojiData) else {
            print("Failed to decode emoji data")
            // Можно использовать запасные данные или вернуть пустой timeline
            let entry = SimpleEntry(date: Date(), emojiDetails: EmojiDetails(emoji: "❓", name: "-", description: "Unknown"), widgetFamily: context.family)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
            return
        }

        // Генерация записей для timeline
        let currentDate = Date()
        for secondOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emojiDetails: emoji, widgetFamily: context.family)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emojiDetails: EmojiDetails
    let widgetFamily: WidgetFamily // Добавляем поле для widgetFamily
}

struct MyWidgetEntryView : View {
    var entry: Provider.Entry

        var body: some View {
            EmojiWidgetView(widgetFamily: entry.widgetFamily, emojiDetails: entry.emojiDetails, entryDate: entry.date)
        }
}

struct MyWidget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                MyWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                MyWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("MyWidget")
        .description("This is an example widget.")
    }
}

//Preview(as: .systemSmall) {
//    MyWidget()
//} timeline: {
//    SimpleEntry(date: .now, emojiDetails: .init(emoji: "🤩", name: "", description: ""))
//}
