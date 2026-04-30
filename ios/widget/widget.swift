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
        SimpleEntry(date: Date(), isBooked: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(SimpleEntry(date: Date(), isBooked: true))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: Date(), isBooked: true)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let isBooked: Bool

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
                        Text("Sayan")
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
            if entry.isBooked {
                ZStack {

                    // Background
                    LinearGradient(
                        colors: [Color.blue.opacity(0.25), Color.white],
                        startPoint: .top,
                        endPoint: .bottom
                    )

                    // Route line (A → B)
                    Path { path in
                        path.move(to: CGPoint(x: 30, y: 130))
                        path.addLine(to: CGPoint(x: 250, y: 40))
                    }
                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [6]))

                    // Pickup
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                        .position(x: 30, y: 130)

                    // Destination
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                        .position(x: 250, y: 40)

                    // Driver pulse
                    ZStack {
                        Circle()
                            .stroke(Color.blue.opacity(0.4), lineWidth: 2)
                            .frame(width: 40, height: 40)

                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                    }
                    .position(x: 140, y: 80)

                    // Top info
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Sayan")
                                    .font(.headline)

                                Text("Driver arriving")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)

                        Spacer()
                    }
                    .padding(10)
                }
                .containerBackground(.fill, for: .widget)

            } else {

                VStack(alignment: .leading, spacing: 8) {

                    Text("No active ride")
                        .font(.headline)

                    Text("Recent")
                        .font(.caption)
                        .foregroundColor(.gray)

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Office → Home")
                                .font(.subheadline)

                            Text("₹220 • Yesterday")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }

                        Spacer()
                    }

                    Spacer()
                }
                .padding()
                .containerBackground(.fill, for: .widget)
            }

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
    SimpleEntry(date: .now, isBooked: false)
}

#Preview("Medium", as: .systemMedium) {
    widget()
} timeline: {
    SimpleEntry(date: .now, isBooked: true)
}

#Preview("Large", as: .systemLarge) {
    widget()
} timeline: {
    SimpleEntry(date: .now, isBooked: false)
}
