//
//  WeatherModel.swift
//  Weather
//
//  Created by Doran on 9/15/24.
//

import Foundation

// MARK: - Welcome
struct CurrentWeatherModel: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: CurrentMain
    let visibility: Int
    let wind: Wind
    let rain: CurrentRain?
    let clouds: Clouds
    let dt: Int
    let sys: CurrentSys
    let timezone, id: Int
    let name: String
    let cod: Int
    
    //더미 데이터 생성 - GPT에게 생성 부탁했습니다.
    static let dummyCurrentData = CurrentWeatherModel(
        coord: Coord(lon: 139.6917, lat: 35.6895),
        weather: [
            Weather(id: 801, main: "Clouds", description: "few clouds", icon: "02d")
        ],
        base: "stations",
        main: CurrentMain(temp: 289.5, feelsLike: 288.5, tempMin: 288.0, tempMax: 290.0, pressure: 1013, humidity: 80, seaLevel: 1013, grndLevel: 1000),
        visibility: 10000,
        wind: Wind(speed: 5.1, deg: 210, gust: 6.2),
        rain: CurrentRain(the1H: 0.0),
        clouds: Clouds(all: 20),
        dt: 1618317040,
        sys: CurrentSys(type: 1, id: 8074, country: "JP", sunrise: 1618297922, sunset: 1618340280),
        timezone: 32400,
        id: 1850147,
        name: "hello",
        cod: 200
    )
}

// MARK: - Main
struct CurrentMain: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Rain
struct CurrentRain: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

// MARK: - Sys
struct CurrentSys: Codable {
    let type, id: Int?
    let country: String
    let sunrise, sunset: Int
}

