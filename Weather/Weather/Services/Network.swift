//
//  Weather.swift
//  Weather
//
//  Created by Doran on 9/19/24.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badRequest
    case noData
    case decodingError
}

@MainActor
class Network: ObservableObject {
    func fetchData<T: Decodable>(url: URL?) async throws -> T {
        guard let url = url else {
            throw NetworkError.badURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw NetworkError.badRequest
        }
        
        let weatherData = try JSONDecoder().decode(T.self, from: data) 
        
        return weatherData 
    }
}
