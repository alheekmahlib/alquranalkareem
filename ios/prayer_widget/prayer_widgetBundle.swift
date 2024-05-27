//
//  prayer_widgetBundle.swift
//  prayer_widget
//
//  Created by Hawazen Mahmood on 5/23/24.
//

import WidgetKit
import SwiftUI

@main
struct prayer_widgetBundle: WidgetBundle {
    var body: some Widget {
        PrayerWidget()
        prayer_widgetLiveActivity()
    }
}
