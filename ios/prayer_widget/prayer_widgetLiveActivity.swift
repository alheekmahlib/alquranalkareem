//
//  hijri_widgetLiveActivity.swift
//  hijri_widget
//
//  Created by Hawazen Mahmood on 4/20/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct prayer_widgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct prayer_widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: prayer_widgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension prayer_widgetAttributes {
    fileprivate static var preview: prayer_widgetAttributes {
        prayer_widgetAttributes(name: "World")
    }
}

extension prayer_widgetAttributes.ContentState {
    fileprivate static var smiley: prayer_widgetAttributes.ContentState {
        prayer_widgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: prayer_widgetAttributes.ContentState {
         prayer_widgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: prayer_widgetAttributes.preview) {
    prayer_widgetLiveActivity()
} contentStates: {
    prayer_widgetAttributes.ContentState.smiley
    prayer_widgetAttributes.ContentState.starEyes
}
