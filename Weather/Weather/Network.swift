//
//  Network.swift
//  Weather
//
//  Created by Doran on 9/15/24.
//

import Foundation

class Network: ObservableObject {
    @Published var weather: CurrentWeatherModel = CurrentWeatherModel.dummyCurrentData
}
