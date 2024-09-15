//
//  ContentView.swift
//  Weather
//
//  Created by Doran on 9/15/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var currentWeather: CurrentWeather
    
    var body: some View {
        VStack {
            Text(currentWeather.weather.name)
        }
        .task {
            await populateProducts()
        }
    }
    
    private func populateProducts() async {
        do {
            try await currentWeather.getWeather()
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
