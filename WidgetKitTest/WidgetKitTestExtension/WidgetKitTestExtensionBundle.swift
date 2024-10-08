//
//  WidgetKitTestExtensionBundle.swift
//  WidgetKitTestExtension
//
//  Created by Taewon Yoon on 10/7/24.
//

import WidgetKit
import SwiftUI

@main
struct WidgetKitTestExtensionBundle: WidgetBundle {
    var body: some Widget {
        WidgetKitTestExtension()
        WidgetKitTestExtensionControl()
        WidgetKitTestExtensionLiveActivity()
    }
}
