//
//  WeatherApp.swift
//  Weather
//
//  Created by Doran on 9/15/24.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var currentWeather = CurrentWeather()
    @StateObject private var fiveDaysWeather = FiveDaysWeather()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(currentWeather)
                .environmentObject(fiveDaysWeather)
        }
    }
}
