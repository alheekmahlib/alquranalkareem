//
//  hijri_widgetLiveActivity.swift
//  hijri_widget
//
//  Created by Hawazen Mahmood on 4/20/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct hijri_widgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct hijri_widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: hijri_widgetAttributes.self) { context in
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

extension hijri_widgetAttributes {
    fileprivate static var preview: hijri_widgetAttributes {
        hijri_widgetAttributes(name: "World")
    }
}

extension hijri_widgetAttributes.ContentState {
    fileprivate static var smiley: hijri_widgetAttributes.ContentState {
        hijri_widgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: hijri_widgetAttributes.ContentState {
         hijri_widgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: hijri_widgetAttributes.preview) {
   hijri_widgetLiveActivity()
} contentStates: {
    hijri_widgetAttributes.ContentState.smiley
    hijri_widgetAttributes.ContentState.starEyes
}
