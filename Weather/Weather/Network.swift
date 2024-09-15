//
//  Network.swift
//  Weather
//
//  Created by Doran on 9/15/24.
//

import Foundation
import SwiftUI

enum NetworkError: Error {
    case badURL
    case badRequest
    case noData
    case decodingError
}

class CurrentWeather: ObservableObject {
    @Published var weather: CurrentWeatherModel = CurrentWeatherModel.dummyCurrentData
    
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String

    func getWeather() async throws {
        guard let apiKey = apiKey else { return }
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=37.497614076728404&lon=126.91145365297733&appid=\(apiKey)") else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw NetworkError.badRequest
        }
        DispatchQueue.main.async {
            do {
                self.weather = try JSONDecoder().decode(CurrentWeatherModel.self, from: data)
            }
            catch let error {
                print("Error decoding: ", error)
            }
        }
    }
}
