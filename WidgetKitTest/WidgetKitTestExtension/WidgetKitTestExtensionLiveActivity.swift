//
//  WidgetKitTestExtensionLiveActivity.swift
//  WidgetKitTestExtension
//
//  Created by Taewon Yoon on 10/7/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetKitTestExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct WidgetKitTestExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: WidgetKitTestExtensionAttributes.self) { context in
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

extension WidgetKitTestExtensionAttributes {
    fileprivate static var preview: WidgetKitTestExtensionAttributes {
        WidgetKitTestExtensionAttributes(name: "World")
    }
}

extension WidgetKitTestExtensionAttributes.ContentState {
    fileprivate static var smiley: WidgetKitTestExtensionAttributes.ContentState {
        WidgetKitTestExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: WidgetKitTestExtensionAttributes.ContentState {
         WidgetKitTestExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: WidgetKitTestExtensionAttributes.preview) {
   WidgetKitTestExtensionLiveActivity()
} contentStates: {
    WidgetKitTestExtensionAttributes.ContentState.smiley
    WidgetKitTestExtensionAttributes.ContentState.starEyes
}
