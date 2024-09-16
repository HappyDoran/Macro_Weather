//
//  FiveDaysWeather.swift
//  Weather
//
//  Created by Doran on 9/16/24.
//

import Foundation

class FiveDaysWeather: ObservableObject {
    @Published var weather: FiveDaysWeatherModel = FiveDaysWeatherModel.dummyFiveDaysData
    
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    
    /// 현재의 날씨를 가져오는 메소드
    /// - Parameters:
    ///   - lat: 현재 위치의 위도
    ///   - lon: 현재 위치의 경도
    func getFiveDaysWeather() async throws {
        guard let apiKey = apiKey else { return }
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=44.34&lon=10.99&appid=\(apiKey)") else {
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
                self.weather = try JSONDecoder().decode(FiveDaysWeatherModel.self, from: data)
            }
            catch let error {
                print("Error decoding: ", error)
            }
        }
    }
}
