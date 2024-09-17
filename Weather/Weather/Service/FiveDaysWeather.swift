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
    
    /// 5일의 날씨를 가져오는 메소드
    /// - Parameters:
    ///   - lat: 현재 위치의 위도
    ///   - lon: 현재 위치의 경도
    /// - Todo: 현재 날씨를 가져오는 메소드와 매우 흡사하기 때문에 합쳐서 하나의 서비스를 만들 수 있는 방법을 찾아봅시다.
    func getFiveDaysWeather(lat: Double, lon: Double) async throws {
        guard let apiKey = apiKey else { return }
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)") else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw NetworkError.badRequest
        }
        
        print(String(data: data, encoding: .utf8) ?? "No data")
        
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

