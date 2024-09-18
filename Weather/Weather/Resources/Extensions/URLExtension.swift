//
//  URLExtension.swift
//  Weather
//
//  Created by Doran on 9/19/24.
//

import Foundation

extension URL {
    static func getCurrentWeather(lat: Double, lon: Double) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Constant.apiKey)")
    }
}
