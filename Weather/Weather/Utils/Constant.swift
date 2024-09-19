//
//  Constant.swift
//  Weather
//
//  Created by Doran on 9/19/24.
//

import Foundation

struct Constant {
    static let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as! String
}
