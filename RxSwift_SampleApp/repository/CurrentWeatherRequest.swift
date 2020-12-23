//
//  CurrentWeatherRequest.swift
//  RxSwift_SampleApp
//
//  Created by Takahashi Shiko on 2020/12/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct CurrentWeatherRequest {
    /// TODO: <API_KEY>は書き換えが必要
    static var baseUrl: String {
        return "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=<API_KEY>"
    }
    
    /// リクエストURL生成
    static func requestUrl(area: String) -> URL {
        let areaString = area.trimmingCharacters(in: .whitespaces)
        return URL(string: "\(baseUrl)&q=\(areaString)")!
    }
}

extension CurrentWeatherRequest {
    
    static func fetchWeatherFromAreaName(_ area: String) -> Observable<WeatherResult> {
        
        return Observable.just(requestUrl(area: area)).flatMap { url -> Observable<Data> in
            let request = URLRequest(url: url)
            return URLSession.shared.rx.data(request: request)
        }.map { data -> WeatherResult in
            return try JSONDecoder().decode(WeatherResult.self, from: data)
        }.asObservable()
    }
}
