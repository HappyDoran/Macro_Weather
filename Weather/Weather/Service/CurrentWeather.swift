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
    
    /// 현재의 날씨를 가져오는 메소드
    /// - Parameters:
    ///   - lat: 현재 위치의 위도
    ///   - lon: 현재 위치의 경도
    func getCurrentWeather(lat: Double, lon: Double) async throws {
        guard let apiKey = apiKey else { return }
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)") else {
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
