//
//  widget.swift
//  widget
//
//  Created by Sayan Maity on 31/03/26.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct WidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            ZStack{
                VStack{
                    HStack{
                        Text("Username")
                            .foregroundStyle(.white)
                            .frame(width: 90)
                        Spacer()
                        Image("male_avatar")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                    }
                    Spacer()
                    HStack{
                        Text("No Ride Avaiable")
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    Button{
                        
                    }label: {
                        Text("Book Ride")
                            .foregroundStyle(.black)
                            .padding(10)
                            .background(Color.yellow)
                            .cornerRadius(20)
                    }.buttonStyle(.plain)
                        
                }
                    
            }.containerBackground(Color.black, for: .widget)
            
            

        case .systemMedium:
            Text("Medium")
                .containerBackground(.fill, for: .widget)

        case .systemLarge:
            Text("Large")
                .containerBackground(.fill, for: .widget)

        default:
            Text("Default")
                .containerBackground(.fill, for: .widget)
        }
    }
}

struct widget: Widget {
    let kind: String = "MyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("Shows useful info.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

#Preview("Small", as: .systemSmall) {
    widget()
} timeline: {
    SimpleEntry(date: .now)
}

#Preview("Medium", as: .systemMedium) {
    widget()
} timeline: {
    SimpleEntry(date: .now)
}

#Preview("Large", as: .systemLarge) {
    widget()
} timeline: {
    SimpleEntry(date: .now)
}
