//
//  ZikerWidgetBundle.swift
//  ZikerWidget
//
//  Created by Hawazen Mahmood on 3/31/23.
//

import WidgetKit
import SwiftUI

@main
struct ZikerWidgetBundle: WidgetBundle {
    var body: some Widget {
        ZikerWidget()
        HijriDateWidget()
    }
}
