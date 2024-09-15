//
//  CommonModel.swift
//  Weather
//
//  Created by Doran on 9/15/24.
//

import Foundation

// MARK: - Clouds_All
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord_All
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Weather_All
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind_All
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
