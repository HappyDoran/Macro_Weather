//
//  FiveDaysWeatherModel.swift
//  Weather
//
//  Created by Doran on 9/15/24.
//

import Foundation

// MARK: - Welcome
struct FiveDaysWeatherModel: Codable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
    
    // 더미 데이터 생성
    static let dummyFiveDaysData = FiveDaysWeatherModel(
        cod: "200",
        message: 0,
        cnt: 7,
        list: [
            List(
                dt: 1618317040,
                main: FiveDaysMain(
                    temp: 289.5,
                    feelsLike: 288.5,
                    tempMin: 288.0,
                    tempMax: 290.0,
                    pressure: 1013,
                    seaLevel: 1013,
                    grndLevel: 1000,
                    humidity: 80,
                    tempKf: 0.0
                ),
                weather: [
                    Weather(id: 801, main: "Clouds", description: "few clouds", icon: "02d")
                ],
                clouds: Clouds(all: 20),
                wind: Wind(speed: 5.1, deg: 210, gust: 6.2),
                visibility: 10000,
                pop: 0.5,
                rain: FiveDaysRain(the3H: 0.0),
                sys: FiveDaysSys(pod: "d"),
                dtTxt: "2024-09-15 12:00:00"
            ),
            List(
                dt: 1618403440,
                main: FiveDaysMain(
                    temp: 290.0,
                    feelsLike: 289.0,
                    tempMin: 289.0,
                    tempMax: 291.0,
                    pressure: 1012,
                    seaLevel: 1012,
                    grndLevel: 1005,
                    humidity: 75,
                    tempKf: 0.0
                ),
                weather: [
                    Weather(id: 802, main: "Clouds", description: "scattered clouds", icon: "03d")
                ],
                clouds: Clouds(all: 40),
                wind: Wind(speed: 4.0, deg: 180, gust: 5.0),
                visibility: 10000,
                pop: 0.3,
                rain: FiveDaysRain(the3H: 1.0),
                sys: FiveDaysSys(pod: "d"),
                dtTxt: "2024-09-16 12:00:00"
            ),
            List(
                dt: 1618489840,
                main: FiveDaysMain(
                    temp: 292.0,
                    feelsLike: 291.0,
                    tempMin: 290.0,
                    tempMax: 293.0,
                    pressure: 1011,
                    seaLevel: 1011,
                    grndLevel: 1004,
                    humidity: 70,
                    tempKf: 0.0
                ),
                weather: [
                    Weather(id: 803, main: "Clouds", description: "broken clouds", icon: "04d")
                ],
                clouds: Clouds(all: 50),
                wind: Wind(speed: 3.5, deg: 150, gust: 4.5),
                visibility: 10000,
                pop: 0.2,
                rain: FiveDaysRain(the3H: 0.5),
                sys: FiveDaysSys(pod: "d"),
                dtTxt: "2024-09-17 12:00:00"
            ),
            List(
                dt: 1618576240,
                main: FiveDaysMain(
                    temp: 293.5,
                    feelsLike: 292.5,
                    tempMin: 291.0,
                    tempMax: 294.0,
                    pressure: 1010,
                    seaLevel: 1010,
                    grndLevel: 1003,
                    humidity: 65,
                    tempKf: 0.0
                ),
                weather: [
                    Weather(id: 804, main: "Clouds", description: "overcast clouds", icon: "04n")
                ],
                clouds: Clouds(all: 80),
                wind: Wind(speed: 2.5, deg: 120, gust: 3.0),
                visibility: 10000,
                pop: 0.1,
                rain: FiveDaysRain(the3H: 0.0),
                sys: FiveDaysSys(pod: "n"),
                dtTxt: "2024-09-18 12:00:00"
            ),
            List(
                dt: 1618662640,
                main: FiveDaysMain(
                    temp: 295.0,
                    feelsLike: 294.0,
                    tempMin: 292.0,
                    tempMax: 296.0,
                    pressure: 1009,
                    seaLevel: 1009,
                    grndLevel: 1002,
                    humidity: 60,
                    tempKf: 0.0
                ),
                weather: [
                    Weather(id: 805, main: "Rain", description: "light rain", icon: "10d")
                ],
                clouds: Clouds(all: 90),
                wind: Wind(speed: 3.0, deg: 100, gust: 4.0),
                visibility: 10000,
                pop: 0.7,
                rain: FiveDaysRain(the3H: 2.0),
                sys: FiveDaysSys(pod: "d"),
                dtTxt: "2024-09-19 12:00:00"
            )
        ],
        city: City(
            id: 1850147,
            name: "Tokyo",
            coord: Coord(lon: 139.6917, lat: 35.6895),
            country: "JP",
            population: 13929286,
            timezone: 32400,
            sunrise: 1618297922,
            sunset: 1618340280
        )
    )

}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: FiveDaysMain
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: FiveDaysRain?
    let sys: FiveDaysSys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Main
struct FiveDaysMain: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct FiveDaysRain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct FiveDaysSys: Codable {
    let pod: String
}

