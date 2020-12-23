//
//  WeatherViewModel.swift
//  RxSwift_SampleApp
//
//  Created by Takahashi Shiko on 2020/12/22.
//

import Foundation
import RxSwift
import RxCocoa

struct WeatherViewModel {
    let weatherResult: WeatherResult
    
    init(result: WeatherResult) {
        self.weatherResult = result
    }
}

extension WeatherViewModel {
    var weather: Observable<String?> {
        return Observable<String?>.just(weatherResult.weather.first?.main)
    }
    
    var iconImage: Observable<UIImage?> {
        if let icon = weatherResult.weather.first?.icon,
           let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(icon).png"),
           let data = try? Data(contentsOf: imageUrl) {
            return Observable<UIImage?>.just(UIImage(data: data))
        } else {
            return Observable<UIImage?>.just(nil)
        }
    }
    
    var temp: Observable<String> {
        return Observable<String>.just("\(weatherResult.main.temp)℃")
    }
}
