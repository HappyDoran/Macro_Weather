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
    
    var body: some View {
        VStack {
            Text(currentWeather.weather.name)
            Text("Temperature: \(String(format: "%.1f", currentWeather.weather.main.temp))°C") // Double을 문자열로 변환
            Text("Wind Speed: \(String(format: "%.1f", currentWeather.weather.wind.speed)) m/s") // Wind speed
        }
        .task {
            await loadCurrentWeather()
            await loadFiveDaysWeather()
        }
    }
}

extension ContentView {
    private func loadCurrentWeather() async {
        do {
            try await currentWeather.getCurrentWeather()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadFiveDaysWeather() async {
        do {
            try await fiveDaysWeather.getFiveDaysWeather()
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
