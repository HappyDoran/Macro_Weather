//
//  ContentView.swift
//  Weather
//
//  Created by Doran on 9/15/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var currentWeather: CurrentWeather
    @EnvironmentObject private var fiveDaysWeather: FiveDaysWeather
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack{
            Text(currentWeather.weather.name)
            Text(fiveDaysWeather.weather.city.name)
        }
        .onAppear{
            locationManager.checkLocationAuthorization()
            if let currentLocation = locationManager.currentLocation {
                Task {
                    await loadCurrentWeather(lat: currentLocation.latitude, lon: currentLocation.longitude)
                    await loadFiveDaysWeather(lat: currentLocation.latitude, lon: currentLocation.longitude)
                }
            }
        }
    }
}

extension ContentView {
    private func loadCurrentWeather(lat: Double, lon: Double) async {
        do {
            try await currentWeather.getCurrentWeather(lat: lat, lon: lon)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadFiveDaysWeather(lat: Double, lon: Double) async {
        do {
            try await fiveDaysWeather.getFiveDaysWeather(lat: lat, lon: lon)
        } catch {
            print(error.localizedDescription)
        }
    }
}

//#Preview {
//    ContentView().preferredColorScheme(.dark)
//}
