//
//  Weather.swift
//  RxSwift_SampleApp
//
//  Created by Takahashi Shiko on 2020/12/21.
//

import Foundation

struct WeatherResult: Decodable {
    let weather: [Weather]
    let main: Main
}

extension WeatherResult {
    static var empty: WeatherResult {
        return WeatherResult(weather: [Weather(main: "データ未取得", icon: nil)],
                             main: Main(temp: 0.0))
    }
}

struct Weather: Decodable {
    let main: String
    let icon: String?
}

struct Main: Decodable {
    let temp: Double
}
