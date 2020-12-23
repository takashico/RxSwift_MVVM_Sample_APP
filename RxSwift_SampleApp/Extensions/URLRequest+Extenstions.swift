//
//  URLRequest+Extenstions.swift
//  RxSwift_SampleApp
//
//  Created by Takahashi Shiko on 2020/12/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct Resource<T> {
    let url: URL
}

// TODO: 修正する必要あり
extension URLRequest {
    
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        // urlRequestしたデータを流し直すのでflatMapを使用
        // 以降の加工はmapを使用する
        return Observable.just(resource.url).flatMap { url -> Observable<Data> in
            let request = URLRequest(url: url)
            return URLSession.shared.rx.data(request: request)
        }.map{ data -> T in
            return try JSONDecoder().decode(T.self, from: data)
        }.asObservable()
    }
}
