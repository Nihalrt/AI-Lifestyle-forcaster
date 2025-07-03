//
//  testingApp.swift
//  testing
//
//  Created by user on 2025-06-06.
//

import SwiftUI

@main
struct testingApp: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var weatherViewModel = WeatherViewModel()

    

    var body: some Scene {
        WindowGroup {
            MainTabView()
                // This modifier makes the themeManager available to MainTabView
                // and all of its child views (like ContentView and PlannerView).
                .environmentObject(themeManager)
                .environmentObject(weatherViewModel)

        }
    }
}
