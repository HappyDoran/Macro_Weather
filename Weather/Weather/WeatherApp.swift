//
//  WeatherApp.swift
//  Weather
//
//  Created by Doran on 9/15/24.
//

import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var network = Network()
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(network)
                .environmentObject(locationManager)
        }
    }
}
